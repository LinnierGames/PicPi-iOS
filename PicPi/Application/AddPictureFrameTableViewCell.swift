//
//  AddPictureFrameTableViewCell.swift
//  PicPi
//
//  Created by Erick Sanchez on 12/31/20.
//

import UIKit

class AddPictureFrameTableViewCell: UITableViewCell {
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
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
    plusIconView.tintColor = .black
    let addFrameLabel = UILabel()
    addFrameLabel.text = "Add Picture Frame"

    let stackView = UIStackView(arrangedSubviews: [plusIconView, addFrameLabel])
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
