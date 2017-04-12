//
//  BubbleImage.swift
//  MessagesView
//
//  Created by Damian Kanak on 11/04/17.
//  Copyright © 2017 pgs-dkanak. All rights reserved.
//

import Foundation

public struct ImageSlice {
    let cropRect: CGRect
    let resizeInsets: UIEdgeInsets
    
    public init(cropRect: CGRect, resizeInsets: UIEdgeInsets) {
        self.cropRect = cropRect
        self.resizeInsets = resizeInsets
    }
}

// four slices: whole, top, middle, bottom

class BubbleImage {
    private var image: UIImage
    
    private var wholeSlice: ImageSlice
    private var topSlice: ImageSlice?
    private var middleSlice: ImageSlice?
    private var bottomSlice: ImageSlice?
    
    lazy var whole: UIImage = self.getWholeImage()
    lazy var top: UIImage? = self.getTopImage()
    lazy var middle: UIImage? = self.getMiddleImage()
    lazy var bottom: UIImage? = self.getBottomImage()
    
    var textMargin = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    
    required init(image: UIImage, whole: ImageSlice, top: ImageSlice?, middle: ImageSlice?, bottom: ImageSlice?) {
        self.image = image
        self.wholeSlice = whole
        self.topSlice = top
        self.middleSlice = middle
        self.bottomSlice = bottom
    }
    
    convenience init(settings: MessagesViewBubbleSettings) {
        self.init(image: settings.image, whole: settings.wholeSlice, top: settings.topSlice, middle: settings.middleSlice, bottom: settings.bottomSlice)
    }
    
    private func getWholeImage()->UIImage {
        let wholeImage = cropAndResize(slice: wholeSlice)
        return wholeImage
    }
    
    private func getTopImage()->UIImage? {
        if let top = self.topSlice {
            let topImage = cropAndResize(slice: top)
            return topImage
        }
        return nil
    }
    
    private func getMiddleImage()->UIImage? {
        if let middle = middleSlice {
            let middleImage = cropAndResize(slice: middle)
            return middleImage
        }
        return nil
    }
    
    private func getBottomImage()->UIImage? {
        if let bottom = bottomSlice {
            let bottomImage = cropAndResize(slice: bottom)
            return bottomImage
        }
        return nil
    }
    
    private func cropAndResize(slice: ImageSlice)->UIImage {
        var result = UIImage()
        if let croppedImage = image.cgImage?.cropping(to: slice.cropRect) {
            result = UIImage(cgImage: croppedImage).resizableImage(withCapInsets: slice.resizeInsets, resizingMode: .stretch).withRenderingMode(.alwaysTemplate)
        }
        return result
    }
}
