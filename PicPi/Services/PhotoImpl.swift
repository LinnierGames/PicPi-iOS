//
//  PhotoImpl.swift
//  PicPi
//
//  Created by Erick Sanchez on 12/23/20.
//

import Foundation
import Promises

func injectPhoto(frameAPI: FrameAPI, filename: String, thumbnail: URL, fullImage: URL) -> Photo {
  PhotoImpl(frameAPI: frameAPI, filename: filename, thumbnail: thumbnail, fullImage: fullImage)
}

private class PhotoImpl: Photo {
  let filename: String
  let thumbnail: URL
  let fullImage: URL

  private let frameAPI: FrameAPI

  init(frameAPI: FrameAPI, filename: String, thumbnail: URL, fullImage: URL) {
    self.frameAPI = frameAPI
    self.filename = filename
    self.thumbnail = thumbnail
    self.fullImage = fullImage
  }

  func removeFromFrame() -> Promise<Void> {
    frameAPI.removePhoto(filename: filename)
  }
  
  func replaceImage(newImage: UIImage) -> Promise<Void> {
    guard let imageData = newImage.pngData() else { return Promise { } }
    return frameAPI.upload(photoData: imageData, filename: filename)
  }
}
