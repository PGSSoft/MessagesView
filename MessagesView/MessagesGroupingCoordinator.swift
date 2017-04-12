//
//  MessagesGroupingCoordinator.swift
//  MessagesView
//
//  Created by Damian Kanak on 11/04/17.
//  Copyright © 2017 pgs-dkanak. All rights reserved.
//

import Foundation

class MessagesGroupingCoordinator {
    public func selectBackgroundFor(index: Int, inMessages messages: [MessagesViewChatMessage], withBubble bubbbleImage: BubbleImage)->UIImage {
        var result = UIImage()
        let actualMessage = messages[index]
        var isPreviousMessageOnTheSameSide = false
        var isNextMessageOnTheSameSide = false
        
        if 0 <= index-1 {
            isPreviousMessageOnTheSameSide = messages[index-1].onRight == actualMessage.onRight
        }
        if index+1 < messages.count {
            isNextMessageOnTheSameSide = messages[index+1].onRight == actualMessage.onRight
        }
        
        switch (isPreviousMessageOnTheSameSide, isNextMessageOnTheSameSide) {
        case (false, false):
            result = bubbbleImage.whole
        case (false, true):
            result = bubbbleImage.top ?? bubbbleImage.whole
        case (true, false):
            result = bubbbleImage.bottom ?? bubbbleImage.whole
        case (true, true):
            result = bubbbleImage.middle ?? bubbbleImage.whole
        }

        return result
    }
}
