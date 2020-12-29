//
//  Array+Providers.swift
//  PicPi
//
//  Created by Erick Sanchez on 12/24/20.
//

import Promises

extension Array {
  /// Map the receiver with the given async block to be executed later.
  ///
  /// ```
  /// func doSomeHeavlyLiftingWork(theGoods: Data) -> Promise<UIImage> {
  ///   ...
  /// }
  ///
  /// let data: [Data] = [...]
  /// let imageProiders: [Provider<Promise<UIImage>>] = data.wrapAsync { data in
  ///   doSomeHeavyLiftingWork(theGoods: data)
  /// }
  ///
  /// // Later in life ...
  /// for imageProvider in imageProviders {
  ///   imageProvider.get().then { image in
  ///     self.doSomething(image: image)
  ///   }
  /// }
  /// ```
  func wrap<Value>(_ mapper: @escaping (Element) -> Value) -> [Provider<Value>] {
    self.map { element in
      Provider {
        mapper(element)
      }
    }
  }
}
