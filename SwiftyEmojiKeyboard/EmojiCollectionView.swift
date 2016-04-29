//
//  EmojiCollectionView.swift
//  SwiftyEmojiKeyboard
//
//  Created by ChenHao on 16/4/29.
//  Copyright © 2016年 HarriesChen. All rights reserved.
//

import UIKit

class EmojiCollectionView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func commonInit() {
        self.backgroundColor = UIColor.blueColor()
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
