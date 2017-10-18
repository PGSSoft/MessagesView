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

enum MessagePositionInGroup {
    case whole
    case top
    case middle
    case bottom
}

@IBDesignable
public class MessagesView: UIView {

    @IBOutlet weak var messagesCollectionView: MessagesCollectionView!
    @IBOutlet weak var messagesInputToolbar: MessagesInputToolbar!
    
    @IBOutlet weak var messageInputToolbarBottomConstraint: NSLayoutConstraint!
    
    private var toolBarBottomConstraintWithoutKeyboard: CGFloat = 0
    
    //MARK:- Public properties

    @IBInspectable public var leftMessageCellTextColor: UIColor = .black
    @IBInspectable public var leftMessageCellBackgroundColor: UIColor = .antiflashWhite
    @IBInspectable public var rightMessageCellTextColor: UIColor = .antiflashWhite
    @IBInspectable public var rightMessageCellBackgroundColor: UIColor = .pumpkin
    
    @IBInspectable public var collectionViewBackgroundColor: UIColor = .white
    
    @IBInspectable public var textInputFieldTextColor: UIColor = .black
    @IBInspectable public var textInputFieldBackgroundColor: UIColor = .clear
    @IBInspectable public var textInputTintColor: UIColor = .pumpkin
    @IBInspectable public var textInputFieldTextPlaceholderText: String = "Write your message here"
    @IBInspectable public var textInputFieldCornerRadius: CGFloat = 0.0
    @IBInspectable public var textInputFieldFont: UIFont = .systemFont(ofSize: 10)
    
    @IBInspectable public var textInputFieldTopSeparatorLineHeight: CGFloat = 1.0
    @IBInspectable public var textInputFieldTopSeparatorLineColor: UIColor = .pumpkin
    @IBInspectable public var textInputFieldTopSeparatorLineAlpha: CGFloat = 1.0
    
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
    
    public var isLastMessageAnimated = false
    
    //MARK:-
    
    var bubbleImageLeft: BubbleImage = BubbleImage(cornerRadius: 8)
    var bubbleImageRight: BubbleImage = BubbleImage(cornerRadius: 8).flipped
    
    public func setBubbleImagesWith(left: BubbleImage, right: BubbleImage? = nil) {
        
        bubbleImageLeft = left
        bubbleImageRight = right ?? left.flipped
    }
    
    public var inputText: String {
        get {
            return messagesInputToolbar.inputText
        }
        set {
            messagesInputToolbar.inputText = newValue
        }
    }
    
    var view: UIView!
    public var settings = MessagesViewSettings() {
        didSet {
            apply(settings: settings)
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
    
    public func refresh(scrollToLastMessage: Bool, animateLastMessage: Bool = false) {
        DispatchQueue.main.async {
            self.isLastMessageAnimated = animateLastMessage
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
        
        messagesInputToolbar.leftButtonAction = { [weak self] _ in
            self?.delegate?.didTapLeftButton()
        }
        messagesInputToolbar.rightButtonAction = { [weak self] _ in
            self?.delegate?.didTapRightButton()
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
    
    @IBAction func didTapCollectionViewArea(_ sender: Any) {
        _ = messagesInputToolbar.resignFirstResponder()
    }

    public func refresh() {
        DispatchQueue.main.async {
            self.messagesCollectionView.reloadData()
        }
    }
    
    fileprivate func messagePositionInGroup(for index: Int) -> MessagePositionInGroup {
        
        guard let messages = dataSource?.messages else {
            return .whole
        }
        
        var isPreviousMessageOnTheSameSide = false
        var isNextMessageOnTheSameSide = false
        
        if 0 <= index-1 {
            isPreviousMessageOnTheSameSide = messages[index-1].onRight == messages[index].onRight
        }
        
        if index+1 < messages.count {
            isNextMessageOnTheSameSide = messages[index+1].onRight == messages[index].onRight
        }
        
        switch (isPreviousMessageOnTheSameSide, isNextMessageOnTheSameSide) {
        case (false, false):
            return .whole
        case (false, true):
            return .top
        case (true, false):
            return .bottom
        case (true, true):
            return .middle
        }
    }
    
    private func readSettingsFromInpectables(settings: inout MessagesViewSettings) {
        
        settings.leftMessageCellTextColor = leftMessageCellTextColor
        settings.leftMessageCellBackgroundColor = leftMessageCellBackgroundColor
        settings.rightMessageCellTextColor = rightMessageCellTextColor
        settings.rightMessageCellBackgroundColor = rightMessageCellBackgroundColor
        
        settings.collectionViewBackgroundColor = collectionViewBackgroundColor
        
        settings.textInputFieldTextColor = textInputFieldTextColor
        settings.textInputFieldBackgroundColor = textInputFieldBackgroundColor
        settings.textInputTintColor = textInputTintColor
        settings.textInputFieldTextPlaceholderText = textInputFieldTextPlaceholderText
        settings.textInputFieldCornerRadius = textInputFieldCornerRadius
        settings.textInputFieldFont = textInputFieldFont
        
        settings.textInputFieldTopSeparatorLineHeight = textInputFieldTopSeparatorLineHeight
        settings.textInputFieldTopSeparatorLineColor = textInputFieldTopSeparatorLineColor
        settings.textInputFieldTopSeparatorLineAlpha = textInputFieldTopSeparatorLineAlpha
        
        settings.inputToolbarBackgroundColor = inputToolbarBackgroundColor
        
        settings.leftButtonText = leftButtonText
        settings.leftButtonShow = leftButtonShow
        settings.leftButtonShowAnimated = leftButtonShowAnimated
        settings.leftButtonTextColor = leftButtonTextColor
        settings.leftButtonDisabledColor = leftButtonDisabledColor
        settings.leftButtonBackgroundColor = leftButtonBackgroundColor
        settings.leftButtonBackgroundImage = leftButtonBackgroundImage
        settings.leftButtonCornerRadius = leftButtonCornerRadius
        
        settings.rightButtonText = rightButtonText
        settings.rightButtonShow = rightButtonShow
        settings.rightButtonShowAnimated = rightButtonShowAnimated
        settings.rightButtonTextColor = rightButtonTextColor
        settings.rightButtonDisabledColor = rightButtonDisabledColor
        settings.rightButtonBackgroundColor = rightButtonBackgroundColor
        settings.rightButtonBackgroundImage = rightButtonBackgroundImage
        settings.rightButtonCornerRadius = rightButtonCornerRadius
        
        settings.buttonSlideAnimationDuration = buttonSlideAnimationDuration
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
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Key.messageCollectionViewCell, for: indexPath) as? MessageCollectionViewCell,
            let messages = dataSource?.messages else {
                return UICollectionViewCell()
        }
        
        cell.message = messages[indexPath.row]
        
        let bubbleImage = messages[indexPath.row].onRight ? bubbleImageRight : bubbleImageLeft
        
        let messagePosition = messagePositionInGroup(for: indexPath.row)

        switch messagePosition {
        case .whole:
            cell.messageBackgroundView.image = bubbleImage.whole
            cell.bottomSpacing = settings.groupSeparationSpacing
        case .top:
            cell.messageBackgroundView.image = bubbleImage.top
            cell.bottomSpacing = settings.groupInternalSpacing
        case .middle:
            cell.messageBackgroundView.image = bubbleImage.middle
            cell.bottomSpacing = settings.groupInternalSpacing
        case .bottom:
            cell.messageBackgroundView.image = bubbleImage.bottom
            cell.bottomSpacing =  settings.groupSeparationSpacing
        }
        
        cell.positionInGroup = messagePosition
        cell.textInsets = bubbleImage.textInsets
        
        cell.applySettings(settings: settings)
        
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
        
        guard let message = dataSource?.messages[indexPath.row], let cell = MessageCollectionViewCell.fromNib() else {
            return .zero
        }
        
        let requiredWidth = collectionView.bounds.width - collectionView.contentInset.left - collectionView.contentInset.right
        
        let bubble = message.onRight ? bubbleImageRight : bubbleImageLeft
        let messagePosition = messagePositionInGroup(for: indexPath.row)

        var size = cell.size(message: message.text, width: requiredWidth, bubbleImage: bubble, minimalHorizontalSpacing: settings.minimalHorizontalSpacing, messagePositionInGroup: messagePosition)
        size.width = requiredWidth
        
        switch messagePosition {
            
        case .bottom, .whole:
            size.height += settings.groupSeparationSpacing
            
        case .top, .middle:
            size.height += settings.groupInternalSpacing
        }
        
        return size
    }
    
    func isLastMessage(indexPath: IndexPath)->Bool {
        let lastMessageIndex = (dataSource?.messages.count ?? 0) - 1
        return indexPath.row == lastMessageIndex
    }
    
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? MessageCollectionViewCell else {
            return
        }
        if isLastMessage(indexPath: indexPath) && isLastMessageAnimated {
            cell.slideIn()
        }
    }
}
