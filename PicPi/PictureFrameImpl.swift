import Promises

class PictureFrameImpl: PictureFrame {
  var name: String {
    fatalError()
  }
  var isConnected: Bool {
    fatalError()
  }

  private let frameAPI: FrameAPI

  init(frameAPI: FrameAPI) {
    self.frameAPI = frameAPI
  }

  func content() -> Promise<PictureFrameContent> {
    frameAPI.retrieveThumbnails().then { thumbnails -> PictureFrameContent in
      let media = thumbnails.map { thumbnail in
        PhotoImpl(
          frameAPI: self.frameAPI,
          filename: "thumbnail.filename",
          thumbnailURL: thumbnail,
          imageURL: thumbnail
        )
//        PhotoImpl(
//          frameAPI: frameAPI,
//          filename: thumbnail.filename,
//          thumbnailURL: thumbnail.thumbnail,
//          imageURL: thumbnail.imageURL
//        )
      }

      return PictureFrameContentImpl(media: media)
    }
  }

  func storeMedia(
    images: [MediaProvider]
  ) -> UploaderSession<MediaProvider, String> {
    UploaderSession(
      payload: images,
      uploader: { [frameAPI] imageProvider in
        imageProvider.map().then { payload in
          frameAPI.upload(photoData: payload.data, filename: payload.filename).then {
            return payload.filename
          }
        }
      },
      options: []
    )
  }

  func set(name: String) -> Promise<Void> {
    .pending()
  }

  func preferences() -> Promise<PictureFramePreferences> {
    .pending()
  }

  func set(preferences: PictureFramePreferences) -> Promise<Void> {
    .pending()
  }

  func forget() -> Promise<Void> {
    .pending()
  }
}
