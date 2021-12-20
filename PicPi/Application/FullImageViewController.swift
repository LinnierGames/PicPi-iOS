//
//  FullImageViewController.swift
//  PicPi
//
//  Created by Mustafa T. Mohammed on 1/2/21.
//

import UIKit
import Kingfisher
import Promises

class FullImageViewController: UIViewController {
  private let cropButton = customBtnRoundCornerBlueWithShadow(type: .custom)
  private let deleteButton = customBtnRoundCornerBlueWithShadow(type: .custom)
  private var margins: UILayoutGuide!
  private let photo: Photo
  
  init(photo: Photo) {
    self.photo = photo
    super.init(nibName: nil, bundle: nil)
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  override func viewDidLoad() {
    super.viewDidLoad()
    margins = view.layoutMarginsGuide
    view.backgroundColor = .systemBackground
    title = photo.filename
    
    setupDeleteButton()
    setupImageView()
  }
  
  private func setupImageView() {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.contentMode = .scaleAspectFit
    imageView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
    /// download full image from Pi
    let thumbnailImage =
      ImageCache.default.retrieveImageInMemoryCache(forKey: photo.thumbnail.absoluteString)
    imageView.kf.setImage(with: photo.fullImage, placeholder: thumbnailImage)
    view.addSubview(imageView)
    
    NSLayoutConstraint.activate(
      [
        imageView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
        imageView.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
        imageView.topAnchor.constraint(equalTo: margins.topAnchor ),
        imageView.bottomAnchor.constraint( equalTo: deleteButton.topAnchor ),
      ]
    )
  }
  
  private func setupDeleteButton() {
    cropButton.addTarget(self,
                           action: #selector(cropButtonPressed),
                           for: .touchUpInside)
    cropButton.setTitle("Crop",
                          for: .normal)
    cropButton.sizeToFit()
    cropButton.translatesAutoresizingMaskIntoConstraints = false
    
    deleteButton.addTarget(self,
                           action: #selector(deleteButtonPressed),
                           for: .touchUpInside)
    deleteButton.setTitle("Delete",
                          for: .normal)
    deleteButton.sizeToFit()
    deleteButton.translatesAutoresizingMaskIntoConstraints = false
    
    view.addSubview(cropButton)
    view.addSubview(deleteButton)
    NSLayoutConstraint.activate(
      [
        cropButton.centerXAnchor.constraint(equalTo: margins.centerXAnchor),
        deleteButton.topAnchor.constraint(
          equalTo : cropButton.bottomAnchor, constant: 8),
        
        deleteButton.centerXAnchor.constraint(equalTo: margins.centerXAnchor),
        deleteButton.centerYAnchor.constraint(
          equalTo : margins.bottomAnchor,
          constant:  -deleteButton.frame.height),
        deleteButton.widthAnchor.constraint(
          equalToConstant: 100)
      ]
    )
    
  }
  
  @objc func cropButtonPressed(sender: UIButton!) {
    let editor = ImageEditorViewController(photo: self.photo)
    self.present(editor, animated: true)
  }
  
  @objc func deleteButtonPressed(sender: UIButton!) {
    
    let alert = UIAlertController(
      title: "Delete Photo",
      message: "Delete this photo :( ?",
      style: .alert,
      button1: "Yes :(",
      button2: "No :)",
      action1: {
        self.photo.removeFromFrame().then { [weak self] (_)   in
          _ = self?.navigationController?.popViewController(animated: true)
          
        }.catch { (error) in
          print(error)
          let alert2 = UIAlertController(
            title: "Error",
            message: "Failed to delete photo due to \(error.localizedDescription)",
            button: "Dismiss")
          self.present(alert2, animated: true)
          
        }
      } 
    )
    self.present(alert, animated: true)
 
  }
  
}
