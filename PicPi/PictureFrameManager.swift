//
//  PictureFrameManager.swift
//  PicPi
//
//  Created by Erick Sanchez on 12/19/20.
//

import UIKit
import Promises

struct PhotoData {
  let filename: String
  let thumbnail: URL
  let imageURL: URL
}

protocol FrameAPI {
  func thumbnails() -> [PhotoData]
  func removePhoto(filename: String) -> Promise<Void>
}

struct NetworkDevice {
  let name: String
  let ip: String
}

class PictureFrameImpl: PictureFrame {
  var name: String
  var isConnected: Bool

  private let frameAPI: FrameAPI

  init(frameAPI: FrameAPI) {
    self.frameAPI = frameAPI
  }

  func content() -> Promise<PictureFrameContent> {
    let media = frameAPI.thumbnails().map { thumbnail in
      PhotoImpl(
        frameAPI: frameAPI,
        filename: thumbnail.filename,
        thumbnailURL: thumbnail.thumbnail,
        imageURL: thumbnail.imageURL
      )
    }

    let content = PictureFrameContentImpl(media: media)

    return Promise()
  }

  func store(_ media: Media) -> MediaUploaderSession {
    <#code#>
  }

  func set(name: String) -> Promise<Void> {
    <#code#>
  }

  func preferences() -> Promise<PictureFramePreferences> {
    <#code#>
  }

  func set(preferences: PictureFramePreferences) -> Promise<Void> {
    <#code#>
  }

  func forget() -> Promise<Void> {
    <#code#>
  }
}

class PictureFrameContentImpl: PictureFrameContent {
  let didUpdate = Event<Void>()
  let media: [Photo]

  init(media: [Photo]) {
    self.media = media
  }

  func expand() -> Promise<Void> {
    fatalError()
  }
}

class PhotoImpl: Photo {
  let filename: String
  let thumbnailURL: URL
  let imageURL: URL

  private let frameAPI: FrameAPI

  init(frameAPI: FrameAPI, filename: String, thumbnailURL: URL, imageURL: URL) {
    self.frameAPI = frameAPI
    self.filename = filename
    self.thumbnailURL = thumbnailURL
    self.imageURL = imageURL
  }

  func removeFromFrame() -> Promise<Void> {
    frameAPI.removePhoto(filename: filename)
  }
}

class PictureFrameManagerImpl: PictureFrameManager {
  private let userPreferences: UserPreferences

  init(userPreferences: UserPreferences = injectUserPreferences()) {
    self.userPreferences = userPreferences
  }
  func searchForFrames() -> Promise<[UnregisteredPictureFrame]> {
    fatalError()
  }

  func registeredFrames() -> Promise<[PictureFrame]> {
    let ips = userPreferences.ipAddresses()
    let frames = ips.map(PictureFrameImpl.init)

    return Promise()
  }


}

class NetworkScanner {
  func scan(filter: String) -> Promise<NetworkDevice> {


    return Promise()
  }
}

protocol PictureFrameManager {

  /// Searches for picture frames connected to the same network.
  func searchForFrames() -> Promise<[UnregisteredPictureFrame]>

  /// List of saved picture frames.
  func registeredFrames() -> Promise<[PictureFrame]>
}

protocol UnregisteredPictureFrame {

  /// User defined name of the picture frame.
  var name: String { get }

  /// Connect and register this picture frame to the device.
  func connect() -> Promise<Void>
}

protocol PictureFrame {

  /// User defined name of the picture frame.
  var name: String { get }

  /// Connection status of the picture frame.
  var isConnected: Bool { get }

  /// Fetch the media stored on the picture frame.
  func content() -> Promise<PictureFrameContent>

  /// Send media to be stored in the picture frame.
  func store(_ media: Media) -> MediaUploaderSession

  /// Update the user defined name of the picture frame.
  func set(name: String) -> Promise<Void>

  /// Fetch the picture frame perferences.
  func preferences() -> Promise<PictureFramePreferences>

  /// Update the preferences of the picture frame.
  func set(preferences: PictureFramePreferences) -> Promise<Void>

  /// Disconnect and unregister this picture frame from the device.
  func forget() -> Promise<Void>
}

// Other classes to be moved to other files

struct Film {
  enum Content {
    case image(UIImage)
    case movie(Data)
  }
  let title: String
  let content: Content
}
struct Media: Collection {
  private let media: [Film]

  init(_ media: [Film]) {
    self.media = media
  }

  var startIndex: Int { return self.media.startIndex }
  var endIndex: Int { return self.media.endIndex }

  subscript(index: Int) -> Film {
    return self.media[index]
  }

  func index(after index: Int) -> Index {
    return self.media.index(after: index)
  }
}

protocol PictureFrameContent {
  /// New content is availble.
  var didUpdate: Event<Void> { get }

  /// List of thumbnails.
  var media: [Photo] { get }

  /// Fetch the next set of thumbnails.
  func expand() -> Promise<Void>
}

protocol Photo {
  var thumbnailURL: URL { get }
  var imageURL: URL { get }

  /// Remove the image from the picture frame.
  func removeFromFrame() -> Promise<Void>
}

struct UploaderOptions: OptionSet {
  let rawValue: Int

  static let concurrent = UploaderOptions(rawValue: 1 << 0)
  static let stopIfError = UploaderOptions(rawValue: 1 << 1)
}

typealias MediaUploaderSession = UploaderSession<Media>

class UploaderSession<Payload> {

  /// Event of the result of each upload attempt.
  let didFinishUpload = Event<Result<Payload, Error>>()

  /// Event of the completion of uploading all elements.
  let didCompleteSession = Event<Bool>()

  init<T: Collection>(
    payload: T,
    uploader: @escaping (Payload) -> Promise<Void>,
    options: UploaderOptions
  ) where T.Element == Payload {
  }
}

struct PictureFramePreferences {
  let slideshowDuration: TimeInterval
  let connectionPasscode: String
}

// Fake types for now

 
class Task<PromiseValue> {
  init(_ work: @escaping () -> PromiseValue) {
  }

  func run(on queue: DispatchQueue) -> Promise<PromiseValue> {
    fatalError()
  }
}
class Event<Value> {
  func add(subscriber: AnyObject, subscription: @escaping (Value) -> Void) {}
  func publish(_ event: Value) {}
}
