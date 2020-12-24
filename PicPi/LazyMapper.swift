import Promises

/// Lazily map a value async.
protocol LazyMapper {
  associatedtype MappedValue
  func map() -> Promise<MappedValue>
}

extension LazyMapper {
  /// Hide the underlaying implementor with a type-ereaser.
  func ereased() -> AnyLazyMapper<MappedValue> {
    AnyLazyMapper(self)
  }
}
