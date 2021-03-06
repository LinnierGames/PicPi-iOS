//
//  AddFrameViewController.swift
//  PicPi
//
//  Created by Erick Sanchez on 12/7/20.
//

import UIKit

class AddFrameViewController: UIViewController, UITextFieldDelegate  {
  
  let nextButton = customBtnRoundCornerBlueWithShadow(type: .custom)
  let ipTextField = customUITextFieldWithDecimalPad()
  var margins: UILayoutGuide!
  let mqttManager =  MQTTManager()
  private let userPreferences = injectUserPreferences()

  init() {
    super.init(nibName: nil, bundle: nil)
    mqttManager.delegate = self
  }

  @available(*,unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .systemBackground
    margins = view.layoutMarginsGuide
    hideKeyboardWhenTappedAround()
    setupNaviationItem()
    setupSearchBtn()
    setupIpTxtFld()
  }

  // MARK: - Private

  private func setupNaviationItem() {
    let closeButton = UIBarButtonItem(
      barButtonSystemItem: .done,
      target: self,
      action: #selector(doneButtonPressed)
    )
    navigationItem.setLeftBarButton(closeButton, animated: false)
  }
  
  private func setupSearchBtn() {
    
    view.addSubview(nextButton)
    nextButton.addTarget(self, action: #selector(nextButtonPressed), for: .touchUpInside)
    nextButton.setTitle("Next", for: .normal)
    nextButton.sizeToFit()
    nextButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate(
      [
        nextButton.centerXAnchor.constraint(equalTo: margins.centerXAnchor),
        nextButton.centerYAnchor.constraint(equalTo : margins.bottomAnchor, constant:  -nextButton.frame.height),
        nextButton.widthAnchor.constraint(equalToConstant: 100)
      ]
    )
    
  }
  
  private func setupIpTxtFld() {
    ipTextField.placeholder = "Enter Pi IP Address"
    ipTextField.sizeToFit()
    view.addSubview(ipTextField)
    ipTextField.delegate = self
    ipTextField.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate(
      [
        ipTextField.centerXAnchor.constraint(equalTo: margins.centerXAnchor),
        ipTextField.centerYAnchor.constraint(equalTo : margins.centerYAnchor ),
        ipTextField.widthAnchor.constraint(equalToConstant: 300)
      ]
    )
    
  }
  
  @objc func nextButtonPressed(sender: UIButton!) {
    guard
      let ipAddress = ipTextField.text, ipAddress.isEmpty != true
    else {
      return
    }
    mqttManager.validIP(ipAddress)
  }

  @objc func doneButtonPressed(sender: UIButton!) {
    self.presentingViewController?.dismiss(animated: true)
  }
}

extension AddFrameViewController : MQTTManagerDelegate {
  func manager(_ manager: MQTTManager, didUpdateConnectionStatus isConnected: Bool) {
    if isConnected, let ip = ipTextField.text {
      userPreferences.add(ipAddress: ip)
    }
    weak var presentingVC = self.presentingViewController
    self.dismiss(animated: true, completion: {
      let ConnectionSuccessfulVC = ConnectionSuccessfulViewController()
      ConnectionSuccessfulVC.modalPresentationStyle = .fullScreen
      presentingVC?.present(ConnectionSuccessfulVC, animated: true, completion: nil)
    })
  }
}
