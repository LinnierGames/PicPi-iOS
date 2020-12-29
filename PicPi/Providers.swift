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
