//
//  PhotoViewModel.swift
//  PicPi
//
//  Created by Erick Sanchez on 12/24/20.
//

import Foundation
import Photos
import Promises

private typealias HashablePictureFrame = HashableAdapter<PictureFrame>

extension HashablePictureFrame {
  fileprivate init(_ pictureFrame: PictureFrame) {
    self.init(id: pictureFrame.id, value: pictureFrame)
  }
}

class AddPhotoViewModel {
  private(set) var selectedAssets: [PHAsset]

  private var _selectedPictureFrames: NSMutableOrderedSet
  var selectedPictureFrames: [PictureFrame] {
    _selectedPictureFrames.compactMap { $0 as? HashablePictureFrame }.map { $0.value }
  }

  init(selectedAssets: [PHAsset], selectedPictureFrames: [PictureFrame]) {
    self.selectedAssets = selectedAssets
    self._selectedPictureFrames =
      NSMutableOrderedSet(array: selectedPictureFrames.map(HashablePictureFrame.init))
  }

  func set(_ assets: [PHAsset]) {
    self.selectedAssets = assets
  }

  func select(_ pictureFrame: PictureFrame) {
    guard !isSelected(pictureFrame) else { return }
    _selectedPictureFrames.insert(HashablePictureFrame(pictureFrame), at: 0)
  }

  func deselect(_ pictureFrame: PictureFrame) {
    guard isSelected(pictureFrame) else { return }
    _selectedPictureFrames.remove(HashablePictureFrame(pictureFrame))
  }

  func isSelected(_ pictureFrame: PictureFrame) -> Bool {
    _selectedPictureFrames.contains(HashablePictureFrame(pictureFrame))
  }

  func beginUpload() -> MediaUploaderSession {
    guard let pictureFrame = selectedPictureFrames.first else {
      fatalError("must select a picture frame before uploading")
    }

    let imageManager = PHImageManager.default()
    let imageProviders = selectedAssets.wrapAsync { asset -> Promise<(data: Data, filename: String)> in
      let options = PHImageRequestOptions()
      options.deliveryMode = PHImageRequestOptionsDeliveryMode.highQualityFormat
      options.isSynchronous = false
      options.isNetworkAccessAllowed = true
      let resources = PHAssetResource.assetResources(for: asset)

      return Promise { fulfill, reject in
        imageManager.requestImage(
          for: asset,
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

    return pictureFrame.storeMedia(images: imageProviders)
  }
}
