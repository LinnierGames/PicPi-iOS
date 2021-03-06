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

internal class PictureFrameImpl: PictureFrame {
  var id: String { ip }
  var name: String { ip }
  var isConnected: Bool {
    // TODO: Display connection status.
    fatalError("not implemented, yet")
  }

  private let frameAPI: FrameAPI

  private let ip: String
  private let userPreferences: UserPreferences

  init(frameAPI: FrameAPI, ip: String, userPreferences: UserPreferences = injectUserPreferences()) {
    self.userPreferences = userPreferences
    self.frameAPI = frameAPI
    self.ip = ip
  }

  func content() -> Promise<PictureFrameContent> {
    frameAPI.retrievePhotosInfo().then { thumbnails -> PictureFrameContent in
      let media = thumbnails.map { photoData in
        injectPhoto(
          frameAPI: self.frameAPI,
          filename: photoData.filename,
          thumbnail: photoData.thumbnail,
          fullImage: photoData.image
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
    frameAPI.retrievePIPrefrences()
  }

  func set(preferences: PictureFramePreferences) -> Promise<Void> {
    frameAPI.updatePI(preferences: preferences)
  }

  func forget() -> Promise<Void> {
    Promise { resolve, _ in
      self.userPreferences.remove(ipAddress: self.ip)
      resolve(())
    }
  }
}
