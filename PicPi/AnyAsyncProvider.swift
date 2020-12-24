//
//  Photo.swift
//  PicPi
//
//  Created by Erick Sanchez on 12/23/20.
//

import Promises

/// Typed-ereased `AsyncProviderProtocol`.
class AnyAsyncProvider<Value>: AsyncProviderProtocol {
  private let provider: AbstractAsyncProvider<Value>

  init<T: AsyncProviderProtocol>(_ provider: T) where T.Value == Value {
    self.provider = BaseAsyncProvider(provider)
  }

  func get() -> Promise<Value> {
    provider.get()
  }
}

// MARK: - Private

private class BaseAsyncProvider<
  Value,
  Provider: AsyncProviderProtocol
>: AbstractAsyncProvider<Value> where Provider.Value == Value {
  let provider: Provider

  init(_ provider: Provider) {
    self.provider = provider
  }

  override func get() -> Promise<Value> {
    provider.get()
  }
}

private class AbstractAsyncProvider<Value>: AsyncProviderProtocol {
  func get() -> Promise<Value> {
    fatalError()
  }
}
