//
//  BubbleImage.swift
//  MessagesView
//
//  Created by Damian Kanak on 11/04/17.
//  Copyright © 2017 pgs-dkanak. All rights reserved.
//

import Foundation

public class BubbleImage {
    
    private enum Slice {
        case whole
        case top
        case middle
        case bottom
    }
    
    public let image: UIImage
    
    public let resizeInsets: UIEdgeInsets
    
    public lazy var whole: UIImage? = self.cropAndResize(slice: .whole)
    public lazy var top: UIImage? = self.cropAndResize(slice: .top)
    public lazy var middle: UIImage? = self.cropAndResize(slice: .middle)
    public lazy var bottom: UIImage? = self.cropAndResize(slice: .bottom)
    
    var flipped: BubbleImage {
        
        let flippedImage = image.flipped
        let flippedInsets = UIEdgeInsets(top: resizeInsets.top,
                                         left: resizeInsets.right,
                                         bottom: resizeInsets.bottom,
                                         right: resizeInsets.left)
        
        return BubbleImage(image: flippedImage, resizeInsets: flippedInsets)
    }
    
    required public init(image: UIImage, resizeInsets: UIEdgeInsets) {
        self.image = image
        self.resizeInsets = resizeInsets
    }
        
    private func cropAndResize(slice: Slice) -> UIImage? {
        
        let capInsets: UIEdgeInsets
        let cropRect: CGRect
        
        let width = image.size.width * image.scale
        let height = image.size.height * image.scale
        let middleHeight = height - resizeInsets.top - resizeInsets.bottom
        
        switch slice {
        case .whole:
            capInsets = resizeInsets
            cropRect = CGRect(x: 0, y: 0, width: width, height: height)
        case .top:
            capInsets = UIEdgeInsets(top: resizeInsets.top, left: resizeInsets.left, bottom: 0, right: resizeInsets.right)
            cropRect = CGRect(x: 0, y: 0, width: width, height: resizeInsets.top + middleHeight)
        case .middle:
            capInsets = UIEdgeInsets(top: 0, left: resizeInsets.left, bottom: 0, right: resizeInsets.right)
            cropRect = CGRect(x: 0, y: resizeInsets.top, width: width, height: middleHeight)
        case .bottom:
            capInsets = UIEdgeInsets(top: 0, left: resizeInsets.left, bottom: resizeInsets.bottom, right: resizeInsets.right)
            cropRect = CGRect(x: 0, y: resizeInsets.top, width: width, height: resizeInsets.bottom + middleHeight)
        }
        
        guard let croppedImage = image.cgImage?.cropping(to: cropRect) else {
            return nil
        }
        
        return UIImage(cgImage: croppedImage).resizableImage(withCapInsets: capInsets, resizingMode: .stretch).withRenderingMode(.alwaysTemplate)
    }
}
