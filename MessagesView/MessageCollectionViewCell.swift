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
    
    @IBOutlet weak var labelWidthLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var labelLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var labelTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var labelTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var labelBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var backgroundTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var backgroundLeadingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var bottomSpacingConstraint: NSLayoutConstraint!
    
    private let defaultBubbleMargin: CGFloat = 8
    private let additionalTextLabelVerticalSpacing: CGFloat = 4
    
    static let patternCell = MessageCollectionViewCell.fromNib()
    
    var side: Side = .left
    var positionInGroup: MessagePositionInGroup = .whole
    var textInsets: UIEdgeInsets = .zero
    var bottomSpacing: CGFloat = 0
    var minimalHorizontalSpacing: CGFloat = 0
    
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
        
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    override func layoutSubviews() {

        adjustConstraints()
        
        super.layoutSubviews()
    }

    private func adjustConstraints() {
        
        switch side {
            
        case .left:
            labelLeadingConstraint.constant = textInsets.left
            labelTrailingConstraint.constant = textInsets.right
            backgroundLeadingConstraint.constant = defaultBubbleMargin
            backgroundTrailingConstraint.constant = minimalHorizontalSpacing
            
        case .right:
            labelLeadingConstraint.constant = textInsets.left
            labelTrailingConstraint.constant = textInsets.right
            backgroundLeadingConstraint.constant = minimalHorizontalSpacing
            backgroundTrailingConstraint.constant = defaultBubbleMargin
        }
        
        switch positionInGroup {
        case .top:
            labelTopConstraint.constant = textInsets.top
            labelBottomConstraint.constant = additionalTextLabelVerticalSpacing
        case .middle:
            labelTopConstraint.constant = additionalTextLabelVerticalSpacing
            labelBottomConstraint.constant = additionalTextLabelVerticalSpacing
        case .bottom:
            labelTopConstraint.constant = additionalTextLabelVerticalSpacing
            labelBottomConstraint.constant = textInsets.bottom
        case .whole:
            labelTopConstraint.constant = textInsets.top
            labelBottomConstraint.constant = textInsets.bottom
        }
        
        bottomSpacingConstraint.constant = bottomSpacing
    }
    
    func size(message: String, width: CGFloat, bubbleImage: BubbleImage, minimalHorizontalSpacing: CGFloat,
              messagePositionInGroup: MessagePositionInGroup) -> CGSize {
        
        var labelMargins = minimalHorizontalSpacing + defaultBubbleMargin
        labelMargins += bubbleImage.textInsets.left + bubbleImage.textInsets.right

        let rect = message.boundingRect(with: CGSize(width: width - labelMargins, height: .infinity),
                                        options: [.usesLineFragmentOrigin],
                                        attributes: [NSFontAttributeName: textLabel.font], context: nil)
        
        var resultSize = rect.integral.size
        
        resultSize.width += labelMargins
        
        switch messagePositionInGroup {
        case .top:
            resultSize.height += bubbleImage.textInsets.top + additionalTextLabelVerticalSpacing
        case .middle:
            resultSize.height += 2 * additionalTextLabelVerticalSpacing
        case .bottom:
            resultSize.height += bubbleImage.textInsets.bottom + additionalTextLabelVerticalSpacing
        case .whole:
            resultSize.height += bubbleImage.textInsets.top + bubbleImage.textInsets.bottom
        }

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
        
        messageBackgroundView.backgroundColor = UIColor.clear
        messageBackgroundView.tintColor = backgroundColor
        
        textLabel.textColor = textColor
        
        minimalHorizontalSpacing = settings.minimalHorizontalSpacing
    }
}
