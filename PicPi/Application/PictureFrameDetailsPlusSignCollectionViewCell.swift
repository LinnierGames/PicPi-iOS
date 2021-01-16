//
//  PictureFrameDetailsPlusSignCollectionViewCell.swift
//  PicPi
//
//  Created by Mustafa T. Mohammed on 1/2/21.
//

import UIKit

class PictureFrameDetailsPlusSignCollectionViewCell: UICollectionViewCell {
  
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
    let plusIcon = UIImage(systemName: "plus")?.withRenderingMode(.alwaysTemplate)
    let plusIconView = UIImageView(image: plusIcon)
    plusIconView.tintColor = .systemBlack
    let addPhotoLabel = UILabel()
    addPhotoLabel.text = "Add Photo"
    
    let stackView = UIStackView(arrangedSubviews: [plusIconView, addPhotoLabel])
    stackView.axis = .vertical
    stackView.alignment = .center
    stackView.translatesAutoresizingMaskIntoConstraints = false
    
    contentView.addSubview(stackView)
    let plusIconViewSize: CGFloat = 32
    NSLayoutConstraint.activate([
      
      // Plus Icon
      plusIconView.heightAnchor.constraint(equalToConstant: plusIconViewSize),
      plusIconView.widthAnchor.constraint(equalToConstant: plusIconViewSize),
      
      // StackView
      stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      stackView.topAnchor.constraint(
        equalTo: contentView.topAnchor,
        constant: Constants.Spacing.small
      ),
      contentView.bottomAnchor.constraint(
        equalTo: stackView.bottomAnchor,
        constant: Constants.Spacing.small
      ),
    ])
  }
}
