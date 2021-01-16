//
//  AddPhotoViewController.swift
//  PicPi
//
//  Created by Mustafa T. Mohammed on 12/15/20.
//

import Photos
import UIKit
import BSImagePicker
import Promises

class AddPhotoViewController: UIViewController {
  private let photoViewModel: AddPhotoViewModel
  private var registeredPictureFrames = [PictureFrame]()

  private let sendButton = customBtnRoundCornerBlueWithShadow(type: .custom)
  private let tableView = UITableView()
  private var margins: UILayoutGuide!

  init(selectedAssets: [PHAsset] = [], selectedPictureFrames: [PictureFrame] = []) {
    self.photoViewModel = AddPhotoViewModel(
      selectedAssets: selectedAssets,
      selectedPictureFrames: selectedPictureFrames
    )

    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func loadView() {
    super.loadView()

    view.backgroundColor = .systemBackground
    title = "Add Photos"
    margins = view.layoutMarginsGuide
    setupNaviationItem()
    setupSendButton()
    setupTableView()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    let pictureFrameManager = injectPictureFrameManager()
    pictureFrameManager.registeredFrames().then { [weak self] frames in
      self?.registeredPictureFrames = frames
      self?.tableView.reloadSections(IndexSet([1]), with: .automatic)
    }
  }
  
  // MARK: - UI Setup
  private func setupSendButton() {
    
    view.addSubview(sendButton)
    sendButton.addTarget(self, action: #selector(sendButtonPressed), for: .touchUpInside)
    sendButton.setTitle("Send", for: .normal)
    sendButton.setTitleColor(.darkGray, for: .disabled)
    sendButton.isEnabled = false
    sendButton.sizeToFit()
    sendButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate(
      [
        sendButton.centerXAnchor.constraint(equalTo: margins.centerXAnchor),
        sendButton.centerYAnchor.constraint(
          equalTo: margins.bottomAnchor, 
          constant: -sendButton.frame.height
        ),
        sendButton.widthAnchor.constraint(equalToConstant: 100)
      ]
    )
  }

  private func setupNaviationItem() {
    let closeButton = UIBarButtonItem(
      barButtonSystemItem: .done,
      target: self,
      action: #selector(doneButtonPressed)
    )
    navigationItem.setLeftBarButton(closeButton, animated: false)
  }

  private func setupTableView() {
    tableView.allowsMultipleSelection = false
    tableView.dataSource = self
    tableView.delegate = self
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    tableView.translatesAutoresizingMaskIntoConstraints = false

    view.addSubview(tableView)
    NSLayoutConstraint.activate(
      [
        tableView.topAnchor.constraint(equalTo: view.topAnchor),
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        tableView.bottomAnchor.constraint(equalTo: sendButton.topAnchor),
      ]
    )
  }

  private func updateUI() {
    tableView.reloadData()
    updateSendButton()
  }

  private func updateSendButton() {
    let isPhotosAndPictureFrameAlreadySelected =
      !(photoViewModel.selectedAssets.isEmpty || photoViewModel.selectedPictureFrames.isEmpty)
    sendButton.isEnabled = isPhotosAndPictureFrameAlreadySelected
  }
  
  // MARK: - Buttons Actions
  @objc func sendButtonPressed(sender: UIButton!) {
    sendButton.isEnabled = false
    let session = photoViewModel.beginUpload()

    let loadingVc = AddPhotoUploadSessionViewController(
      session: session,
      totalImages: photoViewModel.selectedAssets.count
    )
    navigationController?.pushViewController(loadingVc, animated: true)
  }

  @objc func doneButtonPressed(sender: UIButton!) {
    self.dismiss(animated: true, completion: nil)
  }
}
// MARK: - BSImagePicker Setup
extension AddPhotoViewController {
  
  func showImagePickerController(){
    
    let imagePicker = ImagePickerController()
    imagePicker.modalPresentationStyle = .fullScreen
    let options = imagePicker.settings.fetch.album.options
    imagePicker.settings.fetch.album.fetchResults = [
      PHAssetCollection.fetchAssetCollections(
        with: .smartAlbum,
        subtype: .smartAlbumUserLibrary,
        options: options
      ),
      PHAssetCollection.fetchAssetCollections(
        with: .album,
        subtype: .albumRegular,
        options: options
      ),
    ]
    presentImagePicker(imagePicker, select: { _ in
    }, deselect: { _ in
    }, cancel: { _ in
    }, finish: { assets in

      // User finished picking images, inform upload manger and pass an array of assets to
      // prepear for upload
      self.photoViewModel.set(assets)
      self.updateUI()
    })
    
  }
  
}

// MARK: - UITableViewDataSource

extension AddPhotoViewController: UITableViewDelegate , UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case 0:
      return 1
    case 1:
      return registeredPictureFrames.count
    default:
      assertionFailure("unexpected section")
      return 0
    }
  }

  func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }

  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    switch section {
    case 0:
      return "Add Photos"
    case 1:
      return "Send Photos to..."
    default:
      assertionFailure("unexpected section")
      return nil
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    if indexPath.section == 0 {
      let photoCount = photoViewModel.selectedAssets.count
      switch photoCount {
        case 1:
          cell.textLabel?.text = "\(photoCount) photo selected!!"
        case let x where x > 1:
          cell.textLabel?.text = "\(photoCount) photos selected!!"
        default:
          cell.textLabel?.text = "No photo selected!!"
      }
    } else {
      let pictureFrame = registeredPictureFrames[indexPath.row]
      cell.textLabel?.text = pictureFrame.name
      cell.accessoryType = photoViewModel.isSelected(pictureFrame) ? .checkmark : .none
    }

    cell.textLabel?.textAlignment = .center

    return cell
  }

  // MARK: - UITableViewDelegate
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if indexPath.section == 0 {
      showImagePickerController()
    } else if indexPath.section == 1 {
      let pictureFrame = registeredPictureFrames[indexPath.row]
      if photoViewModel.isSelected(pictureFrame) {
        photoViewModel.deselect(pictureFrame)
      } else {
        photoViewModel.select(pictureFrame)
      }

      tableView.reloadRows(at: [indexPath], with: .automatic)
      updateSendButton()
    }
  }
}
