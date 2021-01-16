//
//  ViewController.swift
//  PicPi
//
//  Created by Erick Sanchez on 12/7/20.
//

import UIKit

class HomeViewController: UIViewController     {
  private let userPreferences = injectUserPreferences()

  let searchButton = customBtnRoundCornerBlueWithShadow(type: .custom)
  let addButton = UIButton(type: .custom)
  let framesButton = customBtnRoundCornerBlueWithShadow(type: .custom)
  var margins: UILayoutGuide!

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .systemBackground
    title = "PicPi"
    margins = view.layoutMarginsGuide
    setupSearchBtn()
    setupAddButton()
    setupFramesButton()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    /// try to make it simple for now by updating the table if there is any saved IP Address
    super.viewWillAppear(animated)
    addButton.isHidden = userPreferences.ipAddresses().isEmpty
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

  private func setupFramesButton() {
    view.addSubview(framesButton)
    framesButton.setTitle("Frames", for: .normal)
    framesButton.addTarget(self, action: #selector(HomeViewController.framesButtonPressed(sender:)), for: .touchUpInside)
    framesButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate(
      [
        framesButton.centerXAnchor.constraint(equalTo: margins.centerXAnchor),
        framesButton.topAnchor.constraint(equalTo : margins.topAnchor),
      ]
    )
  }
  
  @objc func searchButtonPressed(sender: UIButton!) {
    let navigator = injectNavigator()
    navigator.presentAddPictureFrameFlow()
  }

  @objc func addButtonPressed(sender: UIButton!) {
    let navigator = injectNavigator()
    navigator.presentAddPhotoFlow(preselectedAssets: [], preselectedFrames: [])
  }

  @objc func framesButtonPressed(sender: UIButton!) {
    let pictureFramesVc = PictureFramesViewController()
    navigationController?.pushViewController(pictureFramesVc, animated: true)
  }
}
