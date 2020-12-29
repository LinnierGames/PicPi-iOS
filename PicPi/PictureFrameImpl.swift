//
//  PictureFrameImpl.swift
//  PicPi
//
//  Created by Erick Sanchez on 12/23/20.
//

import Promises

func injectPictureFrame(ip: String, host: URL) -> PictureFrame {
  PictureFrameImpl(frameAPI: injectFrameAPI(host: host), ip: ip)
}

private class PictureFrameImpl: PictureFrame {
  var id: String { ip }
  var name: String { ip }
  var isConnected: Bool {
    // TODO: Display connection status.
    fatalError("not implemented, yet")
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
          filename: "thumbnail.filename", // TODO: Use filename from FrameAPI response.
          thumbnail: thumbnail,
          fullImage: thumbnail
        )
      }

      return injectPictureFrameContent(media: media)
    }
  }

  func storeMedia(images: [MediaProvider]) -> MediaUploaderSession {
    UploaderSession(
      payload: images,
      uploader: { [frameAPI] imageProvider in
        imageProvider.get().then { payload in
          frameAPI.upload(photoData: payload.data, filename: payload.filename).then {
            return payload.filename
          }
        }
      },
      options: []
    )
  }

  func set(name: String) -> Promise<Void> {
    fatalError("not implemented, yet")
  }

  func preferences() -> Promise<PictureFramePreferences> {
    fatalError("not implemented, yet")
  }

  func set(preferences: PictureFramePreferences) -> Promise<Void> {
    fatalError("not implemented, yet")
  }

  func forget() -> Promise<Void> {
    fatalError("not implemented, yet")
  }
}
