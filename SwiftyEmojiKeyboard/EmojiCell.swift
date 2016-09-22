//
//  EmojiCell.swift
//  SwiftyEmojiKeyboard
//
//  Created by ChenHao on 16/5/3.
//  Copyright © 2016年 HarriesChen. All rights reserved.
//

import UIKit

class EmojiCell: UICollectionViewCell {
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))

        return imageView
    }()
    
    func configWithEmoji(_ emoji: [String: String]) {
        let png = emoji["png"]
        let seps = png?.components(separatedBy: ".")
        imageView.image = UIImage(named: seps![0], in: Bundle(for: EmojiCell.self), compatibleWith: nil)
        contentView.addSubview(imageView)
        imageView.center = contentView.center
    }
    
    func configWithDelete() {
        imageView.image = UIImage(named: "emoji_delete", in: Bundle(for: EmojiCell.self), compatibleWith: nil)
        contentView.addSubview(imageView)
        imageView.center = contentView.center
    }
    
    func configwithEmpty() {
        imageView.image = nil
    }
}
