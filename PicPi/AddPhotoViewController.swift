//
//  AddPhotoViewController.swift
//  PicPi
//
//  Created by Mustafa T. Mohammed on 12/15/20.
//
import Photos
import UIKit
import BSImagePicker

class AddPhotoViewController: UIViewController {
  
  let sendButton = customBtnRoundCornerBlueWithShadow(type: .custom)
  let photoUploadManager = PhotoUploadManager()
  let doneButton = customBtnRoundCornerBlueWithShadow(type: .custom)
  
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
    /// testing FramAPI using photoUploadManager
    photoUploadManager.startUploadPreviouslySelectedPhotos()
    //    sendButton.isEnabled = false
    photoUploadManager.getThumbnails()
    photoUploadManager.updatePref(preferences: ["name" : "TotoPI" , "music" : false , "slideshowDuration" : 454])
  }
  @objc func doneButtonPressed(sender: UIButton!) {
    /// testing FramAPI using photoUploadManager
    photoUploadManager.retrievePIPrefrences()
    photoUploadManager.removePhoto(filename: "IMG_4449.PNG")
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
  
}
