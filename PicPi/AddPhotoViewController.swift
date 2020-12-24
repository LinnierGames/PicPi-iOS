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

  let sendButton = customBtnRoundCornerBlueWithShadow(type: .custom)
  let photoUploadManager = PhotoUploadManager()
  let doneButton = customBtnRoundCornerBlueWithShadow(type: .custom)

  var selectedAssets = [PHAsset]()
  var selectedPictureFrame: PictureFrame?

  private let tableView = UITableView()
  private var margins: UILayoutGuide!

  override func loadView() {
    super.loadView()
    view.backgroundColor = .white
    margins = view.layoutMarginsGuide
    setupSendButton()
    setupDoneBtn()
    setupTableView()
    photoUploadManager.delegate = self
    
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
        sendButton.centerXAnchor.constraint(equalTo: margins.centerXAnchor) ,
        sendButton.centerYAnchor.constraint(
          equalTo: margins.bottomAnchor, 
          constant: -sendButton.frame.height
        ),
        sendButton.widthAnchor.constraint(equalToConstant: 100)
      ]
    )
    
  }
  private func setupDoneBtn() {
    
    view.addSubview(doneButton)
    doneButton.addTarget(self, action: #selector(doneButtonPressed), for: .touchUpInside)
    doneButton.setTitle("Done", for: .normal)
    doneButton.sizeToFit()
    doneButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate(
      [
        doneButton.leftAnchor.constraint(equalTo: margins.leftAnchor ),
        doneButton.centerYAnchor.constraint(
          equalTo : margins.topAnchor,
          constant:  doneButton.frame.height
        ),
        doneButton.widthAnchor.constraint(equalToConstant: 100)  ]
    )
    
  }
  private func setupTableView() {
    tableView.allowsMultipleSelection = false
    tableView.dataSource = self
    tableView.delegate = self
    view.addSubview(tableView)
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    tableView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate(
      [
        tableView.topAnchor.constraint(
          equalTo: doneButton.bottomAnchor,
          constant: 10),
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
        tableView.bottomAnchor.constraint(equalTo: sendButton.topAnchor),
      ]
    )
  }
  
  // MARK: - Buttons Actions
  @objc func sendButtonPressed(sender: UIButton!) {
    guard let pictureFrame = selectedPictureFrame else { return }
    let imageManager = PHImageManager.default()
    let session = pictureFrame.storeMedia(
      images: selectedAssets.wrapAsync { asset in
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
    )

    // TOOD: Pass session to loading Vc.
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
    presentImagePicker(imagePicker, select: { (asset) in
      
    }, deselect: { (asset) in
      
    }, cancel: { (assets) in
      
    }, finish: {(assets) in
      /// User finished picking images, inform upload manger and pass an array of assets to prepear for upload
      self.selectedAssets = assets
      self.photoUploadManager.finishedPickingPhotos(photoAssetes: assets)
      self.tableView.reloadData()
    })
    
  }
  
}

extension AddPhotoViewController: UITableViewDelegate , UITableViewDataSource {
  // MARK: - UITableViewDataSource
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    if indexPath.section == 0 {
      let photoCount = photoUploadManager.picturesCount
      switch photoCount {
        case 1:
          cell.textLabel?.text = "\(photoCount) photo selected!!"
        case let x where x > 1:
          cell.textLabel?.text = "\(photoCount) photos selected!!"
          
        default:
          cell.textLabel?.text = "No photo selected!!"
      }
      
      
    }else {
      // TODO: displaying the title of the picture frame
      cell.textLabel?.text = "PictureFrame 1"
    }
    cell.textLabel?.textAlignment = .center
    return cell
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    if section == 0 {
      return "Add Photos"
    }
    return  "Send Photos to..."
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if section == 0 {
      return 1
    }
    // TODO: after we start save multiple picture frames IPs we could return the count of IPs
    return 1
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }
  // MARK: - UITableViewDelegate
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if indexPath.section == 0 {
      showImagePickerController()
    }else if indexPath.section == 1 {
      if let cell = tableView.cellForRow(at: indexPath){
        cell.accessoryType = .checkmark
      }
    }
  }
}
// MARK: - PhotoUploadManagerDelegate
extension AddPhotoViewController: PhotoUploadManagerDelegate {
  
  func manager(_ manager: PhotoUploadManager, didFinishPickingPhotos finished: Bool ) {
    if finished {
      sendButton.isEnabled = true
      
    }else {
      sendButton.isEnabled = false
    }
  }
  
  func manager(_ manager: PhotoUploadManager, didFinishUploadingPhotos finished: Bool) {
    if finished {
      sendButton.isEnabled = false
      
    }else {
      sendButton.isEnabled = true
    }
    print("Done!!")
  }
  
``}
