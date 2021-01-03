//
//  PictureFrameManagerImpl.swift
//  PicPi
//
//  Created by Erick Sanchez on 12/23/20.
//

import Foundation
import  Promises

func injectPictureFrameManager() -> PictureFrameManager {
  PictureFrameManagerImpl(userPreferences: injectUserPreferences())
}

private class PictureFrameManagerImpl: PictureFrameManager {
  private let userPreferences: UserPreferences

  init(userPreferences: UserPreferences) {
    self.userPreferences = userPreferences
  }
  func searchForFrames() -> Promise<[UnregisteredPictureFrame]> {
    // TODO: Scan for picture frames on the network or within proximity.
    fatalError("not implemented, yet")
  }
 
  func registeredFrames() -> Promise<[PictureFrame]> {
    let ips = userPreferences.ipAddresses()
    let frames = ips.compactMap { ip -> PictureFrame? in
      guard let host = URL(string: "http://\(ip)") else { return nil }
      return injectPictureFrame(ip: ip, host: host)
    }

    return Promise(frames)
  }
}
