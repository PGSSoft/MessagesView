//
//  MessagesCollectionView.swift
//  kilio
//
//  Created by Malgorzata Gocal on 22.02.2017.
//  Copyright © 2017 PGS Software. All rights reserved.
//

import UIKit

class MessagesCollectionView: UICollectionView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    func apply(settings: MessagesViewSettings) {
        self.backgroundColor = settings.collectionViewBackgroundColor
    }
}
