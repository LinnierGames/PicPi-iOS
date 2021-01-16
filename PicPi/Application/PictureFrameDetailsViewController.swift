//
//  PictureFrameDetailsViewController.swift
//  PicPi
//
//  Created by Mustafa T. Mohammed on 1/2/21.
//

import Foundation
import Promises
import Kingfisher

class PictureFrameDetailsViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout  {
  
  private let pictureFrame: PictureFrame
  private var media = [Photo]()
  
  init(pictureFrame: PictureFrame, collectionViewLayout :UICollectionViewFlowLayout  = UICollectionViewFlowLayout()) {
    self.pictureFrame = pictureFrame
    
    super.init(collectionViewLayout: collectionViewLayout)
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    collectionView.register(PictureFrameDetailsThumbnailCollectionViewCell.self)
    collectionView.register(PictureFrameDetailsPlusSignCollectionViewCell.self)
    collectionView.backgroundColor = .systemBackground
    title = "Details"
   }
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    /// asking the PictureFrame for its content
    pictureFrame.content().then { (content) in
      self.media = content.media
      self.collectionView.reloadData()
    }
  }
  
  
  // MARK: - collectionView DataSource
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    /// skiping the first cell , it's like a button to add photo
    return media.count + 1
  }
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    if indexPath.item == 0  {
      let cell = collectionView.dequeueReusableCell(for: indexPath) as PictureFrameDetailsPlusSignCollectionViewCell
      return cell
    }
    else {
      let cell = collectionView.dequeueReusableCell(for: indexPath) as PictureFrameDetailsThumbnailCollectionViewCell
      /// using kingfisher to download the thumbnail of the photo
      /// indexPath.row - 1 because we are skinpping the first cell
      cell.imageView.kf.setImage(with: media[indexPath.row - 1].thumbnail)
      
      return cell
    }
  }
  
  // MARK: -  CollectionViewLayout

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    /// displaying 3 square cells per row , square (width = height)
    let width = collectionView.bounds.width/3.0
    let height = width
    
    return CGSize(width: width, height: height)
  }
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    ///   collectionViewCell  top, left, bottom, and right spacings are all set to 0.
    return UIEdgeInsets.zero
  }
  /// set spacing to zero
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
  
  // MARK: -  CollectionView Delegate

  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if indexPath.item == 0  {
      /// first cell is the add photo button
      let navigator = injectNavigator()
      navigator.presentAddPhotoFlow(preselectedAssets: [], preselectedFrames: [pictureFrame])
      
    }else {
      let imgaeView = FullImageViewController(photo: media[indexPath.row - 1])
      navigationController?.pushViewController(imgaeView, animated: true)
    }
  }
}

