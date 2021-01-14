//
//  UICollectionView+PicPi.swift
//  PicPi
//
//  Created by Mustafa T. Mohammed on 1/2/21.
//

import UIKit

extension UICollectionView {
  
  /// Register the given cell type using the type's description for the cell's reusable identifier.
  func register<Cell: UICollectionViewCell>(_: Cell.Type) {
    self.register(Cell.self, forCellWithReuseIdentifier:  String(describing: Cell.self))
  }
  
  /// Deque the given cell type using the type's description.
  func dequeueReusableCell<Cell: UICollectionViewCell>(for indexPath: IndexPath) -> Cell {
    return self.dequeueReusableCell(
      withReuseIdentifier: String(describing: Cell.self),
      for: indexPath
    ) as! Cell // swiftlint:disable:this force_cast
  }
}
