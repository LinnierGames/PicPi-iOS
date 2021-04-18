//
//  UnregisteredPictureFrame.swift
//  PicPi
//
//  Created by Erick Sanchez on 12/23/20.
//

import Promises

protocol UnregisteredPictureFrame {
  /// User defined name of the picture frame.
  var name: String { get }

  /// Connect and register this picture frame to the device.
  func connect() -> Promise<Void>
}
