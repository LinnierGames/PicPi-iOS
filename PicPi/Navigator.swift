//
//  Navigator.swift
//  PicPi
//
//  Created by Erick Sanchez on 12/29/20.
//

import UIKit
import Photos

protocol Navigator {
  func presentAddPictureFrameFlow()
  func presentAddPhotoFlow(preselectedAssets: [PHAsset], preselectedFrames: [PictureFrame])
}
