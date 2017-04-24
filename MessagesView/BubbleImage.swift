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
    public let textInsets: UIEdgeInsets
    
    public lazy var whole: UIImage? = self.cropAndResize(slice: .whole)
    public lazy var top: UIImage? = self.cropAndResize(slice: .top)
    public lazy var middle: UIImage? = self.cropAndResize(slice: .middle)
    public lazy var bottom: UIImage? = self.cropAndResize(slice: .bottom)
    
    var flipped: BubbleImage {
        
        let flippedImage = image.flipped
        let flippedResizeInsets = insetsFlippedHorizontally(resizeInsets)
        let flippedTextInsets = insetsFlippedHorizontally(textInsets)
        
        return BubbleImage(image: flippedImage, resizeInsets: flippedResizeInsets, textInsets: flippedTextInsets)
    }
    
    required public init(image: UIImage, resizeInsets: UIEdgeInsets, textInsets: UIEdgeInsets) {
        self.image = image
        self.resizeInsets = resizeInsets
        self.textInsets = textInsets
    }
    
    convenience init(cornerRadius: CGFloat) {
        
        let size = CGSize(width: cornerRadius * 3 + 1, height: cornerRadius * 3 + 1)
        
        let image = BubbleImage.defaultBubbleImage(with: size, cornerRadius: cornerRadius)
        let resizeInsets = UIEdgeInsets(top: cornerRadius, left: cornerRadius * 2, bottom: cornerRadius * 2, right: cornerRadius)
        let textInsets = UIEdgeInsets(top: cornerRadius, left: cornerRadius, bottom: cornerRadius * 2, right: cornerRadius)
        
        self.init(image: image, resizeInsets: resizeInsets, textInsets: textInsets)
    }
    
    private func insetsFlippedHorizontally(_ edgeInsets: UIEdgeInsets) -> UIEdgeInsets {
        return UIEdgeInsets(top: edgeInsets.top,
                            left: edgeInsets.right,
                            bottom: edgeInsets.bottom,
                            right: edgeInsets.left)
    }
    
    private func cropAndResize(slice: Slice) -> UIImage? {
        
        let width = image.size.width * image.scale
        let height = image.size.height * image.scale
        
        let scaledResizeInsets = UIEdgeInsets(top: resizeInsets.top * image.scale,
                                              left: resizeInsets.left * image.scale,
                                              bottom: resizeInsets.bottom * image.scale,
                                              right: resizeInsets.right * image.scale)
        
        
        let middleHeight = height - scaledResizeInsets.top - scaledResizeInsets.bottom
        
        let capInsets: UIEdgeInsets
        let cropRect: CGRect
        
        switch slice {
        case .whole:
            capInsets = resizeInsets
            cropRect = CGRect(x: 0, y: 0, width: width, height: height)
        case .top:
            capInsets = UIEdgeInsets(top: resizeInsets.top, left: resizeInsets.left, bottom: 0, right: resizeInsets.right)
            cropRect = CGRect(x: 0, y: 0, width: width, height: scaledResizeInsets.top + middleHeight)
        case .middle:
            capInsets = UIEdgeInsets(top: 0, left: resizeInsets.left, bottom: 0, right: resizeInsets.right)
            cropRect = CGRect(x: 0, y: scaledResizeInsets.top, width: width, height: middleHeight)
        case .bottom:
            capInsets = UIEdgeInsets(top: 0, left: resizeInsets.left, bottom: resizeInsets.bottom, right: resizeInsets.right)
            cropRect = CGRect(x: 0, y: scaledResizeInsets.top, width: width, height: scaledResizeInsets.bottom + middleHeight)
        }
        
        guard let croppedImage = image.cgImage?.cropping(to: cropRect) else {
            return nil
        }
        let cropped = UIImage(cgImage: croppedImage, scale: image.scale, orientation: .up)
        
        
        return cropped.resizableImage(withCapInsets: capInsets, resizingMode: .stretch).withRenderingMode(.alwaysTemplate)
    }
 
    public static func defaultBubbleImage(with size: CGSize, cornerRadius: CGFloat) -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        
        UIColor.red.setFill()
        UIColor.red.setStroke()
        
        let tailSize = CGSize(width: cornerRadius * 2, height: cornerRadius)
        let bubbleSize = CGSize(width: size.width, height: size.height - tailSize.height)
        
        let bubblePath = UIBezierPath(roundedRect: CGRect(origin: .zero, size: bubbleSize), cornerRadius: cornerRadius)
        bubblePath.fill()
        bubblePath.stroke()
        
        let tailPath = createTailPathIn(origin: CGPoint(x: 0, y: size.height - tailSize.height), size: tailSize)
        tailPath.fill()
        tailPath.stroke()
        
        let result = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return result
    }
    
    public static func createTailPathIn(origin: CGPoint, size: CGSize) -> UIBezierPath {
        let width  = size.width
        let height = size.height
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0.0, y: height))
        path.addQuadCurve(to: CGPoint(x: 0.5 * width, y: -0.5 * height), controlPoint: CGPoint(x: 0.6 * width, y: 0.8 * height))
        path.addLine(to: CGPoint(x: width, y: 0.0))
        path.addQuadCurve(to: CGPoint(x: 0.0, y: height), controlPoint: CGPoint(x: 0.5 * width, y: height))
        
        path.apply(CGAffineTransform(translationX: origin.x, y: origin.y))
        
        return path
    }
}
