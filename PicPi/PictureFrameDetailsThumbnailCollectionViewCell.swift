//
//  PictureFrameDetailsThumbnailCollectionViewCell.swift
//  PicPi
//
//  Created by Mustafa T. Mohammed on 1/2/21.
//

import UIKit

class PictureFrameDetailsThumbnailCollectionViewCell: UICollectionViewCell {
  
  var imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleToFill
    imageView.isUserInteractionEnabled = true
    imageView.translatesAutoresizingMaskIntoConstraints = false
    
    return imageView
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupSubviews()
  }
  
  @available(*,unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Private
  
  private func setupSubviews() {
    self.backgroundColor = .cyan
    contentView.addSubview(imageView)
    NSLayoutConstraint.activate([
      imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      imageView.topAnchor.constraint( equalTo: contentView.topAnchor),
      imageView.bottomAnchor.constraint( equalTo: contentView.bottomAnchor ),
    ])
  }
}
