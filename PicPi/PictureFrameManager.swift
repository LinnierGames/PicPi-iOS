//
//  Photo.swift
//  PicPi
//
//  Created by Erick Sanchez on 12/23/20.
//

import Promises

protocol PictureFrameManager {

  /// Searches for picture frames connected to the same network.
  func searchForFrames() -> Promise<[UnregisteredPictureFrame]>

  /// List of saved picture frames.
  func registeredFrames() -> Promise<[PictureFrame]>
}
