//
//  Photo.swift
//  PicPi
//
//  Created by Erick Sanchez on 12/23/20.
//

import Promises

/// Typed-ereased `LazyMapper`.
class AnyAsyncMapper<MappedValue>: LazyMapper {
  private let mapper: AbstractBaseLazyMapper<MappedValue>

  init<T: LazyMapper>(_ mapper: T) where T.MappedValue == MappedValue {
    self.mapper = BaseLazyMapper(mapper)
  }

  func map() -> Promise<MappedValue> {
    mapper.map()
  }
}

class ClosureMapper<MappedValue>: LazyMapper {
  private let closure: () -> Promise<MappedValue>

  init(_ closure: @escaping () -> Promise<MappedValue>) {
    self.closure = closure
  }

  func map() -> Promise<MappedValue> {
    closure()
  }
}

extension Array {
  /// <#Description#>
  /// - Parameter mapper: <#mapper description#>
  /// - Returns: <#description#>
  func mapAsync<MappedValue>(_ mapper: @escaping (Element) -> Promise<MappedValue>) -> [AnyAsyncMapper<MappedValue>] {
    self.map { element in
      ClosureMapper {
        mapper(element)
      }.ereased()
    }
  }
}

// MARK: - Private

private class BaseLazyMapper<
  MappedValue,
  Mapper: LazyMapper
>: AbstractBaseLazyMapper<MappedValue> where Mapper.MappedValue == MappedValue {
  let mapper: Mapper

  init(_ mapper: Mapper) {
    self.mapper = mapper
  }

  override func map() -> Promise<MappedValue> {
    mapper.map()
  }
}

private class AbstractBaseLazyMapper<MappedValue>: LazyMapper {
  func map() -> Promise<MappedValue> {
    fatalError()
  }
}
