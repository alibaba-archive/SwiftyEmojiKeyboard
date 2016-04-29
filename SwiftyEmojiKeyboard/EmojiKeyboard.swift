//
//  SwiftyEmojiKeyboard.swift
//  SwiftyEmojiKeyboard
//
//  Created by ChenHao on 16/4/28.
//  Copyright © 2016年 HarriesChen. All rights reserved.
//

import UIKit

public extension UITextField {
    
    func switchToEmojiKeyboard(keyboard: EmojiKeyboard) {
        self.inputView = keyboard
        self.reloadInputViews()
    }
    
    func switchToDefaultKeyboard() {
        self.inputView = nil
        self.reloadInputViews()
    }
}

public extension UITextView {
    
}

public class EmojiKeyboard: UIView {

    var textInput: UIResponder?
    
    public init() {
        super.init(frame: CGRect.zero)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func commonInit() {
        self.backgroundColor = UIColor.redColor()
        self.frame = CGRect(x: 10, y: 10, width: 10, height: 216)
        
        let collectionView = EmojiCollectionView(frame: CGRect.zero)
        
        addSubview(collectionView)
        addCollectionViewConstraint(collectionView)
        
        let bottomBar = EmojiBottomBar()
        addSubview(bottomBar)
        addBottomBarConstraint(bottomBar)
        
    }
    
    func addBottomBarConstraint(bottomBar: EmojiBottomBar) {
        bottomBar.translatesAutoresizingMaskIntoConstraints = false
        let leftConstraint = NSLayoutConstraint(item: bottomBar, attribute: .Left, relatedBy: .Equal, toItem: self, attribute: .Left, multiplier: 1, constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: bottomBar, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1, constant: 0)
        let rightConstraint = NSLayoutConstraint(item: bottomBar, attribute: .Right, relatedBy: .Equal, toItem: self, attribute: .Right, multiplier: 1, constant: 0)
        let heightConstraint = NSLayoutConstraint(item: bottomBar, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 35)
        
        self.addConstraints([leftConstraint, rightConstraint, bottomConstraint])
        bottomBar.addConstraint(heightConstraint)
    }
    
    func addCollectionViewConstraint(collection: EmojiCollectionView) {
        collection.translatesAutoresizingMaskIntoConstraints = false
        let leftConstraint = NSLayoutConstraint(item: collection, attribute: .Left, relatedBy: .Equal, toItem: self, attribute: .Left, multiplier: 1, constant: 0)
        let topConstraint = NSLayoutConstraint(item: collection, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1, constant: 0)
        let rightConstraint = NSLayoutConstraint(item: collection, attribute: .Right, relatedBy: .Equal, toItem: self, attribute: .Right, multiplier: 1, constant: 0)
        let heightConstraint = NSLayoutConstraint(item: collection, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 180)
        
        self.addConstraints([leftConstraint, rightConstraint, topConstraint])
        collection.addConstraint(heightConstraint)
    }
    
}
