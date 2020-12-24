//
//  Photo.swift
//  PicPi
//
//  Created by Erick Sanchez on 12/23/20.
//

import Foundation
import Promises

typealias MediaProvider = AnyLazyMapper<(data: Data, filename: String)>

protocol PictureFrame {

  /// User defined name of the picture frame.
  var name: String { get }

  /// Connection status of the picture frame.
  var isConnected: Bool { get }

  /// Fetch the media stored on the picture frame.
  func content() -> Promise<PictureFrameContent>

  /// Send media to be stored in the picture frame.
  func storeMedia(
    images: [MediaProvider]
  ) -> UploaderSession<MediaProvider, String>

  /// Update the user defined name of the picture frame.
  func set(name: String) -> Promise<Void>

  /// Fetch the picture frame perferences.
  func preferences() -> Promise<PictureFramePreferences>

  /// Update the preferences of the picture frame.
  func set(preferences: PictureFramePreferences) -> Promise<Void>

  /// Disconnect and unregister this picture frame from the device.
  func forget() -> Promise<Void>
}

struct PictureFramePreferences {
  let slideshowDuration: TimeInterval
  let connectionPasscode: String
}
