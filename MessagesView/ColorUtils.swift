//
//  ColorUtils.swift
//  MessagesView
//
//  Created by Damian Kanak on 23/03/17.
//  Copyright © 2017 pgs-dkanak. All rights reserved.
//

import Foundation

extension UIColor {
    var rgba : (CGFloat, CGFloat, CGFloat, CGFloat) {
        var red = CGFloat()
        var green = CGFloat()
        var blue = CGFloat()
        var alpha = CGFloat()
        self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return (red, green, blue, alpha)
    }

    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}

//MARK: MessagesView unique color schema

extension UIColor {
    static let eucalyptus = UIColor(rgb: 0x42C4A3)
    static let pumpkin = UIColor(rgb: 0xFF7726)
    static let antiflashWhite = UIColor(rgb: 0xF0F4F2)
    static let pastelGrey = UIColor(rgb: 0xCCCCCC)
}
