//
//  MessagesView.swift
//  kilio
//
//  Created by pgs-dkanak on 10/03/17.
//  Copyright © 2017 PGS Software. All rights reserved.
//

import UIKit

public protocol MessagesViewDelegate {
    func didTapLeftButton()
    func didTapRightButton()
}

public protocol MessagesViewDataSource {
    var messages : [MessagesViewChatMessage] {get}
    var peers : [MessagesViewPeer] {get}
}

public protocol MessagesViewChatMessage {
    var text : String {get}
    var sender: MessagesViewPeer {get}
    var onRight : Bool {get}
}

public protocol MessagesViewPeer {
    var id : String {get}
}

@IBDesignable
public class MessagesView: UIView {

    @IBOutlet weak var messagesCollectionView: MessagesCollectionView!
    @IBOutlet weak var messagesInputToolbar: MessagesInputToolbar!
    
    @IBOutlet weak var messageInputToolbarBottomConstraint: NSLayoutConstraint!
    
    private var toolBarBottomConstraintWithoutKeyboard: CGFloat = 0
    
    fileprivate let messageMargin : CGFloat = 60.0
    fileprivate let defaultCellSize : CGSize = CGSize(width: 250.0, height: 100.0)
    
    //MARK:- Public properties

    @IBInspectable public var leftMessageCellTextColor: UIColor = .black
    @IBInspectable public var leftMessageCellBackgroundColor: UIColor = .antiflashWhite
    @IBInspectable public var rightMessageCellTextColor: UIColor = .antiflashWhite
    @IBInspectable public var rightMessageCellBackgroundColor: UIColor = .pumpkin
    
    @IBInspectable public var collectionViewBackgroundColor: UIColor = .white
    
    @IBInspectable public var textInputFieldTextColor: UIColor = .black
    @IBInspectable public var textInputFieldBackgroundColor: UIColor = .clear
    @IBInspectable public var textInputFieldTextPlaceholderText: String = "Write your message here"
    @IBInspectable public var textInputFieldCornerRadius: CGFloat = 0.0
    @IBInspectable public var textInputFieldFont: UIFont = UIFont.systemFont(ofSize: 10)
    
    @IBInspectable public var textInputFieldTopSeparatorLineHeight: CGFloat = 1.0
    @IBInspectable public var textInputFieldTopSeparatorLineColor: UIColor = .pumpkin
    @IBInspectable public var textInputFieldTopSeparatorLineAlpha: CGFloat = 0.3
    
    @IBInspectable public var inputToolbarBackgroundColor: UIColor = UIColor.white
    
    @IBInspectable public var leftButtonText: String = "Left"
    @IBInspectable public var leftButtonShow: Bool = false
    @IBInspectable public var leftButtonShowAnimated: Bool = false
    @IBInspectable public var leftButtonTextColor: UIColor = .black
    @IBInspectable public var leftButtonDisabledColor: UIColor = .lightGray
    @IBInspectable public var leftButtonBackgroundColor: UIColor = .clear
    @IBInspectable public var leftButtonBackgroundImage: UIImage?
    @IBInspectable public var leftButtonCornerRadius: CGFloat = 0.0
    
    @IBInspectable public var rightButtonText: String = "Right"
    @IBInspectable public var rightButtonShow: Bool = true
    @IBInspectable public var rightButtonShowAnimated: Bool = true
    @IBInspectable public var rightButtonTextColor: UIColor = .pumpkin
    @IBInspectable public var rightButtonDisabledColor: UIColor = .lightGray
    @IBInspectable public var rightButtonBackgroundColor: UIColor = .clear
    @IBInspectable public var rightButtonBackgroundImage: UIImage?
    @IBInspectable public var rightButtonCornerRadius: CGFloat = 0.0
    
    public var buttonSlideAnimationDuration: TimeInterval = 0.5
    
    public var delegate : MessagesViewDelegate?
    public var dataSource: MessagesViewDataSource?
    
    //MARK:-
    
    var bubbleImageLeft: BubbleImage?
    var bubbleImageRight: BubbleImage?
    
    public func setBubbleImageWith(leftSettings: MessagesViewBubbleSettings, rightSettings: MessagesViewBubbleSettings) {
        bubbleImageLeft = BubbleImage(settings: leftSettings)
        bubbleImageLeft?.textMargin = leftSettings.textMargin
        bubbleImageRight = BubbleImage(settings: rightSettings)
        bubbleImageRight?.textMargin = rightSettings.textMargin
    }
    
    public var inputText: String {
        return messagesInputToolbar.messageText
    }
    
    var view: UIView!
    public var settings = MessagesViewSettings.testChatSettings() {
        didSet {
            messagesInputToolbar.settings = settings
        }
    }
    
    struct Key {
        static let messageCollectionViewCell = "MessageCollectionViewCell"
        static let messagesCollectionViewHeader = "MessagesCollectionViewHeader"
        static let messagesCollectionViewFooter = "MessagesCollectionViewFooter"
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK:- Public methods
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        readSettingsFromInpectables(settings: &settings)
        apply(settings: settings)
    }
    
    public override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        readSettingsFromInpectables(settings: &settings)
        apply(settings: settings)
    }
    
    public func refresh(scrollToLastMessage: Bool) {
        DispatchQueue.main.async {
            self.messagesCollectionView.reloadData()
            
            if scrollToLastMessage {
                self.scrollToLastMessage(animated: true)
            }
        }
    }
    
    public func scrollToLastMessage(animated: Bool) {
        guard !self.messagesCollectionView.isDragging, self.messagesCollectionView.numberOfItems(inSection: 0) > 0 else {
            return
        }
        
        self.messagesCollectionView.scrollToItem(at: IndexPath(row: self.messagesCollectionView.numberOfItems(inSection: 0) - 1, section: 0), at: .top, animated: animated)
    }
    
    public func leftButton(show: Bool, animated: Bool) {
        messagesInputToolbar.leftButton(show: show, animated: animated)
    }
    
    public func rightButton(show: Bool, animated: Bool) {
        messagesInputToolbar.rightButton(show: show, animated: animated)
    }
    
    public func setLeftButton(enabled: Bool) {
        messagesInputToolbar.toolbarContentView.setLeftButton(enabled: enabled)
    }
    
    public func setRightButton(enabled: Bool) {
        messagesInputToolbar.toolbarContentView.setRightButton(enabled: enabled)
    }
    
    //MARK:-
    
    private func setup() {
        view = loadFromNib()
        addSubview(view)
        pinSubviewToEdges(subview: view)
        registerCellNib()
        
        settings.setLeftButtonAction {
            self.delegate?.didTapLeftButton()
        }
        settings.setRightButtonAction {
            self.delegate?.didTapRightButton()
        }
        
        messagesInputToolbar.settings = settings
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
    }
    
    @objc private func keyboardWillShow(notification: Notification) {
        
        guard settings.shouldAdjustToKeyboard,
            let userInfo = notification.userInfo,
            let keyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
            let animationDuration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue else {
            return
        }
        
        toolBarBottomConstraintWithoutKeyboard = messageInputToolbarBottomConstraint.constant
        
        let toolbarFrameInWindow = convert(messagesInputToolbar.frame, to: nil)
        
        let keyboardOverlap = toolbarFrameInWindow.origin.y - keyboardFrame.origin.y
        
        guard keyboardOverlap > 0 else {
            return
        }
        
        let verticalAdjusttment = keyboardOverlap + toolbarFrameInWindow.size.height
        
        messageInputToolbarBottomConstraint.constant = toolBarBottomConstraintWithoutKeyboard + verticalAdjusttment
        
        UIView.animate(withDuration: animationDuration) {
            let contentOffset = self.messagesCollectionView.contentOffset
            
            self.messagesCollectionView.contentOffset = CGPoint(x: contentOffset.x, y: contentOffset.y + verticalAdjusttment)
            self.layoutIfNeeded()
        }
    }
    
    @objc private func keyboardWillHide(notification: Notification) {
        
        guard settings.shouldAdjustToKeyboard,
            let animationDuration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue else {
            return
        }
        
        messageInputToolbarBottomConstraint.constant = toolBarBottomConstraintWithoutKeyboard
        
        UIView.animate(withDuration: animationDuration) {
            self.layoutIfNeeded()
        }
    }
    
    private func pinSubviewToEdges(subview: UIView) {
        subview.translatesAutoresizingMaskIntoConstraints = false
        
        subview.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        subview.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        subview.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        subview.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    private func loadFromNib() -> UIView {
        let bundle = Bundle(for: MessagesView.classForCoder())
        guard let view = bundle.loadNibNamed("MessagesView", owner: self, options: [:])?.first as? UIView else {
            assertionFailure("No nib for MessagesView")
            return UIView()
        }
        return view
    }
    
    func registerCellNib() {
        let nib = UINib(nibName: Key.messageCollectionViewCell, bundle: Bundle(for: self.classForCoder))
        messagesCollectionView.register(nib, forCellWithReuseIdentifier: Key.messageCollectionViewCell)
        messagesCollectionView.register(UICollectionReusableView.classForCoder(), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: Key.messagesCollectionViewHeader)
        messagesCollectionView.register(UICollectionReusableView.classForCoder(), forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: Key.messagesCollectionViewFooter)
    }
    

    public func refresh() {
        DispatchQueue.main.async {
            self.messagesCollectionView.reloadData()
        }
    }
    
    func selectBackgroundAndSpacingFor(index: Int, inMessages messages: [MessagesViewChatMessage], withBubble bubbbleImage: BubbleImage) -> (image: UIImage, spacing: UIEdgeInsets) {
        var image = UIImage()
        var spacing = UIEdgeInsets()
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
            image = bubbbleImage.whole
            spacing = bubbbleImage.wholeSlice.spacing
        case (false, true):
            image = bubbbleImage.top ?? bubbbleImage.whole
            spacing = bubbbleImage.topSlice?.spacing ?? defaultCellSpacing
        case (true, false):
            image = bubbbleImage.bottom ?? bubbbleImage.whole
            spacing = bubbbleImage.bottomSlice?.spacing ?? defaultCellSpacing
        case (true, true):
            image = bubbbleImage.middle ?? bubbbleImage.whole
            spacing = bubbbleImage.middleSlice?.spacing ?? defaultCellSpacing
        }
        
        return (image: image, spacing: spacing)
    }
    
    private func readSettingsFromInpectables(settings: inout MessagesViewSettings) {
        settings.leftMessageCellTextColor = self.leftMessageCellTextColor
        settings.leftMessageCellBackgroundColor = self.leftMessageCellBackgroundColor
        settings.rightMessageCellTextColor = self.rightMessageCellTextColor
        settings.rightMessageCellBackgroundColor = self.rightMessageCellBackgroundColor
        
        settings.collectionViewBackgroundColor = self.collectionViewBackgroundColor
        
        settings.textInputFieldTextColor = self.textInputFieldTextColor
        settings.textInputFieldBackgroundColor = self.textInputFieldBackgroundColor
        
        settings.textInputFieldTopSeparatorLineHeight = self.textInputFieldTopSeparatorLineHeight
        settings.textInputFieldTopSeparatorLineAlpha = self.textInputFieldTopSeparatorLineAlpha
        settings.textInputFieldTopSeparatorLineColor = self.textInputFieldTopSeparatorLineColor
        settings.textInputFieldTextPlaceholderText = self.textInputFieldTextPlaceholderText
        
        settings.buttonSlideAnimationDuration = self.buttonSlideAnimationDuration
        settings.inputToolbarBackgroundColor = self.inputToolbarBackgroundColor
        settings.textInputFieldCornerRadius = self.textInputFieldCornerRadius
        
        settings.leftButtonText = self.leftButtonText
        settings.leftButtonShow = self.leftButtonShow
        settings.leftButtonShowAnimated = self.leftButtonShowAnimated
        settings.leftButtonTextColor = self.leftButtonTextColor
        settings.leftButtonDisabledColor = self.leftButtonDisabledColor
        settings.leftButtonBackgroundColor = self.leftButtonBackgroundColor
        settings.leftButtonBackgroundImage = self.leftButtonBackgroundImage
        settings.leftButtonCornerRadius = self.leftButtonCornerRadius
        
        settings.rightButtonText = self.rightButtonText
        settings.rightButtonShow = self.rightButtonShow
        settings.rightButtonShowAnimated = self.rightButtonShowAnimated
        settings.rightButtonTextColor = self.rightButtonTextColor
        settings.rightButtonDisabledColor = self.rightButtonDisabledColor
        settings.rightButtonBackgroundColor = self.rightButtonBackgroundColor
        settings.rightButtonBackgroundImage = self.rightButtonBackgroundImage
        settings.rightButtonCornerRadius = self.rightButtonCornerRadius
    }
    
    private func apply(settings: MessagesViewSettings) {
        messagesInputToolbar.settings = settings
        messagesCollectionView.apply(settings: settings)
        leftButton(show: settings.leftButtonShow, animated: settings.leftButtonShowAnimated)
        rightButton(show: settings.rightButtonShow, animated: settings.rightButtonShowAnimated)
    }
}

extension MessagesView: UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource?.messages.count ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Key.messageCollectionViewCell, for: indexPath) as? MessageCollectionViewCell ?? MessageCollectionViewCell()
        if let messages = dataSource?.messages {
            let message = messages[indexPath.row]
            cell.message = message
            cell.addTails()
            cell.showTail(side: message.onRight ? .right : .left)
            let bubbleImage = message.onRight ? bubbleImageRight : bubbleImageLeft
            if let image = bubbleImage {
                let slice = self.selectBackgroundAndSpacingFor(index: indexPath.row, inMessages: messages, withBubble: image)
                cell.messageBackgroundView.image = slice.image
                cell.adjustSpacing(spacing: slice.spacing)
            }
            cell.addMessageMargin(side: message.onRight ? .right : .left, margin: messageMargin, bubbleMargin: bubbleImage?.textMargin)
            cell.applySettings(settings: settings)
        }
        cell.setNeedsLayout()
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
            fatalError("Unexpected element kind")
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.contentSize.width, height: CGFloat(settings.messageCollectionViewHeaderHeight))
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.contentSize.width, height: CGFloat(settings.messageCollectionViewFooterHeight))
    }
}

extension MessagesView: UICollectionViewDelegateFlowLayout {

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        guard let message = dataSource?.messages[indexPath.row].text, let cell = MessageCollectionViewCell.fromNib() else {
            return defaultCellSize
        }
        
        let maxWidth = collectionView.bounds.size.width - collectionView.contentInset.left - collectionView.contentInset.right
        let cellMargins = cell.layoutMargins.left + cell.layoutMargins.right
        let requiredWidth = maxWidth - cellMargins

        let bubbleImage = message.onRight ? bubbleImageRight : bubbleImageLeft
        var size = cell.size(message: message.text, containerInsets: requiredWidth - messageMargin - (bubbleImage?.horizontalTextMargins ?? 0))
        size.width = requiredWidth
        return size
    }
}
