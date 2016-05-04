//
//  EmojiRecent.swift
//  SwiftyEmojiKeyboard
//
//  Created by ChenHao on 16/5/4.
//  Copyright © 2016年 HarriesChen. All rights reserved.
//  <harrieschen@gmail.com>

import Foundation

class RecentManager {
    static var instance = RecentManager()
    
    func insert(emoji: [String: String]) {
        let userDefault = NSUserDefaults.standardUserDefaults()
        var recentEmojis = [[String: String]]()
        if let recents = userDefault.objectForKey("recentsEmoji") as? [[String: String]] {
            recentEmojis = recents
        }
        
        if let index = (recentEmojis.indexOf { $0["chs"] == emoji["chs"] }) {
            recentEmojis.removeAtIndex(index)
        }
        recentEmojis.append(emoji)
        userDefault.setObject(recentEmojis, forKey: "recentsEmoji")
        userDefault.synchronize()
    }
    
    func getEmojis() -> [[String: String]] {
        let userDefault = NSUserDefaults.standardUserDefaults()
        if let recents = userDefault.objectForKey("recentsEmoji") as? [[String: String]] {
            return recents.reverse()
        }
        return []
    }
}