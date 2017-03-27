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
}
