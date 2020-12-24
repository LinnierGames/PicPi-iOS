//
//  PictureFrameManagerImpl.swift
//  PicPi
//
//  Created by Erick Sanchez on 12/23/20.
//

import Foundation
import  Promises

class PictureFrameManagerImpl: PictureFrameManager {
  private let userPreferences: UserPreferences

  init(userPreferences: UserPreferences = injectUserPreferences()) {
    self.userPreferences = userPreferences
  }
  func searchForFrames() -> Promise<[UnregisteredPictureFrame]> {
    fatalError()
  }

  func registeredFrames() -> Promise<[PictureFrame]> {
    let ips = userPreferences.ipAddresses()
    let frames = ips.compactMap { ip -> PictureFrame? in
      guard let host = URL(string: "http://\(ip)") else { return nil }
      return PictureFrameImpl(frameAPI: injectFrameAPI(host: host))
    }

    return Promise { frames }
  }
}
