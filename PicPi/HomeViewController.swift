//
//  ViewController.swift
//  PicPi
//
//  Created by Erick Sanchez on 12/7/20.
//

import UIKit

class HomeViewController: UIViewController     {
  
  
  let searchButton = customBtnRoundCornerBlueWithShadow(type: .custom)
  let tableView = UITableView()
  var margins  : UILayoutGuide!
  var ip  = ""
  /// temp var for the IP Address , I suggest using a dict to save ip's to keychain
  override func loadView() {
    super.loadView()
    margins = view.layoutMarginsGuide
    setupSearchBtn()
    setupTableView()
    tableView.isHidden = true
    view.backgroundColor = .white
  }
  
  override func viewWillAppear(_ animated: Bool) {
    /// try to make it simple for now by updating the table if there is any saved IP Address
    super.viewWillAppear(animated)
    if let ipData = KeyChain.loadKey(Constants.KeyChains.piIPAddressKey) {
      ip = String(decoding: ipData, as: UTF8.self)
      tableView.isHidden = false
      tableView.reloadData()
      
    }
    
  }
  
  
  // MARK: - Private
  
  private func setupSearchBtn() {
    view.addSubview(searchButton)
    ///add action when search button pressed
    searchButton.addTarget(self, action: #selector(searchAct), for: .touchUpInside)
    searchButton.setTitle("Search", for: .normal)
    searchButton.sizeToFit()
    searchButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate(
      [
        searchButton.centerXAnchor.constraint(equalTo: margins.centerXAnchor) ,
        searchButton.centerYAnchor.constraint(equalTo : margins.bottomAnchor, constant:  -searchButton.frame.height)  ,
        searchButton.widthAnchor.constraint(equalToConstant: 100)
      ]
    )
    
  }
  
  
  
  
  @objc func searchAct(sender: UIButton!) {
    let addFrameVC = AddFrameViewController()
    addFrameVC.modalPresentationStyle = .fullScreen
    self.present(addFrameVC, animated: true, completion: nil)
  }
  
  private func setupTableView() {
    tableView.dataSource = self
    view.addSubview(tableView)
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    tableView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate(
      [
        tableView.topAnchor.constraint(equalTo: margins.topAnchor),
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
        tableView.bottomAnchor.constraint(equalTo: searchButton.topAnchor),
      ]
    )
    }
}

extension HomeViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    cell.textLabel?.text = ip
    cell.textLabel?.textAlignment = .center
    return cell
  }
}
