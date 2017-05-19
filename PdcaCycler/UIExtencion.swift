//
//  UIExtencion.swift
//  PdcaCycler
//
//  Created by sel on 2017/05/19.
//  Copyright © 2017年 sel. All rights reserved.
//

import UIKit

extension UITextField {
    func addBorderBottom(height: CGFloat, color: UIColor) {
        let border = CALayer()
        border.frame = CGRect(x: 0, y: self.frame.height - height, width: self.frame.width, height: height)
        border.backgroundColor = color.cgColor
        self.layer.addSublayer(border)
    }
}

// 外をタップでキーボード閉じる
extension ViewController: UIGestureRecognizerDelegate {
    func dismissKeyboard(_ gesture: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
}

// Enterでキーボード閉じる.
extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
