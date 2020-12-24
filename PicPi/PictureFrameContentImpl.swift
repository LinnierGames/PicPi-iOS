import Promises

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
