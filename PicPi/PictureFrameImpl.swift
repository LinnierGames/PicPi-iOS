//
//  Photo.swift
//  PicPi
//
//  Created by Erick Sanchez on 12/23/20.
//

import Promises

func injectPictureFrame(ip: String, host: URL) -> PictureFrame {
  PictureFrameImpl(frameAPI: injectFrameAPI(host: host), ip: ip)
}

private class PictureFrameImpl: PictureFrame {
  var name: String {
    fatalError()
  }
  var isConnected: Bool {
    fatalError()
  }

  private let frameAPI: FrameAPI

  private let ip: String

  init(frameAPI: FrameAPI, ip: String) {
    self.frameAPI = frameAPI
    self.ip = ip
  }

  func content() -> Promise<PictureFrameContent> {
    frameAPI.retrieveThumbnails().then { thumbnails -> PictureFrameContent in
      let media = thumbnails.map { thumbnail in
        injectPhoto(
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

      return injectPictureFrameContent(media: media)
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
