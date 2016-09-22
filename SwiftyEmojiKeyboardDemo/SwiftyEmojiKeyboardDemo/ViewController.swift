//
//  ViewController.swift
//  SwiftyEmojiKeyboardDemo
//
//  Created by ChenHao on 16/4/28.
//  Copyright © 2016年 HarriesChen. All rights reserved.
//

import UIKit
import SwiftyEmojiKeyboard

class ViewController: UIViewController {
    @IBOutlet weak var textfiled: UITextField!

    lazy var emoji: EmojiKeyboardView = {
        let emoji = EmojiKeyboardView(localizaStrings: ["send":"Send","default":"Default","recent":"Recent"])
        return emoji
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func tapRagular(sender: Any) {
        
        textfiled.resignFirstResponder()
        textfiled.switchToDefaultKeyboard()
        textfiled.becomeFirstResponder()
    }
    
    @IBOutlet weak var regular: UIButton!
    @IBAction func emojiButtonPressed(sender: Any) {
        
        emoji.delegate = self
        
        textfiled.resignFirstResponder()
        textfiled.switchToEmojiKeyboard(emoji)
        textfiled.becomeFirstResponder()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: EmojiKeyboardViewDelegate {
    
    func emojiKeyboatdViewDidSelectDelete(emojiView: EmojiKeyboardView) {
        
    }
    
    func emojiKeyboardView(emojiView: EmojiKeyboardView, didSelectEmoji emoji: String) {
        textfiled.text = textfiled.text?.appending(emoji)
    }
    
    func emojiKeyboatdViewDidSelectSend(emojiView: EmojiKeyboardView) {
        
    }
}

