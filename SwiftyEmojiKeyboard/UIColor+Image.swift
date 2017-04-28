//
//  UIColor+Image.swift
//  SwiftyEmojiKeyboard
//
//  Created by draveness on 28/04/2017.
//  Copyright © 2017 HarriesChen. All rights reserved.
//

import Foundation

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

