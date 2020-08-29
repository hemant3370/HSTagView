//
//  HSTagListView.swift
//
//  Created by Hemant Singh on 26/08/20.
//  Copyright © 2020 Hemant Singh. All rights reserved.
//

import UIKit

public class HSTagListView<T: HSIdentifialble> : UIView {
    
    var currentRow = 0
    var tags = [UIButton]()
    var containerView: UIView!
    
    public var contentOffset: UIEdgeInsets = UIEdgeInsets(top: 20.0, left: 10.0, bottom: 20.0, right: 10.0)
    public var tagHorizontalPadding: CGFloat = 8 // padding between tags horizontally
    public var tagVerticalPadding: CGFloat = 8 // padding between tags vertically
    public var tagCombinedMargin: CGFloat = 16 * 2 // margin of left and right combined, text in tags are by default centered.
    public var tagCornerRadius: CGFloat = 14.0
    
    public var onTagSelection: ((Int) -> Void)?
    
    public var color = UIColor.secondarySystemFill
    
    public var selectedColor = UIColor.darkGray
    
    public var buttonBorderColor = UIColor.clear
    
    public var textColor: UIColor = .label

    public var selectedTextColor = UIColor.white
    
    public var font = UIFont.systemFont(ofSize: 16)
    public var selectedFont = UIFont.systemFont(ofSize: 16, weight: .semibold)
    
    public var allowMultiples = true
    
    public var selectedItems = [Int : T]()
    
    public var selectedTags: [T] {
        return Array(selectedItems.values)
    }
    
    public var selectedIndexes: [Int] {
        return Array(selectedItems.keys)
    }
    
    public var allTags = [T]() {
        didSet {
            for tag in allTags {
                addTag(tag, selected: false)
            }
        }
    }
    
     public var isRequired = false
    
	override public init(frame:CGRect) {
		super.init(frame: frame)
		containerView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: frame.size.width, height: frame.size.height))
		self.addSubview(containerView)
	}
	
    override public func awakeFromNib() {
		containerView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: frame.size.width, height: frame.size.height))
		self.addSubview(containerView)
	}
	
	override public var intrinsicContentSize: CGSize {
		if self.tags.count > 0 {
			return self.frame.size
		} else {
			return CGSize(width: self.frame.width, height: 0)
		}
	}
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        var frame = self.frame
        frame.size.width = UIScreen.main.bounds.width - 48
        self.frame = frame
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        self.layoutTagsFromIndex(index: 0)
    }

    
    // MARK: -
    
    @objc func didTapButton(sender: HSButton) {
        guard let text = sender.identifier else { return }
        
        let tag: T? = allTags.filter { $0.identifier == text }.first ?? nil
        
        let index = sender.tag
        
        if let _ = selectedItems[index], let button = containerView.subviews.filter({ $0.tag == index && $0 is UIButton }).first as? UIButton {
            if allowMultiples || (!isRequired && selectedItems.count < tags.count) {
                selectedItems.removeValue(forKey: index)
                button.titleLabel?.font = font
                button.setTitleColor(textColor, for: .normal)
                button.backgroundColor = color
            }
        } else {
            if allowMultiples {
                if index < allTags.count {
                    selectedItems[index] = tag
                }
                
                sender.titleLabel?.font = selectedFont
                sender.setTitleColor(selectedTextColor, for: .normal)
                sender.backgroundColor = selectedColor
                
            } else {
                if let button = containerView.subviews.filter({ $0.tag == selectedItems.first?.key && $0 is UIButton }).first as? UIButton {
                    button.titleLabel?.font = font
                    button.setTitleColor(textColor, for: .normal)
                    button.backgroundColor = color
                }
                
                selectedItems.removeAll()
                
                if index < allTags.count {
                    selectedItems[index] = tag
                }
                
                sender.titleLabel?.font = selectedFont
                sender.setTitleColor(selectedTextColor, for: .normal)
                sender.backgroundColor = selectedColor
            }
        }
        
        onTagSelection?(sender.tag)
    }
    
    
    // MARK: -
    
    func addTag(_ aTag: T, selected: Bool) -> UIButton? {
        guard let name = aTag.identifier else { return nil }
        
        let button = HSButton()
        button.identifier = name
        button.titleLabel?.lineBreakMode = .byWordWrapping
        button.titleLabel?.font = selected ? selectedFont : font
        button.setTitle(name, for: .normal)
        button.setTitleColor(selected ? selectedTextColor : textColor, for: .normal)
        button.backgroundColor = selected ? selectedColor : color
        button.layer.borderColor = buttonBorderColor.cgColor
        button.layer.borderWidth = 1.0
        button.clipsToBounds = true
        button.sizeToFit()
        button.tag = 1000
        
        for (index, tag) in allTags.enumerated() {
            if let tagName = tag.identifier, tagName == name {
                button.tag = index
                break
            }
        }
        
        button.addTarget(self, action: #selector(didTapButton(sender:)), for: .touchUpInside)
        
        if selected {
            selectedItems[button.tag] = aTag
        }
        
        self.tags.append(button)
        
        //calculate frame
        var buttonWidth = button.frame.width + tagCombinedMargin
        var buttonHeight = button.frame.height
        
        if buttonWidth >= self.frame.width {
            buttonHeight = button.frame.height + 21
            buttonWidth = buttonWidth/2 + tagCombinedMargin
        }
        
        button.frame = CGRect(x: button.frame.origin.x, y: button.frame.origin.y, width: buttonWidth, height: buttonHeight)

        if self.tags.count == 0 {
            button.frame = CGRect(x: contentOffset.left, y: contentOffset.top, width: button.frame.width, height: button.frame.height)
            self.containerView.addSubview(button)
            
        } else {
            button.frame = self.generateFrameAtIndex(index: tags.count - 1)
            self.containerView.addSubview(button)
        }
        button.layer.cornerRadius = buttonHeight / 2
        self.invalidateIntrinsicContentSize()
        
        return button
    }
    
    
    private func isOutofBounds(newPoint:CGPoint, labelFrame:CGRect) {
        let bottomYLimit = newPoint.y + labelFrame.height
        if bottomYLimit > self.containerView.frame.height {
            self.containerView.frame = CGRect(x: self.containerView.frame.origin.x,
                                              y: self.containerView.frame.origin.y,
                                              width: self.frame.size.width,
                                              height: bottomYLimit)
        }
        self.frame = CGRect(x: self.frame.origin.x,
                            y: self.frame.origin.y,
                            width: self.frame.width,
                            height: self.containerView.frame.height)
    }
    
    func getPositionForIndex(index:Int) -> CGPoint {
        if index < 1 {
            return CGPoint(x: contentOffset.left, y: contentOffset.top)
        }
        let lastTagFrame = tags[index-1].frame
        let x = lastTagFrame.maxX + tagHorizontalPadding
        let y = lastTagFrame.minY
        return CGPoint(x: x, y: y)
    }
    
    func reset() {
        for tag in tags {
            tag.removeFromSuperview()
        }
        tags = []
        currentRow = 0
		
        self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.size.width, height: tagVerticalPadding)
        self.containerView.frame = CGRect(x: self.containerView.frame.origin.x, y: self.containerView.frame.origin.y, width: self.frame.size.width, height: tagVerticalPadding)
        
        self.invalidateIntrinsicContentSize()
    }
    
    
    private func layoutTagsFromIndex(index:Int, animated:Bool = false) {
        if tags.count == 0 {
            return
        }
        
        if animated {
            UIView.animate(withDuration: 0.3, animations: {
                for i in index...self.tags.count - 1 {
                    self.tags[i].frame = self.generateFrameAtIndex(index: i)
                }
            }, completion: { (_) in
                self.invalidateIntrinsicContentSize()
            })
        }
    }
    
    private func generateFrameAtIndex(index:Int) -> CGRect {
        var newPoint = self.getPositionForIndex(index: index)
        
        if self.frame.width > 0.0 && (newPoint.x + self.tags[index].frame.width) >= self.frame.width {
            let lastMaxY = tags.map({ $0.frame.maxY }).max() ?? 0
            newPoint = CGPoint(x: self.contentOffset.left, y: lastMaxY + tagVerticalPadding)
        }
        self.isOutofBounds(newPoint: newPoint, labelFrame: self.tags[index].frame)
        return CGRect(x: newPoint.x, y: newPoint.y, width: self.tags[index].frame.width, height: self.tags[index].frame.height)
    }
    
}

public class HSButton: UIButton {
    var identifier: String?
}

public protocol HSIdentifialble {
    var identifier: String? { get }
}
