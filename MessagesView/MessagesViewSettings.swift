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
    var leftButtonActionName = ""
    var rightButtonActionName = ""
    
    var leftButtonHidesKeyboard  = false
    var rightButtonHidesKeyboard = false
    
    var textInputScrollsToRecentMessage = true
    var messageCollectionViewHeaderHeight = 100.0
    var messageCollectionViewFooterHeight = 100.0
    var messageCollectionViewHeaderBackgroundColor = UIColor.green
    var messageCollectionViewFooterBackgroundColor = UIColor.blue
    
    //MARK: IBInspectables from MessageView
    var messageCellTextColor: UIColor = UIColor.black
    var messageCellBackgroundColor: UIColor = UIColor.red
    var collectionViewBackgroundColor: UIColor = UIColor.yellow
    var textInputFieldTextColor: UIColor = UIColor.yellow
    var textInputFieldBackgroundColor: UIColor = UIColor.yellow
    var textInputFieldFont: UIFont = UIFont.systemFont(ofSize: 10)
    
    var buttonSlideAnimationDuration = TimeInterval(0.5)
    var inputToolbarBackgroundColor = UIColor.white
    
    var leftButtonText: String = "Left"
    var leftButtonShow: Bool = true
    var leftButtonShowAnimated: Bool = true
    var leftButtonTextColor: UIColor = UIColor.black
    var leftButtonBackgroundColor: UIColor = UIColor.gray
    var leftButtonBackgroundImage: UIImage?

    var rightButtonText: String = "Right"
    var rightButtonShow: Bool = true
    var rightButtonShowAnimated: Bool = true
    var rightButtonTextColor: UIColor = UIColor.black
    var rightButtonBackgroundColor: UIColor = UIColor.gray
    var rightButtonBackgroundImage: UIImage?
    
    // MARK: Presets
    var action : [String : (Void)->() ] = [:]
    var rightButtonAction : (Void)->() { return action[rightButtonActionName] ?? {} }
    var leftButtonAction : (Void)->() { return action[leftButtonActionName] ?? {}}
    
    struct Action {
        static let send = "SEND"
        static let sendFromMyself = "SEND_TO_MYSELF"
        static let addPicture = "ADD_PICTURE"
        static let printLeftDebug = "PRINT_LEFT_DEBUG"
        static let printRightDebug = "PRINT_RIGHT_DEBUG"
    }
    
    init() {
        action[Action.send] = { print("sending message") }
        action = [
            Action.send         : { print("sending message") },
            Action.sendFromMyself : { print("sending message from myself") },
            Action.addPicture   : { print("adding picture") },
            Action.printLeftDebug: { print("left action") },
            Action.printRightDebug: { print("right action") }
        ]
    }
    
    public func setLeftButtonAction(newAction: @escaping (Void)->()) {
        action[leftButtonActionName] = newAction
    }
    
    public func setRightButtonAction(newAction: @escaping (Void)->()) {
        action[rightButtonActionName] = newAction
    }
    
    public static func defaultMessageViewSettings() -> MessagesViewSettings {
        let settings = MessagesViewSettings()
        settings.leftButtonActionName = Action.printLeftDebug
        settings.rightButtonActionName = Action.send

        //settings.leftButtonHidesKeyboard = true
        settings.rightButtonHidesKeyboard = true
        settings.textInputScrollsToRecentMessage = true
        settings.messageCollectionViewHeaderHeight = 5
        settings.messageCollectionViewHeaderBackgroundColor = UIColor.clear
        settings.messageCollectionViewFooterHeight = 20
        settings.messageCollectionViewFooterBackgroundColor = UIColor.clear
        
        return settings
    }
    
    public static func testChatSettings() -> MessagesViewSettings {
        let settings = MessagesViewSettings()
        settings.leftButtonActionName = Action.sendFromMyself
        settings.rightButtonActionName = Action.send
        
        //settings.leftButtonHidesKeyboard = true
        settings.rightButtonHidesKeyboard = true
        settings.textInputScrollsToRecentMessage = true
        settings.messageCollectionViewHeaderHeight = 5
        settings.messageCollectionViewHeaderBackgroundColor = UIColor.clear
        settings.messageCollectionViewFooterHeight = 20
        settings.messageCollectionViewFooterBackgroundColor = UIColor.clear
        
        return settings
    }
}
