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
    
    func insert(_ emoji: [String: String]) {
        let userDefault = UserDefaults.standard
        var recentEmojis = [[String: String]]()
        if let recents = userDefault.object(forKey: "recentsEmoji") as? [[String: String]] {
            recentEmojis = recents
        }
        
        if let index = (recentEmojis.index { $0["chs"] == emoji["chs"] }) {
            recentEmojis.remove(at: index)
        }
        recentEmojis.append(emoji)
        userDefault.set(recentEmojis, forKey: "recentsEmoji")
        userDefault.synchronize()
    }
    
    func getEmojis() -> [[String: String]] {
        let userDefault = UserDefaults.standard
        if let recents = userDefault.object(forKey: "recentsEmoji") as? [[String: String]] {
            return recents.reversed()
        }
        return []
    }
}
