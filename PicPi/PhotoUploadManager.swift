//
//  PhotoUploadManager.swift
//  PicPi
//
//  Created by Mustafa T. Mohammed on 12/18/20.
//

import Foundation
import Photos
import Moya
protocol PhotoUploadManagerDelegate: AnyObject {
  func manager(_ manager: PhotoUploadManager,
               didFinishPickingPhotos finished: Bool  )
  func manager(_ manager: PhotoUploadManager,
               didFinishUploadingPhotos finished: Bool  )
}
/// temporary upload manager
class PhotoUploadManager {
  
  weak var delegate: PhotoUploadManagerDelegate?
  var picturesCount = 0
  
  private var assets: [PHAsset]?
  private let photoProvider = MoyaProvider<PhotosUpload>()
  
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
            self.photoProvider.request(
              .uploadPhoto( photoData: (image.pngData() ?? Data()),
                            nameAndExtension: fileName)){ [weak self] (result) in
              guard let self = self else {return}
              switch result {
                case .success(let response):
                  count += 1
                  /// check if all photos has been uploaded .. this is temporary for test purposes only
                  if count == self.picturesCount {
                    self.delegate?.manager(self, didFinishUploadingPhotos: true)
                  }
                  print(response, "Success")
                case .failure(let error):
                  print(error, "Error")
                  
              }
            }
          }
        }
      }
    }
  }
}



