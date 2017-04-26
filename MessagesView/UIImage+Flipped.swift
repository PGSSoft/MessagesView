//
//  UIImageUtils.swift
//  MessagesView
//
//  Created by Damian Kanak on 20/04/17.
//  Copyright © 2017 pgs-dkanak. All rights reserved.
//

import Foundation

extension UIImage {
    var flipped: UIImage {
        
        defer {
            UIGraphicsEndImageContext()
        }
        
        UIGraphicsBeginImageContextWithOptions(self.size, false, scale)
        
        guard let context = UIGraphicsGetCurrentContext() else {
            return UIImage()
        }
        
        context.translateBy(x: size.width, y: size.height)
        context.scaleBy(x: -1, y: -1)
        context.draw(self.cgImage!, in: CGRect(origin: .zero, size: size))
        
        return UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
    }
}
