//
//  AddFrameViewController.swift
//  PicPi
//
//  Created by Erick Sanchez on 12/7/20.
//

import UIKit

class AddFrameViewController: UITableViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.

    // setup next button
    let nextButton = UIButton(type: .system)
    nextButton.setTitle("Next", for: .normal)
    view.addSubview(nextButton)

    NSLayoutConstraint.activate([
      nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
    ])
  }
}
