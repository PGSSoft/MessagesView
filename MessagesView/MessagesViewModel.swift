//
//  MessagesViewModel.swift
//  kilio
//
//  Created by Damian Kanak on 19.10.2016.
//  Copyright © 2016 PGS Software. All rights reserved.
//

import Foundation



//
//public class MessagesViewModel : MessageSender {
//
//    var delegate : MessagesViewDelegate
//    var messages : [MessagesViewChatMessage] = []
//    var chat : MessagesViewChat
//    
//    public init(dataSource: MessagesViewDataSource, delegate: MessagesViewDelegate) {
//        self.delegate = delegate
//        self.chat = dataSource.chat
//        messages = chat.messages //TODO: stored as a copy, it is worth consideration whether to access messages directly in delegate
//    }
//    
//    func send(message: MessagesViewChatMessage) {
//        #if DEBUG
//            print(#function)
//        #endif
//        delegate.send(message: message)
//    }
//}
