//
//  MessageEditorTextView.swift
//  kilio
//
//  Created by Damian Kanak on 29.06.2016.
//  Copyright © 2016 PGS Software. All rights reserved.
//

import UIKit

class MessageEditorTextView: UITextField {

    func applySettings(settings: MessagesViewSettings) {
        
        textColor = settings.textInputFieldTextColor
        backgroundColor = settings.textInputFieldBackgroundColor
        tintColor = settings.textInputTintColor
        layer.cornerRadius = settings.textInputFieldCornerRadius
        placeholder = settings.textInputFieldTextPlaceholderText
        
        keyboardType = settings.keyboardType
        keyboardAppearance = settings.keyboardAppearance
        returnKeyType = settings.returnKeyType
        enablesReturnKeyAutomatically = settings.enablesReturnKeyAutomatically
    }

}
