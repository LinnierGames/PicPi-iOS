//
//  AddFrameViewController.swift
//  PicPi
//
//  Created by Erick Sanchez on 12/7/20.
//

import UIKit

class AddFrameViewController: UIViewController, UITextFieldDelegate  {
    
    let nextBtn = customBtnRoundCornerBlueWithShadow(type: .custom)
    //    let ipTxtFld = customUITextFieldWithDecimalPad(frame: CGRect(x: 20, y: 100, width: 300, height: 40))
    let ipTxtFld = customUITextFieldWithDecimalPad()
    var margins: UILayoutGuide!
    var mqttManager =  MQTTManager()
    override func loadView() {
        super.loadView()
        margins = view.layoutMarginsGuide
        hideKeyboardWhenTappedAround()
        mqttManager.delegate = self
        setupSearchBtn()
        setupIpTxtFld()
        // Do any additional setup after loading the view.
        // setup next button
        view.backgroundColor = .white
    }
    
    private func setupSearchBtn() {
        
        //    searchBtn.frame.size = CGSize(width: 100, height: 50)
        view.addSubview(nextBtn)
        nextBtn.addTarget(self, action: #selector(nextAct), for: .touchUpInside)
        
        nextBtn.setTitle("Next", for: .normal)
        nextBtn.sizeToFit()
        nextBtn.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([nextBtn.centerXAnchor.constraint(equalTo: margins.centerXAnchor) ,         nextBtn.centerYAnchor.constraint(equalTo : margins.bottomAnchor, constant:  -nextBtn.frame.height)  ,nextBtn.widthAnchor.constraint(equalToConstant: 100)  ])
        
    }
    
    private func setupIpTxtFld() {
        
        //    searchBtn.frame.size = CGSize(width: 100, height: 50)
        ipTxtFld.placeholder = "Enter Pi IP Address"
        ipTxtFld.sizeToFit()
        view.addSubview(ipTxtFld)
        
        ipTxtFld.delegate = self
        ipTxtFld.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([ipTxtFld.centerXAnchor.constraint(equalTo: margins.centerXAnchor) ,         ipTxtFld.centerYAnchor.constraint(equalTo : margins.centerYAnchor )  ,ipTxtFld.widthAnchor.constraint(equalToConstant: 300)  ])
        
    }
    
    @objc func nextAct(sender: UIButton!) {
        guard
            let ipAddress = ipTxtFld.text, ipAddress.isEmpty != true
        else {
            return
        }
        mqttManager.validIP(ipAddress)
    }
}


extension AddFrameViewController : MQTTManagerDelegate {
    func manager(_ manager: MQTTManager, didUpdateConnectionStatus isConnected: Bool) {
        if isConnected {
            let ip: String = ipTxtFld.text!
            let data = Data(ip.utf8)
            _ = KeyChain.save(key: PI_IP_KEYCHAIN_KEY, data: data)
            
        }
        weak var presentingVC = self.presentingViewController
        self.dismiss(animated: true, completion: {
            let ConnectionSuccessfulVC = ConnectionSuccessfulViewController()
            ConnectionSuccessfulVC.modalPresentationStyle = .fullScreen
            presentingVC?.present(ConnectionSuccessfulVC, animated: true, completion: nil)
        })
    }
}
