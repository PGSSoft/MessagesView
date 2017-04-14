//
//  ViewController.swift
//  Demo
//
//  Created by Damian Kanak on 03/04/17.
//  Copyright © 2017 pgs-dkanak. All rights reserved.
//

import UIKit
import MessagesView

class ViewController: UIViewController {

    @IBOutlet weak var messagesView: MessagesView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        messagesView.delegate = self
        messagesView.dataSource = self

        addCustomMessageBubbles()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        messagesView.scrollToLastMessage(animated: false)
    }
    
    func addCustomMessageBubbles() {
        let leftBubbleBackgroundImage = UIImage(named: "bubble_left") ?? UIImage()
        
        let wholeCropRect = CGRect(origin: CGPoint(x: 0,y: 0), size: leftBubbleBackgroundImage.size)
        let wholeResizeInsets = UIEdgeInsets(top: 10, left: 42, bottom: 28, right: 42)
        let wholeSlice = ImageSlice(cropRect: wholeCropRect, resizeInsets: wholeResizeInsets)
        
        let topSliceCropRect = CGRect(x: 0, y: 0, width: 375, height: 74)
        let topSliceResizeInsets = UIEdgeInsets(top: 10, left: 42, bottom: 0, right: 42)
        let topSliceSpacing = UIEdgeInsets(top: 6, left: 0, bottom: 1, right: 0)
        let topSlice = ImageSlice(cropRect: topSliceCropRect, resizeInsets: topSliceResizeInsets, spacing: topSliceSpacing)
        
        let middleSliceCropRect = CGRect(x: 0, y: 10, width: 375, height: 20)
        let middleSliceResizeInsets = UIEdgeInsets(top: 0, left: 42, bottom: 0, right: 42)
        let middleSliceSpacing = UIEdgeInsets(top: 1, left: 0, bottom: 1, right: 0)
        let middleSlice = ImageSlice(cropRect: middleSliceCropRect, resizeInsets: middleSliceResizeInsets, spacing: middleSliceSpacing)
        
        let bottomSliceCropRect = CGRect(x: 0, y: 20, width: 375, height: 112)
        let bottomSliceResizeInsets = UIEdgeInsets(top: 0, left: 42, bottom: 28, right: 42)
        let bottomSliceSpacing = UIEdgeInsets(top: 1, left: 0, bottom: 6, right: 0)
        let bottomSlice = ImageSlice(cropRect: bottomSliceCropRect, resizeInsets: bottomSliceResizeInsets, spacing: bottomSliceSpacing)
        
        let leftBubbleSettings = MessagesViewBubbleSettings(image: leftBubbleBackgroundImage,
                                                            whole: wholeSlice,
                                                            top: topSlice,
                                                            middle: middleSlice,
                                                            bottom: bottomSlice)
        leftBubbleSettings.textMargin.left = 24
        
        let rightBubbleBackgroundImage = UIImage(named: "bubble_right") ?? UIImage()
        let rightBubbleSettings = MessagesViewBubbleSettings(image: rightBubbleBackgroundImage,
                                                             whole: wholeSlice,
                                                             top: topSlice,
                                                             middle: middleSlice,
                                                             bottom: bottomSlice)
        rightBubbleSettings.textMargin.right = 20
        rightBubbleSettings.textMargin.left = -10
        
        messagesView.setBubbleImageWith(leftSettings: leftBubbleSettings, rightSettings: rightBubbleSettings)
    }
}

extension ViewController: MessagesViewDelegate {
    func didTapLeftButton() {

    }
    
    func didTapRightButton() {
        let text = messagesView.inputText
        TestData.exampleMessageText.append(text)
        messagesView.refresh(scrollToLastMessage: true)
    }
}

extension ViewController: MessagesViewDataSource {
    struct Peer: MessagesViewPeer {
        var id: String
    }
    
    struct Message: MessagesViewChatMessage {
        var text: String
        var sender: MessagesViewPeer
        var onRight: Bool
    }

    var peers: [MessagesViewPeer] {
        return TestData.peerNames.map{ Peer(id: $0) }
    }
    
    var messages: [MessagesViewChatMessage] {
        return TestData.exampleMessageText.enumerated().map { (index, element) in
            let peer = self.peers[index % peers.count]
            return Message(text: element, sender: peer, onRight: index != 0)
        }
    }
}

