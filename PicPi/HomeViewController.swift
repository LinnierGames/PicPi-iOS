//
//  ViewController.swift
//  PicPi
//
//  Created by Erick Sanchez on 12/7/20.
//

import UIKit

class HomeViewController: UIViewController     {
  private let userPreferences = injectUserPreferences()
  private let scanner = NetworkScanner()
  
  let searchButton = customBtnRoundCornerBlueWithShadow(type: .custom)
  let addButton = UIButton(type: .custom)
  var margins: UILayoutGuide!

  override func loadView() {
    super.loadView()
    margins = view.layoutMarginsGuide
    setupSearchBtn()
    setupAddButton()
    view.backgroundColor = .white
  }
  
  override func viewWillAppear(_ animated: Bool) {
    /// try to make it simple for now by updating the table if there is any saved IP Address
    super.viewWillAppear(animated)
    addButton.isHidden = userPreferences.ipAddresses().isEmpty

    scanner.scan(filter: "picture-frame")
  }
  
  // MARK: - Private
  
  private func setupSearchBtn() {
    view.addSubview(searchButton)
    ///add action when search button pressed
    searchButton.addTarget(self,
                           action: #selector(searchButtonPressed),
                           for: .touchUpInside)
    searchButton.setTitle("Search",
                          for: .normal)
    searchButton.sizeToFit()
    searchButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate(
      [
        searchButton.centerXAnchor.constraint(equalTo: margins.centerXAnchor),
        searchButton.centerYAnchor.constraint(
          equalTo : margins.bottomAnchor,
          constant:  -searchButton.frame.height),
        searchButton.widthAnchor.constraint(
          equalToConstant: 100)
      ]
    )
    
  }
  
  private func setupAddButton() {
    view.addSubview(addButton)
    ///add action when search button pressed
    addButton.addTarget(self, action: #selector(addButtonPressed), for: .touchUpInside)
    if let addButtonImage = UIImage(named: "AddButton") {
      addButton.setImage(addButtonImage, for: .normal)
    }
    addButton.sizeToFit()
    addButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate(
      [
        addButton.centerXAnchor.constraint(equalTo: margins.centerXAnchor) ,
        addButton.centerYAnchor.constraint(
          equalTo : margins.bottomAnchor,
          constant:  -addButton.frame.height
        ),
        addButton.widthAnchor.constraint(equalToConstant: 75),
        addButton.heightAnchor.constraint(equalToConstant: 75)
        
      ]
    )
    
  }
  
  @objc func searchButtonPressed(sender: UIButton!) {
    let addFrameVC = AddFrameViewController()
    addFrameVC.modalPresentationStyle = .fullScreen
    self.present(addFrameVC, animated: true, completion: nil)
  }
  @objc func addButtonPressed(sender: UIButton!) {
    let addPhotoVC = AddPhotoViewController()
    addPhotoVC.modalPresentationStyle = .fullScreen
    self.present(addPhotoVC, animated: true, completion: nil)
  }
  
}
