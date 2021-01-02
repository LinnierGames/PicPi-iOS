//
//  UITableView+PicPi.swift
//  PicPi
//
//  Created by Erick Sanchez on 12/31/20.
//

import UIKit

extension UITableView {

  /// Register the given cell type using the type's description for the cell's reusable identifier.
  func register<Cell: UITableViewCell>(_: Cell.Type) {
    self.register(Cell.self, forCellReuseIdentifier: String(describing: Cell.self))
  }

  /// Deque the given cell type using the type's description.
  func dequeueReusableCell<Cell: UITableViewCell>(for indexPath: IndexPath) -> Cell {
    return self.dequeueReusableCell(
      withIdentifier: String(describing: Cell.self),
      for: indexPath
    ) as! Cell // swiftlint:disable:this force_cast
  }
}
