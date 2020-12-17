//
//  AddPhotoViewController.swift
//  PicPi
//
//  Created by Mustafa T. Mohammed on 12/15/20.
//
import Photos
import Moya
import UIKit
import BSImagePicker
class AddPhotoViewController: UIViewController {
  private let tableView = UITableView()
  private var margins: UILayoutGuide!
  var photProvider = MoyaProvider<photosUpload>(plugins: [NetworkLoggerPlugin()])
  
  let doneButton = customBtnRoundCornerBlueWithShadow(type: .custom)
  
  override func loadView() {
    super.loadView()
    view.backgroundColor = .white
    margins = view.layoutMarginsGuide
    
    setupDoneBtn()
  }
  
  
  private func setupDoneBtn() {
    
    view.addSubview(doneButton)
    doneButton.addTarget(self, action: #selector(doneButtonPressed), for: .touchUpInside)
    doneButton.setTitle("Add", for: .normal)
    doneButton.sizeToFit()
    doneButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate(
      [
        doneButton.centerXAnchor.constraint(equalTo: margins.centerXAnchor) ,
        doneButton.centerYAnchor.constraint(equalTo : margins.bottomAnchor, constant:  -doneButton.frame.height)  ,
        doneButton.widthAnchor.constraint(equalToConstant: 100)
      ]
    )
    
  }
  
  @objc func doneButtonPressed(sender: UIButton!) {
    //    self.dismiss(animated: true, completion: nil)
    showImagePickerController()
  }
  
}

extension AddPhotoViewController {
  
  
  func showImagePickerController(){
    let imagePicker = ImagePickerController()
    
    presentImagePicker(imagePicker, select: { (asset) in
      // User selected an asset. Do something with it. Perhaps begin processing/upload?
    }, deselect: { (asset) in
      // User deselected an asset. Cancel whatever you did when asset was selected.
    }, cancel: { (assets) in
      // User canceled selection.
    }, finish: { (assets) in
      for asset in assets {
        PHImageManager.default().requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFit, options: nil) { (image, info) in
          self.photProvider.request(.uploadPhoto( (image?.pngData())!, "test", "png")) { (result) in
            
            switch result {
              case .success(let responce):
                let responceJSON = try! JSONSerialization.jsonObject(with: responce.data, options: [])
                print(responce.description , responceJSON)
              case .failure(let error):
                print(error , "Error")
            }
          }
          
          
        }
        
      }
      // User finished selection assets.
    })
    
    
  }
  
}
