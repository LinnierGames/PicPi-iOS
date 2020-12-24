//
//  Photo.swift
//  PicPi
//
//  Created by Erick Sanchez on 12/23/20.
//

import Promises

func injectPictureFrameContent(media: [Photo]) -> PictureFrameContent {
  PictureFrameContentImpl(media: media)
}

private class PictureFrameContentImpl: PictureFrameContent {
  let didUpdate = Event<Void>()
  let media: [Photo]

  init(media: [Photo]) {
    self.media = media
  }

  func expand() -> Promise<Void> {
    fatalError()
  }
}
