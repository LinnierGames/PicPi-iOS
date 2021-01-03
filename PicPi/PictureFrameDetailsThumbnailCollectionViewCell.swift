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
    imageView.translatesAutoresizingMaskIntoConstraints = false
    
    return imageView
  }()
  
  private let colorArray: [UIColor] = [ .blue, .cyan, .purple, .lightGray, .gray,
                                        .green, .red, .magenta, .orange, .yellow ]

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupSubviews()
  }
  
  @available(*,unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Private
  override func prepareForReuse() {
    /// reused cell backgroundcolor
    self.backgroundColor = colorArray.randomElement()

  }
  private func setupSubviews() {
    contentView.addSubview(imageView)
    /// initial cell backgroundcolor
    self.backgroundColor = colorArray.randomElement()

    NSLayoutConstraint.activate([
      imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      imageView.topAnchor.constraint( equalTo: contentView.topAnchor),
      imageView.bottomAnchor.constraint( equalTo: contentView.bottomAnchor ),
    ])
  }
}
