//
//  EmojiBottomBar.swift
//  SwiftyEmojiKeyboard
//
//  Created by ChenHao on 16/4/29.
//  Copyright © 2016年 HarriesChen. All rights reserved.
//

import UIKit

protocol EmojiBottomBarDelegate: NSObjectProtocol {
    
    func emojiBottomBar(_ bottomBar: EmojiBottomBar, didSelectAtIndex index: Int)
    
    func emojiBottomBarDidSelectSendButton(_ bottomBar: EmojiBottomBar)
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
        self.backgroundColor = UIColor.white
        initButton()
    }
    
    func initButton() {
        buttonArray = tabArray.map { (tabTitle) -> UIButton in
            let title = self.localizaStrings[tabTitle]
            let button = UIButton(frame: CGRect.zero)
            button.titleLabel?.text = title
            button.setTitle(title, for: UIControlState())
            button.setTitleColor(UIColor.black, for: UIControlState())
            button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
            button.addTarget(self, action: #selector(buttonTouchUpinside), for: .touchUpInside)
            button.setBackgroundImage(EmojiKeyboardView.bgColor.colorToImage(), for: .selected)
            return button
        }
        
        for i in 0..<buttonArray.count {
            let button = buttonArray[i]
            button.frame = CGRect(x: 80 * i, y: 0, width: 80, height: 35)
            button.tag = 8888 + i
            addSubview(button)
        }
        buttonArray[1].isSelected = true
        
        let sendButton = UIButton(frame: CGRect(x: 0, y: 0, width: 80, height: 35))
        sendButton.backgroundColor = UIColor.blue
        sendButton.setTitle(self.localizaStrings["send"], for: UIControlState())
        sendButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        sendButton.backgroundColor = UIColor(red: 3/255.0, green: 169/255.0, blue: 244/255.0, alpha: 1)
        sendButton.setTitleColor(UIColor.white, for: UIControlState())
        addSubview(sendButton)
        sendButton.addTarget(self, action: #selector(sendButtonTouchUpinside), for: .touchUpInside)
        addbuttonContraint(sendButton)
    }
    
    func addbuttonContraint(_ button: UIButton) {
        button.translatesAutoresizingMaskIntoConstraints = false
        let rightConstraint = NSLayoutConstraint(item: button, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0)
        let topConstraint = NSLayoutConstraint(item: button, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: button, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
        let heightConstraint = NSLayoutConstraint(item: button, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 35)
        let widthConstraint = NSLayoutConstraint(item: button, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 60)
        
        self.addConstraints([rightConstraint, bottomConstraint, topConstraint])
        button.addConstraints([heightConstraint, widthConstraint])
    }
    
    func buttonTouchUpinside(_ sender: UIButton) {
        buttonArray.forEach { $0.isSelected = false }
        sender.isSelected = true
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
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(self.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}

