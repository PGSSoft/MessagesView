//
//  MessagesInputToolbar.swift
//  kilio
//
//  Created by Damian Kanak on 29.06.2016.
//  Copyright © 2016 PGS Software. All rights reserved.
//

import UIKit

class MessagesInputToolbar: UIView {

    let toolbarContentView = MessagesToolbarContentView.fromNib()
    
    var leftButtonAction: ()->() {
        get {
            return toolbarContentView.leftButtonAction
        }
        set {
            toolbarContentView.leftButtonAction = newValue
        }
    }
    var rightButtonAction: ()->() {
        get {
            return toolbarContentView.rightButtonAction
        }
        set {
            toolbarContentView.rightButtonAction = newValue
        }
    }
    
    var inputText : String {
        get {
            return toolbarContentView.inputText
        }
        set {
            toolbarContentView.inputText = newValue
        }
    }
    
    var settings = MessagesViewSettings() {
        didSet {
            toolbarContentView.settings = self.settings
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        addSubview(toolbarContentView)
        toolbarContentView.frame = self.bounds
    }
    
    func rightButton(show: Bool, animated: Bool) {
        toolbarContentView.righButton(show: show, animated: animated)
    }
    
    func leftButton(show: Bool, animated: Bool) {
        toolbarContentView.leftButton(show: show, animated: animated)
    }
}
