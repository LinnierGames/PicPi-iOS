//
//  customeUITextField.swift
//  PicPi
//
//  Created by Mustafa T. Mohammed on 12/9/20.
//

import UIKit

class customUITextFieldWithDecimalPad: UITextField {

 
    override func didMoveToSuperview() {
        super .didMoveToSuperview()
        
        layer.borderWidth = 1.3
        layer.cornerRadius = 3.0
        keyboardType = .decimalPad
        font = UIFont.systemFont(ofSize: 15)
       borderStyle = UITextField.BorderStyle.roundedRect
        autocorrectionType = UITextAutocorrectionType.no
       keyboardType = UIKeyboardType.decimalPad
          clearButtonMode = UITextField.ViewMode.whileEditing
        contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 10, dy: 5)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 10, dy: 5)
    }

}
