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
    
    @IBOutlet weak var leftArrowView: UIImageView!
    @IBOutlet weak var rightArrowView: UIImageView!
    
    @IBOutlet weak var labelWidthLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var labelLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var labelTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var labelTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var labelBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var backgroundTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var backgroundLeadingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var bottomSpacingViewHeightConstraint: NSLayoutConstraint!
    
    private let additionalTextLabelMargin: CGFloat = 8
    
    static var leftTailImage = MessageCollectionViewCell.createArrowImage(inSize: CGSize(width: 40.0, height: 40.0)) ?? UIImage()
    
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
        self.leftArrowView.image = MessageCollectionViewCell.leftTailImage
        self.rightArrowView.image = MessageCollectionViewCell.leftTailImage
        self.rightArrowView.transform = CGAffineTransform(scaleX: -1, y: 1)
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
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
    
    func addMessageMargin(side: Side, marginInsets: UIEdgeInsets, minimalHorizontalSpacing: CGFloat) {

        switch side {
            
        case .left:
            labelLeadingConstraint.constant = marginInsets.left
            labelTrailingConstraint.constant = additionalTextLabelMargin
            backgroundLeadingConstraint.constant = 0
            backgroundTrailingConstraint.constant = minimalHorizontalSpacing
            
        case .right:
            labelLeadingConstraint.constant = additionalTextLabelMargin
            labelTrailingConstraint.constant = marginInsets.right
            backgroundLeadingConstraint.constant = minimalHorizontalSpacing
            backgroundTrailingConstraint.constant = 0
        }
    }
    
    func adjustSpacing(spacing: CGFloat) {
        bottomSpacingViewHeightConstraint.constant = spacing
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
    
    func size(message: String, width: CGFloat, bubbleImage: BubbleImage?, onRight: Bool, minimalHorizontalSpacing: CGFloat) -> CGSize {
        
        var labelMargins = minimalHorizontalSpacing + additionalTextLabelMargin
        if let image = bubbleImage {
            labelMargins += onRight ? image.resizeInsets.left : image.resizeInsets.right
        }

        let rect = message.boundingRect(with: CGSize(width: width - labelMargins, height: 2000),
                                        options: [.usesLineFragmentOrigin],
                                        attributes: [NSFontAttributeName: textLabel.font], context: nil)
        
        var resultSize = rect.integral.size
        
        resultSize.width += labelMargins
        resultSize.height += labelTopConstraint.constant + labelBottomConstraint.constant

        return resultSize
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
