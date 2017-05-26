//
//  MessagesToolbarContentView.swift
//  kilio
//
//  Created by Damian Kanak on 29.06.2016.
//  Copyright © 2016 PGS Software. All rights reserved.
//

import UIKit

class MessagesToolbarContentView: UIView {

    @IBOutlet weak var topSeparatorLineView: UIView!
    @IBOutlet weak var topSeparatorLineViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var leftButtonContainerView: UIImageView!
    @IBOutlet weak var leftButtonLabel: UILabel!
    
    @IBOutlet weak var rightButtonContainerView: UIImageView!
    @IBOutlet weak var rightButtonLabel: UILabel!
    
    @IBOutlet weak var leftButtonContainerViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var leftButtonContainerViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightButtonContainerViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightButtonContainerViewWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var messageEditorTextView: MessageEditorTextView!
    
    private var originalLeftButtonContainerViewMargin = CGFloat(0)
    private var originalLeftButtonContainerViewWidth = CGFloat(0)
    private var originalRightButtonContainerViewMargin = CGFloat(0)
    private var originalRightButtonContainerViewWidth = CGFloat(0)
    
    private var leftButtonEnabled: Bool = true
    private var rightButtonEnabled: Bool = true
    
    private var leftTintColor: UIColor {
        return leftButtonEnabled ? settings.leftButtonTextColor : settings.leftButtonDisabledColor
    }
    
    private var rightTintColor: UIColor {
        return rightButtonEnabled ? settings.rightButtonTextColor : settings.rightButtonDisabledColor
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        saveOriginalConstraintValues()
    }
    
    private func saveOriginalConstraintValues() {
        originalLeftButtonContainerViewMargin = leftButtonContainerViewLeadingConstraint.constant
        originalLeftButtonContainerViewWidth = leftButtonContainerViewWidthConstraint.constant
        originalRightButtonContainerViewMargin = rightButtonContainerViewTrailingConstraint.constant
        originalRightButtonContainerViewWidth = rightButtonContainerViewWidthConstraint.constant
    }
    
    @IBAction func didPressLeftButton(_ sender: AnyObject) {
        
        if leftButtonEnabled {
            settings.leftButtonAction()
        }
        
        if settings.leftButtonHidesKeyboard {
            _ = resignFirstResponder()
        }
    }
    
    @IBAction func didPressRightButton(_ sender: AnyObject) {
        
        if rightButtonEnabled {
            settings.rightButtonAction()
        }
        
        if settings.rightButtonHidesKeyboard {
            _ = resignFirstResponder()
        }
    }
    
    override func resignFirstResponder() -> Bool {
        return messageEditorTextView.resignFirstResponder()
    }
    
    class func fromNib() -> MessagesToolbarContentView {
        let bundle = Bundle(for: MessagesToolbarContentView.classForCoder())
        let nibViews = bundle.loadNibNamed(String(describing: MessagesToolbarContentView.self), owner: nil, options: nil)
        return nibViews!.first as! MessagesToolbarContentView
    }
    
    var settings = MessagesViewSettings() {
        didSet {
            apply(settings: settings)
        }
    }
    var messageText : String {
        return messageEditorTextView.text
    }
    
    func righButton(show: Bool, animated: Bool) {
        let destination = calculateDestination(side: .right, show: show)
        move(view: self.rightButtonContainerView, animated: animated, constraint: self.rightButtonContainerViewTrailingConstraint, value: destination.margin, alpha: destination.alpha)
    }
    
    func leftButton(show: Bool, animated: Bool) {
        let destination = calculateDestination(side: .left, show: show)
        move(view: self.leftButtonContainerView, animated: animated, constraint: self.leftButtonContainerViewLeadingConstraint, value: destination.margin, alpha: destination.alpha)
    }
    
    func setLeftButton(enabled: Bool) {
        leftButtonEnabled = enabled
        
        leftButtonLabel.textColor = leftTintColor
        leftButtonContainerView.tintColor = leftTintColor
    }
    
    func setRightButton(enabled: Bool) {
        rightButtonEnabled = enabled
        
        rightButtonLabel.textColor = rightTintColor
        rightButtonContainerView.tintColor = rightTintColor
    }
    
    private func calculateDestination(side: Side, show: Bool) -> (margin: CGFloat, alpha: CGFloat) {
        let xMargin: CGFloat
        let alpha: CGFloat
        switch (side, show) {
        case (.right, true):
            xMargin = originalRightButtonContainerViewMargin
            alpha = 1.0
        case (.right, false):
            xMargin = -originalRightButtonContainerViewWidth
            alpha = 0.0
        case (.left, true):
            xMargin = originalLeftButtonContainerViewMargin
            alpha = 1.0
        case (.left, false):
            xMargin = -originalLeftButtonContainerViewWidth
            alpha = 0.0
        }
        
        return (xMargin, alpha)
    }
    
    private func move(view: UIView, animated: Bool, constraint: NSLayoutConstraint, value: CGFloat, alpha: CGFloat) {
        let performTransition = {
            constraint.constant = value
            view.alpha = alpha
            view.superview?.layoutIfNeeded()
        }
        
        switch animated {
        case true:
            UIView.animate(withDuration: settings.buttonSlideAnimationDuration, animations: {
                performTransition()
            })
        case false:
            performTransition()
        }
    }
    
    private func apply(settings: MessagesViewSettings) {
        messageEditorTextView.applySettings(settings: settings)
        
        backgroundColor = settings.inputToolbarBackgroundColor
        
        topSeparatorLineView.backgroundColor = settings.textInputFieldTopSeparatorLineColor
        topSeparatorLineView.alpha = settings.textInputFieldTopSeparatorLineAlpha
        topSeparatorLineViewHeightConstraint.constant = settings.textInputFieldTopSeparatorLineHeight
        
        leftButtonLabel.text = settings.leftButtonText
        leftButtonLabel.textColor = leftTintColor
        leftButtonContainerView.tintColor = leftTintColor
        leftButtonContainerView.backgroundColor = settings.leftButtonBackgroundColor
        leftButtonContainerView.image = settings.leftButtonBackgroundImage?.withRenderingMode(.alwaysTemplate)
        leftButtonContainerView.layer.cornerRadius = settings.leftButtonCornerRadius
        
        rightButtonLabel.text = settings.rightButtonText
        rightButtonLabel.textColor = rightTintColor
        rightButtonContainerView.tintColor = rightTintColor
        rightButtonContainerView.backgroundColor = settings.rightButtonBackgroundColor
        rightButtonContainerView.image = settings.rightButtonBackgroundImage?.withRenderingMode(.alwaysTemplate)
        rightButtonContainerView.layer.cornerRadius = settings.rightButtonCornerRadius
    }
}

extension MessagesToolbarContentView : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
}

