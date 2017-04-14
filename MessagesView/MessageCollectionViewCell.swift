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
    @IBOutlet weak var messageBackgroundView: UIImageView!
    
    @IBOutlet weak var leftArrowView: UIView!
    @IBOutlet weak var rightArrowView: UIView!
    
    @IBOutlet weak var labelWidthLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var labelLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var labelTrailingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var backgroundTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var backgroundLeadingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var topSpacingViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomSpacingViewHeightConstraint: NSLayoutConstraint!
    
    static var leftArrowImage = MessageCollectionViewCell.createArrowImage(inSize: CGSize(width: 10.0, height: 10.0)) ?? UIImage()
    static var rightArrowImage = UIImage(cgImage: (leftArrowImage.cgImage)!, scale: 1.0, orientation: .upMirrored).withRenderingMode(.alwaysTemplate)
    
    static let patternCell = MessageCollectionViewCell.fromNib()
    
    var side: Side = .left
    
    var message : MessagesViewChatMessage? {
        didSet {
            textLabel.text = message?.text ?? ""
            side = (message?.onRight ?? false) ? .right : .left
        }
    }
    
    private var backgroundMarginConstant: CGFloat = 0.0
    private var labelMarginConstant: CGFloat = 0.0
    
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
        labelMarginConstant = self.labelLeadingConstraint.constant
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
    
    func addMessageMargin(side: Side, margin: CGFloat, bubbleMargin: UIEdgeInsets?) {
        var bubbleAdditionalMargin = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        if let margin = bubbleMargin {
            bubbleAdditionalMargin = margin
        }
        switch side {
        case .left:
            backgroundLeadingConstraint.constant = backgroundMarginConstant
            backgroundTrailingConstraint.constant = backgroundMarginConstant + margin
            labelLeadingConstraint.constant = labelMarginConstant + bubbleAdditionalMargin.left
            labelTrailingConstraint.constant = labelMarginConstant + bubbleAdditionalMargin.right
        case .right:
            backgroundLeadingConstraint.constant = backgroundMarginConstant + margin
            backgroundTrailingConstraint.constant = backgroundMarginConstant
            labelLeadingConstraint.constant = labelMarginConstant + bubbleAdditionalMargin.left
            labelTrailingConstraint.constant = labelMarginConstant + bubbleAdditionalMargin.right
        }
    }
    
    func adjustSpacing(spacing: UIEdgeInsets) {
        topSpacingViewHeightConstraint.constant = spacing.top
        bottomSpacingViewHeightConstraint.constant = spacing.bottom
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
        
        let result = UIGraphicsGetImageFromCurrentImageContext()?.withRenderingMode(.alwaysTemplate)
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
    
    func size(message: String, containerInsets: CGFloat) -> CGSize {
        let labelMargins = labelLeadingConstraint.constant + backgroundLeadingConstraint.constant + backgroundTrailingConstraint.constant + labelTrailingConstraint.constant
        
        textLabel.text = message
        textLabel.preferredMaxLayoutWidth = containerInsets - labelMargins
        labelWidthLayoutConstraint.constant = containerInsets - labelMargins
        
        return contentView.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
    }

    func applySettings(settings: MessagesViewSettings) {
        let textColor, backgroundColor: UIColor
        switch side {
        case .left:
            textColor = settings.leftMessageCellTextColor
            backgroundColor = settings.leftMessageCellBackgroundColor
        case .right:
            textColor = settings.rightMessageCellTextColor
            backgroundColor = settings.rightMessageCellBackgroundColor
        }
        
        if messageBackgroundView.image != nil {
            messageBackgroundView.backgroundColor = UIColor.clear
            leftArrowView.tintColor = UIColor.clear
            rightArrowView.tintColor = UIColor.clear
            messageBackgroundView.tintColor = backgroundColor
        } else {
            messageBackgroundView.tintColor = UIColor.clear
            messageBackgroundView.backgroundColor = backgroundColor
            leftArrowView.tintColor = backgroundColor
            rightArrowView.tintColor = backgroundColor
        }
        textLabel.textColor = textColor

    }
}
