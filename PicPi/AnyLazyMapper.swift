import Promises

/// Typed-ereased `LazyMapper`.
class AnyLazyMapper<MappedValue>: LazyMapper {
  private let mapper: AbstractBaseLazyMapper<MappedValue>

  init<T: LazyMapper>(_ mapper: T) where T.MappedValue == MappedValue {
    self.mapper = BaseLazyMapper(mapper)
  }

  func map() -> Promise<MappedValue> {
    mapper.map()
  }
}

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
