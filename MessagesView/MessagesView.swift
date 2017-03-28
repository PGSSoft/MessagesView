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

    @IBOutlet weak var messagesCollectionView: UICollectionView!
    @IBOutlet weak var messagesInputToolbar: MessagesInputToolbar!
    

    fileprivate let messageMargin : CGFloat = 60.0
    fileprivate let defaultCellSize : CGSize = CGSize(width: 250.0, height: 100.0)

    @IBInspectable public var messageCellTextColor: UIColor = UIColor.black
    @IBInspectable public var messageCellBackgroundColor: UIColor = UIColor.black
    @IBInspectable public var collectionViewBackgroundColor: UIColor = UIColor.yellow
    @IBInspectable public var textInputFieldTextColor: UIColor = UIColor.yellow
    @IBInspectable public var textInputFieldBackgroundColor: UIColor = UIColor.yellow
    @IBInspectable public var textInputFieldFont: UIFont = UIFont.systemFont(ofSize: 10)
    
    @IBInspectable public var buttonSlideAnimationDuration: TimeInterval = 0.5
    
    @IBInspectable public var leftButtonText: String = "Left"
    @IBInspectable public var leftButtonShow: Bool = true
    @IBInspectable public var leftButtonShowAnimated: Bool = true
    @IBInspectable public var leftButtonTextColor: UIColor = UIColor.black
    @IBInspectable public var leftButtonBackgroundColor: UIColor = UIColor.gray
    @IBInspectable public var leftButtonBackgroundImage: UIImage?
    
    @IBInspectable public var rightButtonText: String = "Right"
    @IBInspectable public var rightButtonShow: Bool = true
    @IBInspectable public var rightButtonShowAnimated: Bool = true
    @IBInspectable public var rightButtonTextColor: UIColor = UIColor.black
    @IBInspectable public var rightButtonBackgroundColor: UIColor = UIColor.gray
    @IBInspectable public var rightButtonBackgroundImage: UIImage?
    
    public var delegate : MessagesViewDelegate?
    public var dataSource: MessagesViewDataSource?
    
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
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        readSettingsFromInpectables(settings: &settings)
        apply(settings: settings)
    }
    
    private func setup() {
        view = loadFromNib()
        addSubview(view)
        pinSubviewToEdges(subview: view)
        registerCellNib()

        let set = self.settings
        set.setLeftButtonAction {
            self.delegate?.didTapLeftButton()
        }
        set.setRightButtonAction {
            self.delegate?.didTapRightButton()
        }
        
        self.settings = set
        messagesInputToolbar.settings = settings
    }
    
    public func leftButton(show: Bool, animated: Bool) {
        messagesInputToolbar.leftButton(show: show, animated: animated)
    }
    
    public func rightButton(show: Bool, animated: Bool) {
        messagesInputToolbar.rightButton(show: show, animated: animated)
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
    
    private func readSettingsFromInpectables(settings: inout MessagesViewSettings) {
        settings.messageCellTextColor = self.messageCellTextColor
        settings.messageCellBackgroundColor = self.messageCellBackgroundColor
        settings.collectionViewBackgroundColor = self.collectionViewBackgroundColor
        settings.textInputFieldTextColor = self.textInputFieldTextColor
        settings.textInputFieldBackgroundColor = self.textInputFieldBackgroundColor
        
        settings.buttonSlideAnimationDuration = self.buttonSlideAnimationDuration
        
        settings.leftButtonText = self.leftButtonText
        settings.leftButtonShow = self.leftButtonShow
        settings.leftButtonShowAnimated = self.leftButtonShowAnimated
        settings.leftButtonTextColor = self.leftButtonTextColor
        settings.leftButtonBackgroundColor = self.leftButtonBackgroundColor
        settings.leftButtonBackgroundImage = self.leftButtonBackgroundImage
        
        settings.rightButtonText = self.rightButtonText
        settings.rightButtonShow = self.rightButtonShow
        settings.rightButtonShowAnimated = self.rightButtonShowAnimated
        settings.rightButtonTextColor = self.rightButtonTextColor
        settings.rightButtonBackgroundColor = self.rightButtonBackgroundColor
        settings.rightButtonBackgroundImage = self.rightButtonBackgroundImage
    }
    
    private func apply(settings: MessagesViewSettings) {
        leftButton(show: settings.leftButtonShow, animated: settings.leftButtonShowAnimated)
        rightButton(show: settings.rightButtonShow, animated: settings.rightButtonShowAnimated)
    }
}

extension MessagesView : UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource?.messages.count ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Key.messageCollectionViewCell, for: indexPath) as? MessageCollectionViewCell ?? MessageCollectionViewCell()
        if let message = dataSource?.messages[indexPath.row] {
            cell.message = message
            cell.addTails()
            cell.applySettings(settings: settings)
            cell.showTail(side: message.onRight ? .right : .left)
            cell.addMessageMargin(side: message.onRight ? .right : .left, margin: messageMargin)
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

extension MessagesView : UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("selected")
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard  let message = dataSource?.messages[indexPath.row].text,
        let cell = MessageCollectionViewCell.fromNib() else {
            return defaultCellSize
        }
        
        let maxWidth = collectionView.bounds.size.width - collectionView.contentInset.left - collectionView.contentInset.right
        let cellMargins = cell.layoutMargins.left + cell.layoutMargins.right
        let requiredWidth = maxWidth - cellMargins

        var size = cell.size(message: message, containerInsets: requiredWidth - messageMargin)
        size.width = requiredWidth
        return size
    }
}
