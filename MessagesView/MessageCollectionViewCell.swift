//
//  MessageCollectionViewCell.swift
//  kilio
//
//  Created by Damian Kanak on 14.06.2016.
//  Copyright © 2016 PGS Software. All rights reserved.
//

import UIKit

enum Side {
    case right
    case left
    
    var other : Side {
        switch self {
        case .left:
            return .right
        case .right:
            return .left
        }
    }
}


@IBDesignable
class MessageCollectionViewCell: UICollectionViewCell {
    @IBInspectable var cornerRadius : CGFloat = 5.0
    @IBInspectable var textBackgroundColor : UIColor = UIColor.blue
    @IBInspectable var tailStrokeColor : UIColor = UIColor.black
    @IBInspectable var tailFillColor : UIColor = UIColor.blue
    
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var messageBackgroundView: UIView!
    
    @IBOutlet weak var leftArrowView: UIView!
    @IBOutlet weak var rightArrowView: UIView!
    
    @IBOutlet weak var labelWidthLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var labelLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var labelTrailingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var backgroundTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var backgroundLeadingConstraint: NSLayoutConstraint!
    
    static var leftArrowImage = MessageCollectionViewCell.createArrowImage(inSize: CGSize(width: 10.0, height: 10.0)) ?? UIImage()
    static var rightArrowImage = UIImage(cgImage: (leftArrowImage.cgImage)!, scale: 1.0, orientation: .upMirrored)
    
    static let patternCell = MessageCollectionViewCell.fromNib()
    static var hostPeerSide = Side.right
    var message : MessagesViewChatMessage? {
        didSet {
            textLabel.text = message?.text ?? ""
        }
    }
    
    private var backgroundMarginConstant : CGFloat = 0.0
    
    class func fromNib() -> MessageCollectionViewCell?
    {
        var cell: MessageCollectionViewCell?
        let bundle = Bundle(for: self.classForCoder())
        let nibViews = bundle.loadNibNamed(String(describing: self.classForCoder()), owner: nil, options: nil)
        for nibView in nibViews! {
            if let cellView = nibView as? MessageCollectionViewCell {
                cell = cellView
            }
        }
        return cell
    }
    
    class func calculateCellSizeFor(text: String) -> CGSize {
        if let cell = patternCell {
            cell.textLabel.text = text
            return cell.contentView.systemLayoutSizeFitting(cell.textLabel.frame.size)
        }
        return CGSize(width: 0, height: 0)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        messageBackgroundView.backgroundColor = self.textBackgroundColor
        messageBackgroundView.layer.cornerRadius = self.cornerRadius
        backgroundMarginConstant = self.backgroundTrailingConstraint.constant
    }
    
    func addTails() {
        self.leftArrowView.subviews.forEach{$0.removeFromSuperview()}
        self.leftArrowView.addSubview(UIImageView(image: MessageCollectionViewCell.leftArrowImage))
        self.rightArrowView.subviews.forEach{$0.removeFromSuperview()}
        self.rightArrowView.addSubview(UIImageView(image: MessageCollectionViewCell.rightArrowImage))
    }
    
    func showTail(side: Side) {
        switch side {
        case .left:
            self.rightArrowView.isHidden = true
            self.leftArrowView.isHidden = false
        case .right:
            self.rightArrowView.isHidden = false
            self.leftArrowView.isHidden = true
        }
    }
    
    func addMessageMargin(side: Side, margin: CGFloat) {
        switch side {
        case .left:
            backgroundLeadingConstraint.constant = backgroundMarginConstant
            backgroundTrailingConstraint.constant = backgroundMarginConstant + margin
        case .right:
            backgroundLeadingConstraint.constant = backgroundMarginConstant + margin
            backgroundTrailingConstraint.constant = backgroundMarginConstant
        }
    }
    
    static func createArrowImage(inSize size: CGSize) -> UIImage! {
        UIGraphicsBeginImageContext(size)
        let context = UIGraphicsGetCurrentContext()
        let tailStrokeColor = MessageCollectionViewCell.patternCell?.tailStrokeColor ?? UIColor.blue
        let tailFillColor = MessageCollectionViewCell.patternCell?.tailFillColor ?? UIColor.blue
        context?.setStrokeColor(tailStrokeColor.cgColor)
        context?.setFillColor(tailFillColor.cgColor)
        
        let tailPath = MessageCollectionViewCell.createTailPathIn(size: size)
        context?.addPath(tailPath)
        context?.fillPath()
        context?.strokePath()
        
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
    
    static func createTailPathIn(size: CGSize) -> CGPath {
        let aWidth  = size.width
        let aHeight = size.height
        
        let mutablePath = CGMutablePath()
        mutablePath.move(to: CGPoint(x: 0.0, y: 1.0*aHeight))
        mutablePath.addQuadCurve(to: CGPoint(x: 0.5*aWidth, y: 0.0), control: CGPoint(x: 0.6*aWidth, y: 0.9*aHeight))
        mutablePath.addLine(to: CGPoint(x: 1.0*aWidth, y: 0.0))
        mutablePath.addLine(to: CGPoint(x: 1.0*aWidth, y: 0.5*aHeight))
        mutablePath.addQuadCurve(to: CGPoint(x: 0.0, y: 1.0*aHeight), control: CGPoint(x: 0.5*aWidth, y: 1.0*aHeight))
        mutablePath.closeSubpath()
        
        return mutablePath
    }
}
