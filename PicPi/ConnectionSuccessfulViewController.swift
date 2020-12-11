//
//  ConnectionSuccessfulViewController.swift
//  PicPi
//
//  Created by Mustafa T. Mohammed on 12/9/20.
//

import UIKit

class ConnectionSuccessfulViewController: UIViewController {
    let doneBtn = customBtnRoundCornerBlueWithShadow(type: .custom)
    let messageLabel = UILabel()
    
    var margins  : UILayoutGuide!
    var ip  = "" // temp var we will use protocol to retrive saved ip addresses
    override func loadView() {
        super.loadView()
        view.backgroundColor = .white
        margins = view.layoutMarginsGuide
        setupDoneBtn()
        setupMessageLabel() 
        // Do any additional setup after loading the view.
    }
    // MARK: - Private
    private func setupMessageLabel() {
        
        view.addSubview(messageLabel)
        
        
        messageLabel.text = "Connection Successful!"
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([messageLabel.centerXAnchor.constraint(equalTo: margins.centerXAnchor) ,         messageLabel.centerYAnchor.constraint(equalTo : margins.centerYAnchor )   ])
        
    }
    private func setupDoneBtn() {
        
        view.addSubview(doneBtn)
        doneBtn.addTarget(self, action: #selector(doneBtnAct), for: .touchUpInside)
        
        doneBtn.setTitle("Done", for: .normal)
        doneBtn.sizeToFit()
        doneBtn.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([doneBtn.centerXAnchor.constraint(equalTo: margins.centerXAnchor) ,         doneBtn.centerYAnchor.constraint(equalTo : margins.bottomAnchor, constant:  -doneBtn.frame.height)  ,doneBtn.widthAnchor.constraint(equalToConstant: 100)  ])
        
    }
    
    
    
    
    @objc func doneBtnAct(sender: UIButton!) {
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
}



