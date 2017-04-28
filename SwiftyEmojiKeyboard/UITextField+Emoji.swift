//
//  UITextField+Emoji.swift
//  SwiftyEmojiKeyboard
//
//  Created by draveness on 28/04/2017.
//  Copyright © 2017 HarriesChen. All rights reserved.
//

import Foundation

public extension UITextField {
    func switchToEmojiKeyboard(_ keyboard: EmojiKeyboardView) {
        self.inputView = keyboard
        self.reloadInputViews()
    }
    
    func switchToDefaultKeyboard() {
        self.inputView = nil
        self.reloadInputViews()
    }
}

