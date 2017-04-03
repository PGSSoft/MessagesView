//
//  MessageEditorTextView.swift
//  kilio
//
//  Created by Damian Kanak on 29.06.2016.
//  Copyright © 2016 PGS Software. All rights reserved.
//

import UIKit

class MessageEditorTextView: UITextView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupTextView()
    }
    
    func setupTextView() {
        self.backgroundColor = UIColor.yellow
    }
    
    func applySettings(settings: MessagesViewSettings) {
        self.textColor = settings.textInputFieldTextColor
        self.backgroundColor = settings.textInputFieldBackgroundColor
        self.layer.cornerRadius = settings.textInputFieldCornerRadius
    }

}
