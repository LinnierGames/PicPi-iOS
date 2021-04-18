//
//  ConnectionSuccessfulViewController.swift
//  PicPi
//
//  Created by Mustafa T. Mohammed on 12/9/20.
//

import UIKit

class ConnectionSuccessfulViewController: UIViewController {
  let doneButton = customBtnRoundCornerBlueWithShadow(type: .custom)
  let messageLabel = UILabel()
  var margins: UILayoutGuide!
  var ip  = ""
  
  override func loadView() {
    super.loadView()
    view.backgroundColor = .systemBackground
    margins = view.layoutMarginsGuide
    setupDoneBtn()
    setupMessageLabel()
  }
  
  // MARK: -  Setup UI
  private func setupMessageLabel() {
    
    view.addSubview(messageLabel)
    
    
    messageLabel.text = "Connection Successful!"
    messageLabel.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate(
      [
        messageLabel.centerXAnchor.constraint(equalTo: margins.centerXAnchor),
        messageLabel.centerYAnchor.constraint(equalTo : margins.centerYAnchor )
      ]
    )
    
  }
  private func setupDoneBtn() {
    
    view.addSubview(doneButton)
    doneButton.addTarget(self, action: #selector(doneButtonPressed), for: .touchUpInside)
    doneButton.setTitle("Done", for: .normal)
    doneButton.sizeToFit()
    doneButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate(
      [
        doneButton.centerXAnchor.constraint(equalTo: margins.centerXAnchor) ,
        doneButton.centerYAnchor.constraint(equalTo : margins.bottomAnchor, constant:  -doneButton.frame.height)  ,
        doneButton.widthAnchor.constraint(equalToConstant: 100)  ]
    )
    
  }
  
  @objc func doneButtonPressed(sender: UIButton!) {
    self.dismiss(animated: true, completion: nil)
    
  }
  
  
}



