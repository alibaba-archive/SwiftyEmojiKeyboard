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
    
    func emojiBottomBarDidSelectSendButton(bottomBar: EmojiBottomBar)
}

class EmojiBottomBar: UIView {

    weak var delegate: EmojiBottomBarDelegate?
    let tabArray = ["recent", "default"]
    var buttonArray = [UIButton]()
    var localizaStrings = [String: String]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    init(localizaStrings: [String: String]) {
        super.init(frame: CGRect.zero)
        self.localizaStrings = localizaStrings
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
            let title = self.localizaStrings[tabTitle]
            let button = UIButton(frame: CGRect.zero)
            button.titleLabel?.text = title
            button.setTitle(title, forState: .Normal)
            button.setTitleColor(UIColor.blackColor(), forState: .Normal)
            button.titleLabel?.font = UIFont.systemFontOfSize(13)
            button.addTarget(self, action: #selector(buttonTouchUpinside), forControlEvents: .TouchUpInside)
            button.setBackgroundImage(EmojiKeyboardView.bgColor.colorToImage(), forState: .Selected)
            return button
        }
        
        for i in 0..<buttonArray.count {
            let button = buttonArray[i]
            button.frame = CGRect(x: 80 * i, y: 0, width: 80, height: 35)
            button.tag = 8888 + i
            addSubview(button)
        }
        buttonArray[1].selected = true
        
        let sendButton = UIButton(frame: CGRect(x: 0, y: 0, width: 80, height: 35))
        sendButton.backgroundColor = UIColor.blueColor()
        sendButton.setTitle(self.localizaStrings["send"], forState: .Normal)
        sendButton.titleLabel?.font = UIFont.systemFontOfSize(13)
        sendButton.backgroundColor = UIColor(red: 3/255.0, green: 169/255.0, blue: 244/255.0, alpha: 1)
        sendButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        addSubview(sendButton)
        sendButton.addTarget(self, action: #selector(sendButtonTouchUpinside), forControlEvents: .TouchUpInside)
        addbuttonContraint(sendButton)
    }
    
    func addbuttonContraint(button: UIButton) {
        button.translatesAutoresizingMaskIntoConstraints = false
        let rightConstraint = NSLayoutConstraint(item: button, attribute: .Right, relatedBy: .Equal, toItem: self, attribute: .Right, multiplier: 1, constant: 0)
        let topConstraint = NSLayoutConstraint(item: button, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1, constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: button, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1, constant: 0)
        let heightConstraint = NSLayoutConstraint(item: button, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 35)
        let widthConstraint = NSLayoutConstraint(item: button, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 60)
        
        self.addConstraints([rightConstraint, bottomConstraint, topConstraint])
        button.addConstraints([heightConstraint, widthConstraint])
    }
    
    func buttonTouchUpinside(sender: UIButton) {
        buttonArray.forEach { $0.selected = false }
        sender.selected = true
        if let delegate = delegate {
            delegate.emojiBottomBar(self, didSelectAtIndex: sender.tag - 8888)
        }
    }
    
    func sendButtonTouchUpinside() {
        if let delegate = delegate {
            delegate.emojiBottomBarDidSelectSendButton(self)
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

