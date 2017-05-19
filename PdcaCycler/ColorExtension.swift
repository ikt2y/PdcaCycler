//
//  ColorExtension.swift
//  PdcaCycler
//
//  Created by sel on 2017/05/19.
//  Copyright © 2017年 sel. All rights reserved.
//

import UIKit

extension UIColor {
    
    func colorFromRGB(rgb: String, alpha: CGFloat) -> UIColor {
        let scanner = Scanner(string: rgb)
        var rgbInt: UInt32 = 0
        scanner.scanHexInt32(&rgbInt)
        
        let r = CGFloat(((rgbInt & 0xFF0000) >> 16)) / 255.0
        let g = CGFloat(((rgbInt & 0x00FF00) >> 8)) / 255.0
        let b = CGFloat(rgbInt & 0x0000FF) / 255.0
        
        return UIColor(red: r, green: g, blue: b, alpha: alpha)
    }
    
}
