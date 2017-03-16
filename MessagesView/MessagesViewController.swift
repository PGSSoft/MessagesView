//
//  MessagesViewController.swift
//  kilio
//
//  Created by Damian Kanak on 14.06.2016.
//  Copyright © 2016 PGS Software. All rights reserved.
//

import UIKit
//import RxSwift

protocol MessageSender {
    func send(message: MessagesViewChatMessage)
}
/*
public class MessagesViewController: UIViewController {
    
//    public var viewModel : MessagesViewModel?
    var keyboardShown = false
    var originalFrame = CGRect()
    
    public var settings = MessagesViewSettings.defaultMessageViewSettings()
    
    var longPressedCell: UICollectionViewCell?

    @IBOutlet weak var messagesCollectionView: UICollectionView!
    @IBOutlet weak var messagesInputToolbar: MessagesInputToolbar!
    
    struct Key {
        static let messageCollectionViewCell = "MessageCollectionViewCell"
        static let messagesCollectionViewHeader = "MessagesCollectionViewHeader"
        static let messagesCollectionViewFooter = "MessagesCollectionViewFooter"
    }
    
    static public func create() -> MessagesViewController {
        let vc = MessagesViewController(nibName: "MessagesViewController", bundle: Bundle(for: MessagesViewController.classForCoder()))
        return vc
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        registerCellNib()
        registerKeyboardNotifications()
        messagesInputToolbar.settings = self.settings
        
        self.settings.action[MessagesViewSettings.Action.send] = {
            self.sendMessage(text: self.messagesInputToolbar.messageText)
        }
        
        self.settings.action[MessagesViewSettings.Action.sendToMyself] = {
            self.sendMessagefromOtherPeer(text: self.messagesInputToolbar.messageText)
        }

        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(MessagesViewController.didLongPressCollectionView(_:)))
        messagesCollectionView.addGestureRecognizer(longPressRecognizer)
        messagesCollectionView.delegate = self
    }
    
    override public var canBecomeFirstResponder: Bool {
        return true
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        originalFrame = self.view.frame
    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        unregisterKeyboardNotifications()
    }
    
    func scrollToLastRecentMessageIfneeded() {
        if settings.textInputScrollsToRecentMessage {
            let keyboardOffset : CGFloat = keyboardShown ? 0 : 30
            let bottomOffset = CGPoint(x: 0, y: messagesCollectionView.contentSize.height  - messagesCollectionView.bounds.size.height + keyboardOffset)
            self.messagesCollectionView.setContentOffset(bottomOffset, animated: true)
        }
    }
    
    func registerCellNib() {
        let nib = UINib(nibName: Key.messageCollectionViewCell, bundle: Bundle(for: self.classForCoder))
        messagesCollectionView.register(nib, forCellWithReuseIdentifier: Key.messageCollectionViewCell)
        messagesCollectionView.register(UICollectionReusableView.classForCoder(), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: Key.messagesCollectionViewHeader)
        messagesCollectionView.register(UICollectionReusableView.classForCoder(), forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: Key.messagesCollectionViewFooter)
    }
    
    func send(text: String) {
        //delegate.send(text)
    }
    
    func sendMessagefromOtherPeer(text: String) {
        if let viewModel = self.viewModel {
            let newMessage = viewModel.delegate.create(peerId: "adsa", text: "pierwszy")
            viewModel.send(message: newMessage)
//            viewModel.send(message: <#T##MessagesViewChatMessage#>)
            
//            #if DEBUG
//                print("hosPeer: \(viewModel.hostPeer.id)")
//                print("otherPeer: \(otherPeer.id)")
//            #endif
//            if let otherPeer = viewModel.chat.peers.filter({ (peer: Peer) -> Bool in
//                return peer.id != viewModel.hostPeer.id
//            }).first {
//                let chatMessage = ChatMessage(sender: otherPeer, text: text)
//                viewModel.send(message: chatMessage)
//            }
        }
    }
 
    func sendMessage(text: String) {
        if let viewModel = self.viewModel {
            let newMessage = viewModel.delegate.create(peerId: "adsa", text: "pierwszy")
            viewModel.send(message: newMessage)
            //viewModel.send(message: <#T##MessagesViewChatMessage#>)
//            let chatMessage = MessagesViewChatMessage.create(sender: viewModel.hostPeer, text: text)
//            viewModel.send(message: chatMessage)
//            #if DEBUG
//                print("hosPeer: \(viewModel.hostPeer.id)")
//            #endif
        }
    }
}


//MARK: - Extension for showing/handling menu actions for collection view cells
extension MessagesViewController {
    func didLongPressCollectionView(_ gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state != .ended {
            return
        }
        
        let touchedPoint = gestureRecognizer.location(in: messagesCollectionView)
        
        guard let touchedCellIndexPath = messagesCollectionView.indexPathForItem(at: touchedPoint) else {
            #if DEBUG
                print("Couldn't find index path for a point: %@", touchedPoint)
            #endif
            return
        }
        
        guard let cell = messagesCollectionView.cellForItem(at: touchedCellIndexPath) else {
            return
        }
        longPressedCell = cell
        
        messagesCollectionView.becomeFirstResponder()
        let menu = UIMenuController.shared
        let saveMenuItem = UIMenuItem(title: "Save", action: #selector(save))
        menu.setTargetRect(CGRect(x: cell.frame.width/2.0, y: 10, width: 0, height: 0), in: cell.contentView)
        menu.menuItems = [saveMenuItem]
        menu.setMenuVisible(true, animated: true)
    }
    
    override public func copy(_ sender: Any?) {
        UIPasteboard.general.string = (longPressedCell as? MessageCollectionViewCell)?.message?.text
    }
    
    func save() {
        guard let messageToBeSaved = (longPressedCell as? MessageCollectionViewCell)?.message else {
            return
        }
//        viewModel?.save(message: messageToBeSaved)
    }
}

extension MessagesViewController : UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override public func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        
        if action == #selector(save) || action == #selector(copy(_:)) {
            return true
        }
        return false
    }
    
    public func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    }
}

extension MessagesViewController : UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.messages.count ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Key.messageCollectionViewCell, for: indexPath) as? MessageCollectionViewCell ?? MessageCollectionViewCell()
        if let message = viewModel?.messages[indexPath.row] {
            print("cell \(indexPath)")
            cell.message = message
            cell.addTails()
//            let isHostPeerSender = message.sender == viewModel?.hostPeer
//            let side : Side = isHostPeerSender ? .right : .left
//            cell.showTail(side: side)
        }
        return cell
    }
    
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
            
        case UICollectionElementKindSectionHeader:
            
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: Key.messagesCollectionViewHeader, for: indexPath)
            headerView.backgroundColor = settings.messageCollectionViewHeaderBackgroundColor
            return headerView
        
        case UICollectionElementKindSectionFooter:
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: Key.messagesCollectionViewFooter, for: indexPath)
            footerView.backgroundColor = settings.messageCollectionViewFooterBackgroundColor
            return footerView
            
        default:
            
            assert(false, "Unexpected element kind")
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.contentSize.width, height: CGFloat(settings.messageCollectionViewHeaderHeight))
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.contentSize.width, height: CGFloat(settings.messageCollectionViewFooterHeight))
    }
    
    func lastMessageIndexPath() -> IndexPath {
        return IndexPath(item: viewModel!.messages.count-1, section: 0)
    }
}

extension MessagesViewController : UICollectionViewDelegateFlowLayout   {
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let messageCell = cell as? MessageCollectionViewCell {
//            messageCell.drawTail(isHostPeerSender: messageCell.message?.sender == viewModel?.hostPeer)
//            let message = viewModel?.messages[indexPath.row]
//            messageCell.fitBubble(text: message?.text ?? "")
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        #if DEBUG
            print("selected item at \(indexPath)")
        #endif
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let message = viewModel?.messages[indexPath.row]
        return MessageCollectionViewCell.calculateCellSizeFor(text: message?.text ?? "")
    }
}

//MARK: Keyboard hiding

extension MessagesViewController {
    func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: (#selector(MessagesViewController.keyboardWillShow(notification:))), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: (#selector(MessagesViewController.keyboardWillHide(notification:))), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func unregisterKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardDidHide, object: nil)
    }
    
    @objc(keyboardWillShow:)
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.view.frame.origin.y = originalFrame.origin.y - keyboardSize.height
        }
        keyboardShown = true
        scrollToLastRecentMessageIfneeded()
    }
    
    @objc(keyboardWillHide:)
    func keyboardWillHide(notification: NSNotification) {
        if ((notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            self.view.frame.origin.y = originalFrame.origin.y
        }
        keyboardShown = false
        scrollToLastRecentMessageIfneeded()
    }
}
 
 */

