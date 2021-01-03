//
//  UIAlertController+PicPi.swift
//  PicPi
//
//  Created by Erick Sanchez on 12/29/20.
//

import UIKit

extension UIAlertController {
  convenience init(
    title: String,
    message: String,
    style: UIAlertController.Style = .alert,
    button: String,
    action: @escaping () -> Void = {}
  ) {
    self.init(title: title, message: message, preferredStyle: style)
    self.addAction(UIAlertAction(title: button, style: .default) { _ in action() })
  }
  
  convenience init(
    title: String,
    message: String,
    style: UIAlertController.Style = .alert,
    button1: String,
    button2: String,
    action1: @escaping () -> Void = {},
    action2: @escaping () -> Void = {}
  ) {
    self.init(title: title, message: message, preferredStyle: style)
    self.addAction(UIAlertAction(title: button1, style: .default) { _ in action1() })
    self.addAction(UIAlertAction(title: button2, style: .default) { _ in action2() })
  }
}
