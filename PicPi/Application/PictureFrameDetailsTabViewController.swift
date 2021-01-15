//
//  PictureFrameDetailsTabViewController.swift
//  PicPi
//
//  Created by Erick Sanchez on 1/14/21.
//

import UIKit

class PictureFrameDetailsTabViewController: UITabBarController {
  init(pictureFrame: PictureFrame) {
    super.init(nibName: nil, bundle: nil)
    viewControllers = [
      PictureFrameDetailsViewController(pictureFrame: pictureFrame),
      PictureFramePreferencesViewController(pictureFrame: pictureFrame)
    ]
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
