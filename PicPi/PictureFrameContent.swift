//
//  PictureFrameContent.swift
//  PicPi
//
//  Created by Erick Sanchez on 12/23/20.
//

import Promises

protocol PictureFrameContent {
  /// New content is availble.
  var didUpdate: Event<Void> { get }

  /// List of thumbnails.
  var media: [Photo] { get }

  /// Fetch the next set of thumbnails.
  func expand() -> Promise<Void>
}
