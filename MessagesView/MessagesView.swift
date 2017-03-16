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

public class MessagesView: UIView {

    @IBOutlet weak var messagesCollectionView: UICollectionView!
    @IBOutlet weak var messagesInputToolbar: MessagesInputToolbar!
    
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
}

extension MessagesView : UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource?.messages.count ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Key.messageCollectionViewCell, for: indexPath) as? MessageCollectionViewCell ?? MessageCollectionViewCell()
        if let message = dataSource?.messages[indexPath.row] {
            print("cell \(indexPath)")
            cell.message = message
            cell.addTails()
            cell.showTail(side: message.onRight ? .right : .left)
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
}

extension MessagesView : UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("selected")
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 250, height: 100) //TODO: calculate accurate size
    }
}
