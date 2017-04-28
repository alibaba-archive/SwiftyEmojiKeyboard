//
//  EmojiCollectionViewLayout.swift
//  SwiftyEmojiKeyboard
//
//  Created by draveness on 28/04/2017.
//  Copyright © 2017 HarriesChen. All rights reserved.
//

import Foundation

class LayoutManager {
    static var width: Int = 45
    static var pageCount: Int {
        get {
            return maxRowCount * 3 - 1
        }
    }
    
    static var maxRowCount: Int {
        get {
            let width: Int = Int(UIScreen.main.bounds.size.width)
            return width / 45
        }
    }
}

class EmojiCollectionViewLayout: UICollectionViewFlowLayout {
    
    override func prepare() {
        scrollDirection = .horizontal
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        
        let width: Int = Int(UIScreen.main.bounds.size.width)
        itemSize = CGSize(width: LayoutManager.width, height: 40)
        let count: Int = width / LayoutManager.width
        
        let offset = (width - LayoutManager.width * count) / 2
        
        sectionInset = UIEdgeInsetsMake(15, CGFloat(offset), 5, CGFloat(offset))
    }
}
