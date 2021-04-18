//
//  Photo.swift
//  PicPi
//
//  Created by Erick Sanchez on 12/23/20.
//

import Promises

/// Lazily get a value async.
// sourcery: skip
protocol AsyncProviderProtocol {
  associatedtype Value
  func get() -> Promise<Value>
}

extension AsyncProviderProtocol {
  /// Hide the underlaying implementor with a type-ereaser.
  func ereased() -> AnyAsyncProvider<Value> {
    AnyAsyncProvider(self)
  }
}
