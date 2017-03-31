//
//  MessagesToolbarContentView.swift
//  kilio
//
//  Created by Damian Kanak on 29.06.2016.
//  Copyright © 2016 PGS Software. All rights reserved.
//

import UIKit

class MessagesToolbarContentView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
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
    
    @IBAction func didPressRightButton(_ sender: AnyObject) {
        settings.rightButtonAction()
        if settings.rightButtonHidesKeyboard {
            messageEditorTextView.resignFirstResponder()
        }
    }
    
    @IBAction func didPressLeftButton(_ sender: AnyObject) {
        settings.leftButtonAction()
        if settings.leftButtonHidesKeyboard {
            messageEditorTextView.resignFirstResponder()
        }
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
    
    private func move( view: UIView, animated: Bool, constraint: NSLayoutConstraint, value: CGFloat, alpha: CGFloat) {
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
    
    func apply(settings: MessagesViewSettings) {
        messageEditorTextView.applySettings(settings: settings)
        
        backgroundColor = settings.inputToolbarBackgroundColor
        
        leftButtonLabel.text = settings.leftButtonText
        leftButtonLabel.textColor = settings.leftButtonTextColor
        leftButtonContainerView.backgroundColor = settings.leftButtonBackgroundColor
        leftButtonContainerView.image = settings.leftButtonBackgroundImage
        
        rightButtonLabel.text = settings.rightButtonText
        rightButtonLabel.textColor = settings.rightButtonTextColor
        rightButtonContainerView.backgroundColor = settings.rightButtonBackgroundColor
        rightButtonContainerView.image = settings.rightButtonBackgroundImage
    }
}

extension MessagesToolbarContentView : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        #if DEBUG
            print(#function)
        #endif
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        #if DEBUG
            print(#function)
        #endif
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        #if DEBUG
            print(#function)
        #endif
        return true
    }
}

