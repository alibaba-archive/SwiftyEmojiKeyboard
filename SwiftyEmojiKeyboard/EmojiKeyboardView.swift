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
            let width: Int = Int(UIScreen.main.bounds.size.width)
            return width / 45
        }
    }
}

class EmojiCollectionViewLayout: UICollectionViewFlowLayout {
    
    override func prepare() {
        scrollDirection = .horizontal
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        
        let width: Int = Int(UIScreen.main.bounds.size.width)
        itemSize = CGSize(width: LayoutManager.width, height: 40)
        let count: Int = width / LayoutManager.width

        let offset = (width - LayoutManager.width * count) / 2
        
        sectionInset = UIEdgeInsetsMake(15, CGFloat(offset), 5, CGFloat(offset))
    }
}

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

public extension UITextView {
    
}

public protocol EmojiKeyboardViewDelegate: NSObjectProtocol {
    
    func emojiKeyboardView(_ emojiView: EmojiKeyboardView, didSelectEmoji emoji: String)
    
    func emojiKeyboatdViewDidSelectDelete(_ emojiView: EmojiKeyboardView)
    
    func emojiKeyboatdViewDidSelectSend(_ emojiView: EmojiKeyboardView)
}

public extension EmojiKeyboardViewDelegate {
    func emojiKeyboardView(_ emojiView: EmojiKeyboardView, didSelectEmoji emoji: String) { }
    
    func emojiKeyboatdViewDidSelectDelete(_ emojiView: EmojiKeyboardView) { }
    
    func emojiKeyboatdViewDidSelectSend(_ emojiView: EmojiKeyboardView) { }
}

open class EmojiKeyboardView: UIView {

    let cellIdentifer = "TBEmojiIdentifer"
    
    var localizaStrings = [
        "recent": "最近",
        "default": "默认",
        "send": "发送"
    ]
    
    open weak var delegate: EmojiKeyboardViewDelegate?
    
    var dataSource = [[[String: String]]]()
    
    static var bgColor: UIColor = UIColor(red: 231/255.0, green: 231/255.0, blue: 231/255.0, alpha: 1)
    
    public init(localizaStrings: [String: String]) {
        self.localizaStrings = localizaStrings
        super.init(frame: CGRect.zero)
        commonInit()
    }
    
    var currentTabIndex: Int = 1 {
        didSet {
            if currentTabIndex == 0 {
                dataSource[0] = RecentManager.instance.getEmojis()
            }
            collectionView.reloadData()
            configPageControl()
        }
    }
    
    open override func layoutSubviews() {
        collectionView.reloadData()
        configPageControl()
    }
    
    lazy var collectionView: UICollectionView = {
        
        let collection = UICollectionView(frame: CGRect.zero, collectionViewLayout: EmojiCollectionViewLayout())
        collection.isPagingEnabled = true
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
        self.backgroundColor = UIColor.red
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
        
        collectionView.register(EmojiCell.self, forCellWithReuseIdentifier: cellIdentifer)
        addSubview(collectionView)
        addCollectionViewConstraint(collectionView)
    }
    
    func pagecontrolInit() {
        addSubview(pagecontrol)
        addPageControlConstraint(pagecontrol)
        configPageControl()
    }
    
    func datasourceInit() {
        let filePath = Bundle(for: EmojiKeyboardView.self).path(forResource: "default", ofType: "plist")
        dataSource.append(RecentManager.instance.getEmojis())
        if let path = filePath {
            let defaultDict = NSDictionary(contentsOfFile: path)
            if let emoticons = defaultDict?.object(forKey: "emoticons") as? [[String: String]] {
                dataSource.append(emoticons)
            }
        }
    }
    
    func bottomBarInit() {
        let bottomBar = EmojiBottomBar(localizaStrings: localizaStrings)
        bottomBar.delegate = self
        addSubview(bottomBar)
        addBottomBarConstraint(bottomBar)
    }
}

extension EmojiKeyboardView {
    
    func caculateNumberofSectionForTab(_ tab: Int) -> Int {
        if dataSource[currentTabIndex].count % LayoutManager.pageCount == 0 {
            dataSource[currentTabIndex].count / LayoutManager.pageCount
        }
        return dataSource[currentTabIndex].count / LayoutManager.pageCount + 1
    }
    
    func dataSourceForPage(_ page: Int) -> [[String: String]] {
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
    
    func coverntIndexpathToIndex(_ indexPath: IndexPath) -> Int {
        let row = (indexPath as NSIndexPath).row % 3 + 1
        let col = (indexPath as NSIndexPath).row / 3 + 1
        return (row - 1) * LayoutManager.maxRowCount + col - 1
    }
}

extension EmojiKeyboardView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return caculateNumberofSectionForTab(currentTabIndex)
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (LayoutManager.maxRowCount * 3)
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: EmojiCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifer, for: indexPath) as! EmojiCell
        let sections = dataSourceForPage((indexPath as NSIndexPath).section)
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
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let sections = dataSourceForPage((indexPath as NSIndexPath).section)
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
    
    func emojiBottomBar(_ bottomBar: EmojiBottomBar, didSelectAtIndex index: Int) {
        currentTabIndex = index
    }
    
    func emojiBottomBarDidSelectSendButton(_ bottomBar: EmojiBottomBar) {
        delegate?.emojiKeyboatdViewDidSelectSend(self)
    }
}

extension EmojiKeyboardView {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let index: Int = Int(fabs(collectionView.contentOffset.x + 50) / scrollView.frame.size.width)
        pagecontrol.currentPage = index
    }
}

extension EmojiKeyboardView {
    func addBottomBarConstraint(_ bottomBar: EmojiBottomBar) {
        bottomBar.translatesAutoresizingMaskIntoConstraints = false
        let leftConstraint = NSLayoutConstraint(item: bottomBar, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: bottomBar, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
        let rightConstraint = NSLayoutConstraint(item: bottomBar, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0)
        let heightConstraint = NSLayoutConstraint(item: bottomBar, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 35)
        
        self.addConstraints([leftConstraint, rightConstraint, bottomConstraint])
        bottomBar.addConstraint(heightConstraint)
    }
    
    func addCollectionViewConstraint(_ collection: UICollectionView) {
        collection.translatesAutoresizingMaskIntoConstraints = false
        let leftConstraint = NSLayoutConstraint(item: collection, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0)
        let topConstraint = NSLayoutConstraint(item: collection, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)
        let rightConstraint = NSLayoutConstraint(item: collection, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0)
        let heightConstraint = NSLayoutConstraint(item: collection, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 161)
        
        self.addConstraints([leftConstraint, rightConstraint, topConstraint])
        collection.addConstraint(heightConstraint)
    }
    
    func addPageControlConstraint(_ pagecontroler: UIPageControl) {
        pagecontroler.translatesAutoresizingMaskIntoConstraints = false
        let leftConstraint = NSLayoutConstraint(item: pagecontroler, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0)
        let topConstraint = NSLayoutConstraint(item: pagecontroler, attribute: .top, relatedBy: .equal, toItem: collectionView, attribute: .bottom, multiplier: 1, constant: 0)
        let rightConstraint = NSLayoutConstraint(item: pagecontroler, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0)
        let heightConstraint = NSLayoutConstraint(item: pagecontroler, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20)
        
        self.addConstraints([leftConstraint, rightConstraint, topConstraint])
        pagecontroler.addConstraint(heightConstraint)
    }
}
