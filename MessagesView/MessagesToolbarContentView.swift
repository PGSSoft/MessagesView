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
    
    @IBOutlet weak var messageEditorTextView: MessageEditorTextView!
    
    var settings = MessagesViewSettings() {
        didSet {
            apply(settings: settings)
        }
    }
    var messageText : String {
        return messageEditorTextView.text
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

extension MessagesToolbarContentView : CustomizableControl {
    func apply(settings: MessagesViewSettings) {
        messageEditorTextView.applySettings(settings: settings)
        
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
