//
//  NavigatorImpl.swift
//  PicPi
//
//  Created by Erick Sanchez on 12/29/20.
//

import UIKit
import Photos

func injectNavigator() -> Navigator {
  return NavigatorImpl.shared
}

private class NavigatorImpl: Navigator {
  fileprivate static let shared = NavigatorImpl()

  private var appDelegate: AppDelegate {
    UIApplication.shared.delegate as! AppDelegate
  }

  private var topViewController: UIViewController {
    guard let rootVc = appDelegate.window!.rootViewController else {
      fatalError("Root window has not root Vc")
    }

    return rootVc
  }

  func presentAddPictureFrameFlow() {
    let addFrameVc = AddFrameViewController()
    let navVc = UINavigationController(rootViewController: addFrameVc)
    navVc.modalPresentationStyle = .fullScreen
    topViewController.present(navVc, animated: true)
  }

  func presentPictureFrameDetails(_ pictureFrame: PictureFrame) {
    
  }

  func presentAddPhotoFlow(preselectedAssets: [PHAsset], preselectedFrames: [PictureFrame]) {
    let addPhotoVc = AddPhotoViewController(
      selectedAssets: preselectedAssets,
      selectedPictureFrames: preselectedFrames
    )
    let navVc = UINavigationController(rootViewController: addPhotoVc)
    navVc.modalPresentationStyle = .fullScreen
    topViewController.present(navVc, animated: true)
  }
}
