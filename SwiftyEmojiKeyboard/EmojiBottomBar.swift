//
//  EmojiBottomBar.swift
//  SwiftyEmojiKeyboard
//
//  Created by ChenHao on 16/4/29.
//  Copyright © 2016年 HarriesChen. All rights reserved.
//

import UIKit

protocol EmojiBottomBarDelegate: NSObjectProtocol {
    
    func emojiBottomBar(bottomBar: EmojiBottomBar, didSelectAtIndex index: Int)
}

class EmojiBottomBar: UIView {

    weak var delegate: EmojiBottomBarDelegate?
    let tabArray = ["最近", "默认"]
    var buttonArray = [UIButton]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    init() {
        super.init(frame: CGRect.zero)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func commonInit() {
        self.backgroundColor = UIColor.whiteColor()
        
        initButton()
    }
    
    func initButton() {
        
        buttonArray = tabArray.map { (tabTitle) -> UIButton in
            let button = UIButton(frame: CGRect.zero)
            button.titleLabel?.text = tabTitle
            button.setTitle(tabTitle, forState: .Normal)
            button.setTitleColor(UIColor.blackColor(), forState: .Normal)
            button.titleLabel?.font = UIFont.systemFontOfSize(13)
            button.addTarget(self, action: #selector(buttonTouchUpinside), forControlEvents: .TouchUpInside)
            button.setBackgroundImage(EmojiKeyboardView.bgColor.colorToImage(), forState: .Selected)
            return button
        }
        
        for i in 0..<buttonArray.count {
            let button = buttonArray[i]
            button.frame = CGRect(x: 100 * i, y: 0, width: 100, height: 35)
            button.tag = 8888 + i
            addSubview(button)
        }
        buttonArray[0].selected = true
    }
    
    func buttonTouchUpinside(sender: UIButton) {
        buttonArray.forEach { $0.selected = false }
        sender.selected = true
        if let delegate = delegate {
            delegate.emojiBottomBar(self, didSelectAtIndex: sender.tag - 8888)
        }
    }
}

extension UIColor {
    
    func colorToImage() -> UIImage {
        let rect = CGRectMake(0, 0, 1, 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(context, self.CGColor)
        CGContextFillRect(context, rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

