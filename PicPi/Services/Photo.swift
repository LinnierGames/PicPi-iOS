//
//  Photo.swift
//  PicPi
//
//  Created by Erick Sanchez on 12/23/20.
//

import Foundation
import Promises

protocol Photo {
  var filename: String { get }
  var thumbnail: URL { get }
  var fullImage: URL { get }

  /// Remove the image from the picture frame.
  func removeFromFrame() -> Promise<Void>
  
  /// Update the image with the given `newImage`
  func replaceImage(newImage: UIImage) -> Promise<Void>
}
