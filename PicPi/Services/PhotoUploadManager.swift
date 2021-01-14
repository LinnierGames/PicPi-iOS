//
//  PhotoUploadManager.swift
//  PicPi
//
//  Created by Mustafa T. Mohammed on 12/18/20.
//

import Foundation
import Photos

// TODO: Fix mock template and remove this skip.
// sourcery: skip
protocol PhotoUploadManagerDelegate: AnyObject {
  func manager(_ manager: PhotoUploadManager,
               didFinishPickingPhotos finished: Bool  )
  func manager(_ manager: PhotoUploadManager,
               didFinishUploadingPhotos finished: Bool  )
}
/// temporary upload manager
class PhotoUploadManager {
  let frameAPI: FrameAPI
  weak var delegate: PhotoUploadManagerDelegate?
  var picturesCount = 0
  
  private var assets: [PHAsset]?
  
  init(frameAPI: FrameAPI = injectFrameAPI(host: URL(string: "http://192.168.0.5:3000")!)) {
    self.frameAPI = frameAPI
  }
  func removePhoto(filename: String) {
    frameAPI.removePhoto(filename: filename)
  }
  func getThumbnails() {
    frameAPI.retrievePhotosInfo().then {  Urls    in
      print(Urls)
    }.catch {reject in
     print(reject)
    }
  }
  func retrievePIPrefrences() {
    frameAPI.retrievePIPrefrences().then { pref in
    print(pref)
    }
  }
  func updatePref(preferences: PictureFramePreferences){
    frameAPI.updatePI(preferences: preferences)
  }
  func finishedPickingPhotos(photoAssetes assets: [PHAsset] ) {
    self.assets = assets
    picturesCount = assets.count
    delegate?.manager(self, didFinishPickingPhotos: true)
  }
  
  func startUploadPreviouslySelectedPhotos()  {
    ///start uploading in background
    DispatchQueue.global(qos: .background).async { [weak self]  in
      let options = PHImageRequestOptions()
      ///setting options for requesting the image form the asset
      options.deliveryMode = PHImageRequestOptionsDeliveryMode.highQualityFormat
      options.isSynchronous = false
      options.isNetworkAccessAllowed = true
      guard let self = self, let assets = self.assets else { return }
      /// uploading photos one by one
      var count = 0
      for asset in assets {
        //
        PHImageManager.default().requestImage(
          for: asset,
          targetSize: PHImageManagerMaximumSize,
          contentMode: .aspectFit,
          options: options) { (image, info) in
          /// getting file name from an asset
          let resources = PHAssetResource.assetResources(for: asset)
          guard let fileName = resources.first?.originalFilename else {return}
          
          if let image = image {
            /// upload photo using multi-part form
            guard let imageData = image.pngData() else { return }
            
            self.frameAPI.upload(photoData: imageData, filename: fileName).then {
              count += 1
              /// check if all photos has been uploaded .. this is temporary for test purposes only
              if count == self.picturesCount {
                self.delegate?.manager(self, didFinishUploadingPhotos: true)
              }
              print( "Success")
            }.catch { (error)  in
              print(error, "Error")
            }
          }
        }
      }
    }
  }
}



