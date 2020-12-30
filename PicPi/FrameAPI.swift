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

struct PhotoData: Decodable {
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
   frameAPI.retrieveThumbnails().then {  Urls    in
     print(Urls)`
   }.catch {reject in
     print(reject)
    }
  }
 ```
 */
protocol FrameAPI {
  /// Upload the selected photo with filename
  func upload(photoData: Data, filename: String) -> Promise<Void>
  /// Get the list of URLs of the thumbnails stored on the Pi
  func retrieveThumbnails() -> Promise<[PhotoData]>
  /// Remove the given photo
  func removePhoto(filename: String) -> Promise<Void>
  /// Get Pi Preferences
  func retrievePIPrefrences() -> Promise<PictureFramePreferences>
  /// Update Pi Preferences 
  func updatePI(preferences: PictureFramePreferences) -> Promise<Void>
}
 
