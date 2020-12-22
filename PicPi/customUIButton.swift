//
//  customUIButton.swift
//  PicPi
//
//  Created by Mustafa T. Mohammed on 12/9/20.
//

import UIKit

class customBtnRoundCornerBlueWithShadow: UIButton {
  
  
  override func didMoveToSuperview() {
    super .didMoveToSuperview()
    
    layer.shadowOpacity = 0.8
    layer.shadowRadius = 1.0
    layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
    layer.cornerRadius = 10.0
    layer.backgroundColor = UIColor.white.cgColor
    backgroundColor = UIColor.blue
    layer.borderColor = UIColor.black.cgColor
    layer.borderWidth = 1.0
  }
}


