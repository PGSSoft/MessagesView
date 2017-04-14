//
//  BubbleImage.swift
//  MessagesView
//
//  Created by Damian Kanak on 11/04/17.
//  Copyright © 2017 pgs-dkanak. All rights reserved.
//

import Foundation

let defaultCellSpacing = UIEdgeInsets(top: 6, left: 0, bottom: 6, right: 0)

public struct ImageSlice {
    let cropRect: CGRect
    let resizeInsets: UIEdgeInsets
    let spacing: UIEdgeInsets
    
    public init(cropRect: CGRect, resizeInsets: UIEdgeInsets, spacing: UIEdgeInsets = defaultCellSpacing) {
        self.cropRect = cropRect
        self.resizeInsets = resizeInsets
        self.spacing = spacing
    }
}

// four slices: whole, top, middle, bottom

class BubbleImage {
    private var image: UIImage
    
    var wholeSlice: ImageSlice
    var topSlice: ImageSlice?
    var middleSlice: ImageSlice?
    var bottomSlice: ImageSlice?
    
    lazy var whole: UIImage = self.cropAndResize(slice: self.wholeSlice)
    lazy var top: UIImage? = self.cropAndResize(slice: self.topSlice)
    lazy var middle: UIImage? = self.cropAndResize(slice: self.middleSlice)
    lazy var bottom: UIImage? = self.cropAndResize(slice: self.bottomSlice)
    
    var textMargin = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    var horizontalTextMargins: CGFloat {
        return textMargin.left + textMargin.right
    }
    
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
    
    private func cropAndResize(slice: ImageSlice?)->UIImage {
        guard let slice = slice, let croppedImage = image.cgImage?.cropping(to: slice.cropRect) else {
            return UIImage()
        }
        
        return UIImage(cgImage: croppedImage).resizableImage(withCapInsets: slice.resizeInsets, resizingMode: .stretch).withRenderingMode(.alwaysTemplate)
    }
}
