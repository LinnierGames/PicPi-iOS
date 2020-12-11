//
//  ViewController.swift
//  PicPi
//
//  Created by Erick Sanchez on 12/7/20.
//

import UIKit

class HomeViewController: UIViewController     {
    
    
    let searchBtn = customBtnRoundCornerBlueWithShadow(type: .custom)
    let tableView = UITableView()
    var margins  : UILayoutGuide!
    var ip  = "" // temp var for the IP Address , I suggest using a dict to save ip's to keychain
    override func loadView() {
        super.loadView()
        margins = view.layoutMarginsGuide
        setupSearchBtn()
        setupTableView()
        tableView.isHidden = true
        view.backgroundColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) { // try to make it simple for now by updating the table if there is any saved IP Address
        super.viewWillAppear(animated)
        if let ipData = KeyChain.loadKey(PI_IP_KEYCHAIN_KEY) {
            ip = String(decoding: ipData, as: UTF8.self)
            tableView.isHidden = false
            tableView.reloadData()
            
        }
        
    }
    
    
    // MARK: - Private
    
    private func setupSearchBtn() {
        
        //    searchBtn.frame.size = CGSize(width: 100, height: 50)
        view.addSubview(searchBtn)
        //add action when search button pressed
        searchBtn.addTarget(self, action: #selector(searchAct), for: .touchUpInside)
        
        searchBtn.setTitle("Search", for: .normal)
        searchBtn.sizeToFit()
        searchBtn.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([searchBtn.centerXAnchor.constraint(equalTo: margins.centerXAnchor) ,         searchBtn.centerYAnchor.constraint(equalTo : margins.bottomAnchor, constant:  -searchBtn.frame.height)  ,searchBtn.widthAnchor.constraint(equalToConstant: 100)  ])
        
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
        NSLayoutConstraint.activate([  tableView.topAnchor.constraint(equalTo: margins.topAnchor) ,tableView.leftAnchor.constraint(equalTo: view.leftAnchor) , tableView.rightAnchor.constraint(equalTo: view.rightAnchor), tableView.bottomAnchor.constraint(equalTo: searchBtn.topAnchor) ])
        
        
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

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

