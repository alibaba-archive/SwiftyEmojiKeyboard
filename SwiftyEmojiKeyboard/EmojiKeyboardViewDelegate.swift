//
//  EmojiKeyboardViewDelegate.swift
//  SwiftyEmojiKeyboard
//
//  Created by draveness on 28/04/2017.
//  Copyright © 2017 HarriesChen. All rights reserved.
//

import Foundation

public protocol EmojiKeyboardViewDelegate: NSObjectProtocol {
    func emojiKeyboardView(_ emojiView: EmojiKeyboardView, didSelectEmoji emoji: String)
    
    func emojiKeyboatdViewDidSelectDelete(_ emojiView: EmojiKeyboardView)
    
    func emojiKeyboatdViewDidSelectSend(_ emojiView: EmojiKeyboardView)
}

// MARK: - EmojiKeyboardViewDelegate
public extension EmojiKeyboardViewDelegate {
    func emojiKeyboardView(_ emojiView: EmojiKeyboardView, didSelectEmoji emoji: String) { }
    
    func emojiKeyboatdViewDidSelectDelete(_ emojiView: EmojiKeyboardView) { }
    
    func emojiKeyboatdViewDidSelectSend(_ emojiView: EmojiKeyboardView) { }
}
