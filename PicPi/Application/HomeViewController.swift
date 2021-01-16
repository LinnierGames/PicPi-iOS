//
//  ViewController.swift
//  PicPi
//
//  Created by Erick Sanchez on 12/7/20.
//

import UIKit
import BSImagePicker

class HomeViewController: UIViewController {
  private let userPreferences = injectUserPreferences()

  let searchButton = customBtnRoundCornerBlueWithShadow(type: .custom)
  let addButton = UIButton(type: .custom)
  let framesButton = customBtnRoundCornerBlueWithShadow(type: .custom)
  var margins: UILayoutGuide!

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .systemBackground
    title = "PicPi"
    margins = view.layoutMarginsGuide
  }
  
  override func viewWillAppear(_ animated: Bool) {
    /// try to make it simple for now by updating the table if there is any saved IP Address
    super.viewWillAppear(animated)
    updateUI()
  }
  
  // MARK: - Private

  private func updateUI() {
    let ipAddresses = userPreferences.ipAddresses()

    view.subviews.forEach { $0.removeFromSuperview() }
    if ipAddresses.isEmpty {
      let pictureFrameImageView = UIImageView(image: nil)
      pictureFrameImageView.backgroundColor = .gray
      let stackView = UIStackView(arrangedSubviews: [pictureFrameImageView, searchButton])
      stackView.spacing = Constants.Spacing.medium
      stackView.axis = .vertical
      stackView.alignment = .center
      stackView.translatesAutoresizingMaskIntoConstraints = false

      view.addSubview(stackView)
      NSLayoutConstraint.activate([
        pictureFrameImageView.widthAnchor.constraint(equalToConstant: 132),
        pictureFrameImageView.heightAnchor.constraint(equalToConstant: 196),
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      ])
    } else {
      framesButton.setTitle("Frames", for: .normal)
      framesButton.addTarget(
        self, action: #selector(HomeViewController.framesButtonPressed(sender:)),
        for: .touchUpInside
      )
      framesButton.translatesAutoresizingMaskIntoConstraints = false

      addButton.addTarget(self, action: #selector(addButtonPressed), for: .touchUpInside)
      if let addButtonImage = UIImage(named: "AddButton") {
        addButton.setImage(addButtonImage, for: .normal)
      }
      addButton.translatesAutoresizingMaskIntoConstraints = false

      let photosVc = ImagePickerController()
      photosVc.imagePickerDelegate = self
      photosVc.settings.dismiss.enabled = false

      addChild(photosVc)
      view.addSubview(photosVc.view)
      photosVc.didMove(toParent: self)

      view.addSubview(framesButton)
      view.addSubview(addButton)
      NSLayoutConstraint.activate([
        framesButton.centerXAnchor.constraint(equalTo: margins.centerXAnchor),
        framesButton.topAnchor.constraint(equalTo : margins.topAnchor),

        photosVc.view.topAnchor.constraint(equalTo: view.topAnchor),
        photosVc.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        photosVc.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        photosVc.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),

        addButton.centerXAnchor.constraint(equalTo: margins.centerXAnchor),
        addButton.bottomAnchor.constraint(equalTo: margins.bottomAnchor),
        addButton.widthAnchor.constraint(equalToConstant: 75),
        addButton.heightAnchor.constraint(equalToConstant: 75)
      ])
    }
  }
  
  @objc func searchButtonPressed(sender: UIButton!) {
    let navigator = injectNavigator()
    navigator.presentAddPictureFrameFlow()
  }

  @objc func addButtonPressed(sender: UIButton!) {
    let navigator = injectNavigator()
    navigator.presentAddPhotoFlow(preselectedAssets: [], preselectedFrames: [])
  }

  @objc func framesButtonPressed(sender: UIButton!) {
    let pictureFramesVc = PictureFramesViewController()
    navigationController?.pushViewController(pictureFramesVc, animated: true)
  }
}

extension HomeViewController: ImagePickerControllerDelegate, UINavigationControllerDelegate {
  func imagePicker(_ imagePicker: ImagePickerController, didSelectAsset asset: PHAsset) {
  }

  func imagePicker(_ imagePicker: ImagePickerController, didDeselectAsset asset: PHAsset) {
  }

  func imagePicker(_ imagePicker: ImagePickerController, didFinishWithAssets assets: [PHAsset]) {
    let navigator = injectNavigator()
    navigator.presentAddPhotoFlow(preselectedAssets: assets, preselectedFrames: [])
  }

  func imagePicker(_ imagePicker: ImagePickerController, didCancelWithAssets assets: [PHAsset]) {
  }

  func imagePicker(_ imagePicker: ImagePickerController, didReachSelectionLimit count: Int) {
  }
}
