//
//  UIViewController+hideKeyboardWhenTappedAround .swift
//  PicPi
//
//  Created by Mustafa T. Mohammed on 12/14/20.
//

import UIKit
extension UIViewController {
  func hideKeyboardWhenTappedAround() {
    let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
    tap.cancelsTouchesInView = false
    view.addGestureRecognizer(tap)
  }
  
  @objc private func dismissKeyboard() {
    view.endEditing(true)
  }
}

