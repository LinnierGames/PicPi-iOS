//
//  Providers.swift
//  PicPi
//
//  Created by Erick Sanchez on 12/24/20.
//

import Promises

class Provider<Value> {
  private let closure: () -> Value

  init(_ closure: @escaping () -> Value) {
    self.closure = closure
  }

  func get() -> Value {
    closure()
  }
}

class AsyncProvider<Value> {
  private let closure: () -> Promise<Value>

  init(_ closure: @escaping () -> Promise<Value>) {
    self.closure = closure
  }

  func get() -> Promise<Value> {
    closure()
  }
}
