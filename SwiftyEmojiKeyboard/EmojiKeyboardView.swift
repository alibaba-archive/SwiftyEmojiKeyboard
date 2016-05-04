//
//  SwiftyEmojiKeyboard.swift
//  SwiftyEmojiKeyboard
//
//  Created by ChenHao on 16/4/28.
//  Copyright © 2016年 HarriesChen. All rights reserved.
//

import UIKit


class LayoutManager {
    
    static var width: Int = 45
    static var pageCount: Int {
        get {
           return maxRowCount * 3 - 1
        }
    }
    
    static var maxRowCount: Int {
        get {
            let width: Int = Int(UIScreen.mainScreen().bounds.size.width)
            return width / 45
        }
    }
}

class EmojiCollectionViewLayout: UICollectionViewFlowLayout {
    
    override func prepareLayout() {
        scrollDirection = .Horizontal
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        
        let width: Int = Int(UIScreen.mainScreen().bounds.size.width)
        itemSize = CGSize(width: LayoutManager.width, height: 40)
        let count: Int = width / LayoutManager.width

        let offset = (width - LayoutManager.width * count) / 2
        
        sectionInset = UIEdgeInsetsMake(15, CGFloat(offset), 5, CGFloat(offset))
    }
}

public extension UITextField {
    
    func switchToEmojiKeyboard(keyboard: EmojiKeyboardView) {
        self.inputView = keyboard
        self.reloadInputViews()
    }
    
    func switchToDefaultKeyboard() {
        self.inputView = nil
        self.reloadInputViews()
    }
}

public extension UITextView {
    
}

public protocol EmojiKeyboardViewDelegate: NSObjectProtocol {
    
    func emojiKeyboardView(emojiView: EmojiKeyboardView, didSelectEmoji emoji: String)
    
    func emojiKeyboatdViewDidSelectDelete(emojiView: EmojiKeyboardView)
}

public class EmojiKeyboardView: UIView {

    let cellIdentifer = "TBEmojiIdentifer"
    
    public weak var delegate: EmojiKeyboardViewDelegate?
    
    var dataSource = [[[String: String]]]()
    
    static var bgColor: UIColor = UIColor(red: 231/255.0, green: 231/255.0, blue: 231/255.0, alpha: 1)
    
    var currentTabIndex: Int = 1 {
        didSet {
            if currentTabIndex == 0 {
                dataSource[0] = RecentManager.instance.getEmojis()
            }
            collectionView.reloadData()
            configPageControl()
        }
    }
    
    public override func layoutSubviews() {
        collectionView.reloadData()
        configPageControl()
    }
    
    lazy var collectionView: UICollectionView = {
        
        let collection = UICollectionView(frame: CGRect.zero, collectionViewLayout: EmojiCollectionViewLayout())
        collection.pagingEnabled = true
        collection.showsHorizontalScrollIndicator = false
        collection.backgroundColor = EmojiKeyboardView.bgColor
        return collection
    }()
    
    lazy var pagecontrol: UIPageControl = {
        let pagecontrol = UIPageControl()
        pagecontrol.backgroundColor = EmojiKeyboardView.bgColor
        return pagecontrol
    }()
    
    public init() {
        super.init(frame: CGRect.zero)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func commonInit() {
        self.backgroundColor = UIColor.redColor()
        self.frame = CGRect(x: 10, y: 10, width: 10, height: 216)
        
        datasourceInit()
        collectionInit()
        pagecontrolInit()
        bottomBarInit()
    }
    
    func configPageControl() {
        pagecontrol.numberOfPages = caculateNumberofSectionForTab(currentTabIndex)
    }
    
    func collectionInit() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.registerClass(EmojiCell.self, forCellWithReuseIdentifier: cellIdentifer)
        addSubview(collectionView)
        addCollectionViewConstraint(collectionView)
    }
    
    func pagecontrolInit() {
        addSubview(pagecontrol)
        addPageControlConstraint(pagecontrol)
        configPageControl()
    }
    
    func datasourceInit() {
        let filePath = NSBundle(forClass: EmojiKeyboardView.self).pathForResource("default", ofType: "plist")
        dataSource.append(RecentManager.instance.getEmojis())
        if let path = filePath {
            let defaultDict = NSDictionary(contentsOfFile: path)
            if let emoticons = defaultDict?.objectForKey("emoticons") as? [[String: String]] {
                dataSource.append(emoticons)
            }
        }
    }
    
    func bottomBarInit() {
        let bottomBar = EmojiBottomBar()
        bottomBar.delegate = self
        addSubview(bottomBar)
        addBottomBarConstraint(bottomBar)
    }
}

extension EmojiKeyboardView {
    
    func caculateNumberofSectionForTab(tab: Int) -> Int {
        if dataSource[currentTabIndex].count % LayoutManager.pageCount == 0 {
            dataSource[currentTabIndex].count / LayoutManager.pageCount
        }
        return dataSource[currentTabIndex].count / LayoutManager.pageCount + 1
    }
    
    func dataSourceForPage(page: Int) -> [[String: String]] {
        let pageSize = LayoutManager.pageCount
        let startIndex = pageSize * page
        if dataSource[currentTabIndex].count == 0 {
            return []
        }
        if startIndex + pageSize < dataSource[currentTabIndex].count {
            return Array(dataSource[self.currentTabIndex][startIndex..<startIndex + pageSize])
        } else {
            return Array(dataSource[self.currentTabIndex][startIndex..<dataSource[currentTabIndex].count - 1])
        }
    }
    
    func coverntIndexpathToIndex(indexPath: NSIndexPath) -> Int {
        let row = indexPath.row % 3 + 1
        let col = indexPath.row / 3 + 1
        return (row - 1) * LayoutManager.maxRowCount + col - 1
    }
}

extension EmojiKeyboardView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    public func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return caculateNumberofSectionForTab(currentTabIndex)
    }
    
    public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (LayoutManager.maxRowCount * 3)
    }
    
    public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: EmojiCell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifer, forIndexPath: indexPath) as! EmojiCell
        let sections = dataSourceForPage(indexPath.section)
        let index = coverntIndexpathToIndex(indexPath)
        if index < sections.count {
            cell.configWithEmoji(sections[index])
        } else if index == LayoutManager.pageCount {
            cell.configWithDelete()
        } else {
            cell.configwithEmpty()
        }
        return cell
    }
    
    public func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let sections = dataSourceForPage(indexPath.section)
        let index = coverntIndexpathToIndex(indexPath)
        if index < sections.count {
            RecentManager.instance.insert(sections[index])
            if let delegate = delegate {
                delegate.emojiKeyboardView(self, didSelectEmoji: sections[index]["chs"]!)
            }
        } else if index == LayoutManager.pageCount  {
            if let delegate = delegate {
                delegate.emojiKeyboatdViewDidSelectDelete(self)
            }
        }
    }
}

extension EmojiKeyboardView: EmojiBottomBarDelegate {
    
    func emojiBottomBar(bottomBar: EmojiBottomBar, didSelectAtIndex index: Int) {
        currentTabIndex = index
    }
}

extension EmojiKeyboardView {
    public func scrollViewDidScroll(scrollView: UIScrollView) {
        let index: Int = Int(fabs(collectionView.contentOffset.x + 50) / scrollView.frame.size.width)
        pagecontrol.currentPage = index
    }
}

extension EmojiKeyboardView {
    func addBottomBarConstraint(bottomBar: EmojiBottomBar) {
        bottomBar.translatesAutoresizingMaskIntoConstraints = false
        let leftConstraint = NSLayoutConstraint(item: bottomBar, attribute: .Left, relatedBy: .Equal, toItem: self, attribute: .Left, multiplier: 1, constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: bottomBar, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1, constant: 0)
        let rightConstraint = NSLayoutConstraint(item: bottomBar, attribute: .Right, relatedBy: .Equal, toItem: self, attribute: .Right, multiplier: 1, constant: 0)
        let heightConstraint = NSLayoutConstraint(item: bottomBar, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 35)
        
        self.addConstraints([leftConstraint, rightConstraint, bottomConstraint])
        bottomBar.addConstraint(heightConstraint)
    }
    
    func addCollectionViewConstraint(collection: UICollectionView) {
        collection.translatesAutoresizingMaskIntoConstraints = false
        let leftConstraint = NSLayoutConstraint(item: collection, attribute: .Left, relatedBy: .Equal, toItem: self, attribute: .Left, multiplier: 1, constant: 0)
        let topConstraint = NSLayoutConstraint(item: collection, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1, constant: 0)
        let rightConstraint = NSLayoutConstraint(item: collection, attribute: .Right, relatedBy: .Equal, toItem: self, attribute: .Right, multiplier: 1, constant: 0)
        let heightConstraint = NSLayoutConstraint(item: collection, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 161)
        
        self.addConstraints([leftConstraint, rightConstraint, topConstraint])
        collection.addConstraint(heightConstraint)
    }
    
    func addPageControlConstraint(pagecontroler: UIPageControl) {
        pagecontroler.translatesAutoresizingMaskIntoConstraints = false
        let leftConstraint = NSLayoutConstraint(item: pagecontroler, attribute: .Left, relatedBy: .Equal, toItem: self, attribute: .Left, multiplier: 1, constant: 0)
        let topConstraint = NSLayoutConstraint(item: pagecontroler, attribute: .Top, relatedBy: .Equal, toItem: collectionView, attribute: .Bottom, multiplier: 1, constant: 0)
        let rightConstraint = NSLayoutConstraint(item: pagecontroler, attribute: .Right, relatedBy: .Equal, toItem: self, attribute: .Right, multiplier: 1, constant: 0)
        let heightConstraint = NSLayoutConstraint(item: pagecontroler, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 20)
        
        self.addConstraints([leftConstraint, rightConstraint, topConstraint])
        pagecontroler.addConstraint(heightConstraint)
    }
}