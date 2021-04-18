//
//  FrameAPI.swift
//  PicPi
//
//  Created by Mustafa T. Mohammed on 12/21/20.
//

import Foundation
import Promises

enum FrameAPIErrors: Error {
  case dataMalformed
}

struct PhotoInfoData: Decodable {
  let filename: String
  let thumbnail: URL
  let image: URL
}

/**
 # Example usage
 
 ## Initialization
   ```
  let frameAPI: FrameAPI
  init(frameAPI: FrameAPI = injectFrameAPI()) {
    self.frameAPI = frameAPI
  }
 ```
## Call function that return for example [URL]
 - Notice that we use (.then) that will return the list of URLs and (.catch) that will return the rejection reason (error)
 ```
  func getThumbnails() {
    frameAPI.retrievePhotosInfo().then { infos in
      print(infos)`
    }.catch { error in
      print(error)
    }
  }
 ```
 */
protocol FrameAPI {
  /// Upload the selected photo with filename
  func upload(photoData: Data, filename: String) -> Promise<Void>
  /// Get the list of photos and their URLs of thumbnails or full images stored on the Pi
  func retrievePhotosInfo() -> Promise<[PhotoInfoData]>
  /// Remove the given photo
  func removePhoto(filename: String) -> Promise<Void>
  /// Get Pi Preferences
  func retrievePIPrefrences() -> Promise<PictureFramePreferences>
  /// Update Pi Preferences 
  func updatePI(preferences: PictureFramePreferences) -> Promise<Void>
}
