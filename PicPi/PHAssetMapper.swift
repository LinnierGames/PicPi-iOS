//
//  PHAssetMapper.swift
//  PicPi
//
//  Created by Erick Sanchez on 12/23/20.
//

import Photos
import Promises

/// Maps the given `PHAsset` into image data and filename.
class PHAssetDataMapper: LazyMapper {
  private let asset: PHAsset
  private let imageManager: PHImageManager

  init(imageManager: PHImageManager = .default(), asset: PHAsset) {
    self.asset = asset
    self.imageManager = imageManager
  }

  func map() -> Promise<(data: Data, filename: String)> {
    let options = PHImageRequestOptions()
    options.deliveryMode = PHImageRequestOptionsDeliveryMode.highQualityFormat
    options.isSynchronous = false
    options.isNetworkAccessAllowed = true
    let resources = PHAssetResource.assetResources(for: asset)

    return Promise { fulfill, reject in
      self.imageManager.requestImage(
        for: self.asset,
        targetSize: PHImageManagerMaximumSize,
        contentMode: .aspectFit,
        options: options
      ) { image, info in
        guard
          let filename = resources.first?.originalFilename,
          let imageData = image?.pngData()
        else {
          return
        }

        fulfill((imageData, filename))
      }
    }
  }
}
