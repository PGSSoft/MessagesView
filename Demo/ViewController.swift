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
        // Do any additional setup after loading the view, typically from a nib.
        messagesView.delegate = self
        messagesView.dataSource = self
        
        addCustomMessageBubbles()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addCustomMessageBubbles() {
        let leftBubbleBackgroundImage = UIImage(named: "left_bubble_orange") ?? UIImage()
        
        let wholeCropRect = CGRect(origin: CGPoint(x: 0,y: 0), size: leftBubbleBackgroundImage.size)
        let wholeResizeInsets = UIEdgeInsets(top: 25, left: 30, bottom: 25, right: 30)
        let wholeSlice = ImageSlice(cropRect: wholeCropRect, resizeInsets: wholeResizeInsets)
        
        let topSliceCropRect = CGRect(x: 0, y: 0, width: 100, height: 30)
        let topSliceResizeInsets = UIEdgeInsets(top: 25, left: 30, bottom: 0, right: 30)
        let topSlice = ImageSlice(cropRect: topSliceCropRect, resizeInsets: topSliceResizeInsets)
        
        let middleSliceCropRect = CGRect(x: 0, y: 10, width: 100, height: 20)
        let middleSliceResizeInsets = UIEdgeInsets(top: 0, left: 25, bottom: 25, right: 25)
        let middleSlice = ImageSlice(cropRect: middleSliceCropRect, resizeInsets: middleSliceResizeInsets)
        
        let bottomSliceCropRect = CGRect(x: 0, y: 20, width: 100, height: 90)
        let bottomSliceResizeInsets = UIEdgeInsets(top: 0, left: 25, bottom: 25, right: 25)
        let bottomSlice = ImageSlice(cropRect: bottomSliceCropRect, resizeInsets: bottomSliceResizeInsets)
        
        let leftBubbleSettings = MessagesViewBubbleSettings(image: leftBubbleBackgroundImage,
                                                            whole: wholeSlice,
                                                            top: topSlice,
                                                            middle: middleSlice,
                                                            bottom: bottomSlice)
        leftBubbleSettings.textMargin.left = 20
        
        let rightBubbleBackgroundImage = UIImage(named: "right_bubble_orange") ?? UIImage()
        let rightBubbleSettings = MessagesViewBubbleSettings(image: rightBubbleBackgroundImage,
                                                             whole: wholeSlice,
                                                             top: topSlice,
                                                             middle: middleSlice,
                                                             bottom: bottomSlice)
        
        messagesView.setBubbleImageWith(leftSettings: leftBubbleSettings, rightSettings: rightBubbleSettings)
    }
}

extension ViewController: MessagesViewDelegate {
    func didTapLeftButton() {

    }
    
    func didTapRightButton() {
        let text = messagesView.inputText
        TestData.exampleMessageText.append(text)
        messagesView.refresh()
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
            return Message(text: element, sender: peer, onRight: index%2 == 0)
        }
    }
}

