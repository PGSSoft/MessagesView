//
//  MessagesInputToolbar.swift
//  kilio
//
//  Created by Damian Kanak on 29.06.2016.
//  Copyright © 2016 PGS Software. All rights reserved.
//

import UIKit

class MessagesInputToolbar: UIToolbar {

    let toolbarContentView = MessagesToolbarContentView.fromNib()
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    var messageText : String {
        return toolbarContentView.messageText
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
    
    override func resignFirstResponder() -> Bool {
        return toolbarContentView.resignFirstResponder()
    }
    
    func rightButton(show: Bool, animated: Bool) {
        toolbarContentView.righButton(show: show, animated: animated)
    }
    
    func leftButton(show: Bool, animated: Bool) {
        toolbarContentView.leftButton(show: show, animated: animated)
    }
}
