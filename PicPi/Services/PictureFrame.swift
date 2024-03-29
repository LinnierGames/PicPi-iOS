//
//  PictureFrame.swift
//  PicPi
//
//  Created by Erick Sanchez on 12/23/20.
//

import Foundation
import Promises

typealias MediaProvider = Provider<Promise<(data: Data, filename: String)>>
typealias MediaUploaderSession = UploaderSession<MediaProvider, String>

protocol PictureFrame {
  var id: String { get }

  /// User defined name of the picture frame.
  var name: String { get }

  /// Connection status of the picture frame.
  var isConnected: Bool { get }

  /// Fetch the media stored on the picture frame.
  func content() -> Promise<PictureFrameContent>

  /// Send media to be stored in the picture frame.
  func storeMedia(images: [MediaProvider]) -> MediaUploaderSession

  /// Update the user defined name of the picture frame.
  func set(name: String) -> Promise<Void>

  /// Fetch the picture frame perferences.
  func preferences() -> Promise<PictureFramePreferences>

  /// Update the preferences of the picture frame.
  func set(preferences: PictureFramePreferences) -> Promise<Void>

  /// Disconnect and unregister this picture frame from the device.
  func forget() -> Promise<Void>
}

struct PictureFramePreferences: Codable {
  /// In miliseconds
  let slideshowDuration: TimeInterval?
  let connectionPasscode: String?
  let name: String?
  let portraitMode: Bool?
  let screenWidth: CGFloat?
  let screenHeight: CGFloat?

  init(
    slideshowDuration: TimeInterval? = nil,
    connectionPasscode: String? = nil,
    name: String? = nil,
    portraitMode: Bool? = nil,
    screenWidth: CGFloat? = nil,
    screenHeight: CGFloat? = nil
  ) {
    self.slideshowDuration = slideshowDuration
    self.connectionPasscode = connectionPasscode
    self.name = name
    self.portraitMode = portraitMode
    self.screenWidth = screenWidth
    self.screenHeight = screenHeight
  }
}
