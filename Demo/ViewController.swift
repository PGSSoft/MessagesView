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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

