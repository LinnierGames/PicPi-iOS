//
//  ImageEditorViewController.swift
//  PicPi
//
//  Created by Erick Sanchez on 12/19/21.
//

import UIKit
import Kingfisher

class ImageEditorViewController: UIViewController {
  
  let scrollView = UIScrollView()
  let cropImage = UIImageView()
  let finishedImage = UIImageView()
  
  let photo: Photo
  
  init(photo: Photo) {
    self.photo = photo
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .systemBackground
    
    cropImage.translatesAutoresizingMaskIntoConstraints = false
    scrollView.delegate = self
    scrollView.decelerationRate = .fast
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    
    scrollView.addSubview(cropImage)
    view.addSubview(scrollView)
    
    NSLayoutConstraint.activate([
      cropImage.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
      cropImage.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
      cropImage.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
      cropImage.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
      cropImage.widthAnchor.constraint(equalTo: scrollView.contentLayoutGuide.widthAnchor),
      cropImage.heightAnchor.constraint(equalTo: scrollView.contentLayoutGuide.heightAnchor),
      
      scrollView.widthAnchor.constraint(equalToConstant: 400),
      scrollView.heightAnchor.constraint(equalToConstant: 275),
      scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      scrollView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
    ])
    
    finishedImage.frame = CGRect(x: 0, y: 30, width: 300, height: 275)
    view.addSubview(finishedImage)
    
    cropImage.kf.setImage(with: photo.fullImage, completionHandler: { [weak self] result in
      switch result {
      case .success(let response):
        self?.updateEditor(image: response.image.imageWithoutBaseline())
      default: break
      }
    })
    
    let cropButton = customBtnRoundCornerBlueWithShadow(type: .custom)
    cropButton.addTarget(self,
                           action: #selector(cropButtonPressed),
                           for: .touchUpInside)
    cropButton.setTitle("Crop",
                          for: .normal)
    cropButton.sizeToFit()
    cropButton.translatesAutoresizingMaskIntoConstraints = false
    
    view.addSubview(cropButton)
    NSLayoutConstraint.activate(
      [
        cropButton.bottomAnchor.constraint(
          equalTo : view.safeAreaLayoutGuide.bottomAnchor, constant: 8),
        cropButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      ]
    )
  }
  
  private func updateEditor(image: UIImage) {
    cropImage.frame.size = image.size
    view.layoutIfNeeded()
    
    let scrollSize = self.scrollView.bounds.size
    let imagesize = image.size
    let widthRatio = scrollSize.width / imagesize.width
    let heightRatio = scrollSize.height / imagesize.height
    let minZoom = max(widthRatio, heightRatio)
    scrollView.minimumZoomScale = minZoom
    scrollView.zoomScale = minZoom
    
    let frameHeight = cropImage.frame.size.height
    let frameWidth = cropImage.frame.size.width
    var point = CGPoint()
    if frameHeight < frameWidth {
        point.x = (frameWidth - scrollView.bounds.width)/2
    } else {
        
        point.y = (frameHeight - scrollView.bounds.height)/2
    }
    scrollView.setContentOffset(point, animated: false)
  }
  
  @objc
  private func cropButtonPressed() {
    let crop = scrollView.convert(scrollView.bounds, to: cropImage)
    let image = cropImage.image!.cgImage!.cropping(to: crop)!
    let uiImage = UIImage(cgImage: image)
    
    photo.replaceImage(newImage: uiImage).then {
      KingfisherManager.shared.cache.clearCache()
      self.presentingViewController?.dismiss(animated: true)
    }
  }
}

extension ImageEditorViewController: UIScrollViewDelegate {
  func viewForZooming(in scrollView: UIScrollView) -> UIView? {
    return cropImage
  }
}
