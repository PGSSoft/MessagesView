//
//  MessagesViewSettings.swift
//  kilio
//
//  Created by Damian Kanak on 14.07.2016.
//  Copyright © 2016 PGS Software. All rights reserved.
//

import Foundation
import UIKit

public class MessagesViewSettings {
    public var leftButtonActionName = ""
    public var rightButtonActionName = ""
    
    public var leftButtonHidesKeyboard  = false
    public var rightButtonHidesKeyboard = false
    public var shouldAdjustToKeyboard = true
    public var shouldDoRightActionWithReturnKey = true
    
    public var keyboardType: UIKeyboardType = .default
    public var keyboardAppearance: UIKeyboardAppearance = .default
    public var returnKeyType: UIReturnKeyType = .done
    public var enablesReturnKeyAutomatically = false
    
    public var textInputScrollsToRecentMessage = true
    
    public var messageCollectionViewHeaderHeight = 5.0
    public var messageCollectionViewFooterHeight = 20.0
    public var messageCollectionViewHeaderBackgroundColor = UIColor.clear
    public var messageCollectionViewFooterBackgroundColor = UIColor.clear
    
    public var leftMessageCellTextColor: UIColor = .black
    public var leftMessageCellBackgroundColor: UIColor = .antiflashWhite
    public var rightMessageCellTextColor: UIColor = .antiflashWhite
    public var rightMessageCellBackgroundColor: UIColor = .pumpkin
    
    public var collectionViewBackgroundColor: UIColor = .white
    
    public var textInputFieldTextColor: UIColor = .black
    public var textInputFieldBackgroundColor: UIColor = .clear
    public var textInputTintColor: UIColor = .pumpkin
    public var textInputFieldTextPlaceholderText: String = "Write your message here"
    public var textInputFieldCornerRadius: CGFloat = 0.0
    public var textInputFieldFont: UIFont = .systemFont(ofSize: 10)
    
    public var textInputFieldTopSeparatorLineHeight: CGFloat = 1.0
    public var textInputFieldTopSeparatorLineColor: UIColor = .pumpkin
    public var textInputFieldTopSeparatorLineAlpha: CGFloat = 1.0
    
    public var inputToolbarBackgroundColor = UIColor.white
    
    public var leftButtonText: String = ""
    public var leftButtonShow: Bool = false
    public var leftButtonShowAnimated: Bool = false
    public var leftButtonTextColor: UIColor = .pumpkin
    public var leftButtonDisabledColor: UIColor = .antiflashWhite
    public var leftButtonBackgroundColor: UIColor = .clear
    public var leftButtonBackgroundImage: UIImage?
    public var leftButtonCornerRadius: CGFloat = 0.0

    public var rightButtonText: String = "Send"
    public var rightButtonShow: Bool = true
    public var rightButtonShowAnimated: Bool = true
    public var rightButtonTextColor: UIColor = .pumpkin
    public var rightButtonDisabledColor: UIColor = .antiflashWhite
    public var rightButtonBackgroundColor: UIColor = .clear
    public var rightButtonBackgroundImage: UIImage?
    public var rightButtonCornerRadius: CGFloat = 0.0
    
    public var buttonSlideAnimationDuration: TimeInterval = 0.5
    
    public var groupSeparationSpacing: CGFloat = 12
    public var groupInternalSpacing: CGFloat = 1
    public var minimalHorizontalSpacing: CGFloat = 80
    
    public static var defaultSettings: MessagesViewSettings {
        return MessagesViewSettings()
    }
}
