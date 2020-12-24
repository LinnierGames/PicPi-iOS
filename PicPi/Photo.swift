//
//  Photo.swift
//  PicPi
//
//  Created by Erick Sanchez on 12/23/20.
//

import Foundation
import Promises

protocol Photo {
  var thumbnailURL: URL { get }
  var imageURL: URL { get }

  /// Remove the image from the picture frame.
  func removeFromFrame() -> Promise<Void>
}
