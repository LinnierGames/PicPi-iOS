//
//  Photo.swift
//  PicPi
//
//  Created by Erick Sanchez on 12/23/20.
//

import Foundation
import Promises

struct UploaderOptions: OptionSet {
  let rawValue: Int

  static let concurrent = UploaderOptions(rawValue: 1 << 0)
  static let stopIfError = UploaderOptions(rawValue: 1 << 1)
}

/// Invokes the given uploader method with the given collection.
class UploaderSession<Payload, Product> {
  private let lockQueue = DispatchQueue(label: "UploaderSession")

  private let uploader: (Payload) -> Promise<Product>
  private let options: UploaderOptions
  private var payloadIterator: AnyIterator<Payload>

  private var _noError = false {
    didSet { dispatchPrecondition(condition: DispatchPredicate.onQueue(self.lockQueue)) }
  }
  private var noError: Bool {
    self.lockQueue.sync { self._noError }
  }
  private var _halt = false {
    didSet { dispatchPrecondition(condition: DispatchPredicate.onQueue(self.lockQueue)) }
  }
  private var halt: Bool {
    self.lockQueue.sync { self._halt }
  }

  private(set) var isCompleted = false

  /// Event of the result of each upload attempt.
  let didFinishUpload = Event<Result<(payload: Payload, product: Product), Error>>()

  /// Event of the completion of uploading all elements.
  /// - Returns: bool if the upload completed without any errors.
  let didCompleteSession = Event<Bool>()

  init<T: Collection>(
    payload: T,
    uploader: @escaping (Payload) -> Promise<Product>,
    options: UploaderOptions
  ) where T.Element == Payload {
    self.payloadIterator = AnyIterator(payload.makeIterator())
    self.uploader = uploader
    self.options = options

    self.start().then {
      self.isCompleted = true
      self.didCompleteSession.publish(!self.halt && self.noError)
    }
  }

  private func start() -> Promise<Void> {
    if self.options.contains(.concurrent) {
      return self.nextConcurrent()
    } else {
      return self.next()
    }
  }

  private func nextConcurrent() -> Promise<Void> {
    let promises = self.payloadIterator.map { payload in
      self.uploader(payload).then { product in
        self.didFinishUpload.publish(.success((payload, product)))
      }.catch { error in
        if self.options.contains(.stopIfError) {
          self.lockQueue.async {
            // TODO: Add checking for halt in the uploader closure.
            self._halt = true
          }
        }

        self.lockQueue.async {
          self._noError = false
        }
        self.didFinishUpload.publish(.failure(error))
      }
    }

    return all(promises).then { _ in }
  }

  private func next() -> Promise<Void> {
    guard let payload = payloadIterator.next() else { return Promise {} }

    return self.uploader(payload).then { product in
      self.didFinishUpload.publish(.success((payload, product)))
    }.catch { error in
      if self.options.contains(.stopIfError) {
        self.lockQueue.async {
          self._halt = true
        }
      }

      self.lockQueue.async {
        self._noError = false
      }
      self.didFinishUpload.publish(.failure(error))
    }.recover { _ in
    }.then { () -> Promise<Void> in
      guard self.halt != true else { return Promise {} }
      return self.next()
    }
  }
}
