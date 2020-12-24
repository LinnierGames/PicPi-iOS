//
//  Photo.swift
//  PicPi
//
//  Created by Erick Sanchez on 12/23/20.
//

import Foundation
import Promises

func injectPhoto(frameAPI: FrameAPI, filename: String, thumbnailURL: URL, imageURL: URL) -> Photo {
  PhotoImpl(frameAPI: frameAPI, filename: filename, thumbnailURL: thumbnailURL, imageURL: imageURL)
}

private class PhotoImpl: Photo {
  let filename: String
  let thumbnailURL: URL
  let imageURL: URL

  private let frameAPI: FrameAPI

  init(frameAPI: FrameAPI, filename: String, thumbnailURL: URL, imageURL: URL) {
    self.frameAPI = frameAPI
    self.filename = filename
    self.thumbnailURL = thumbnailURL
    self.imageURL = imageURL
  }

  func removeFromFrame() -> Promise<Void> {
    frameAPI.removePhoto(filename: filename)
  }
}
