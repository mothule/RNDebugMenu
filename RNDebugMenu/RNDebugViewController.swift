//
//  RNDebugViewController.swift
//  ResearchWindow
//
//  Created by mothule on 2016/08/30.
//  Copyright © 2016年 mothule. All rights reserved.
//

import Foundation
import UIKit


protocol RNDebugViewControllerListener {
    func closeWindow()
}

public class RNDebugViewController : UIViewController {
    var dataSource:RNDebugItemDatasource!
    var listener:RNDebugViewControllerListener!
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        let view = buildScrollView()
        self.view.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        self.view.addConstraints([
            NSLayoutConstraint(item: view, attribute: .Top,    relatedBy: .Equal, toItem: self.view, attribute: .Top,    multiplier: 1, constant: 15),
            NSLayoutConstraint(item: view, attribute: .Bottom, relatedBy: .Equal, toItem: self.view, attribute: .Bottom, multiplier: 1, constant: -10),
            NSLayoutConstraint(item: view, attribute: .Left,   relatedBy: .Equal, toItem: self.view, attribute: .Left,   multiplier: 1, constant: 10),
            NSLayoutConstraint(item: view, attribute: .Right,  relatedBy: .Equal, toItem: self.view, attribute: .Right,  multiplier: 1, constant: -10),
            ])
        
        // Add a close button
        let closeButton = buildCloseButton()
        self.view.addSubview(closeButton)

        
        let stackView = buildVerticalStackView()
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints([
            NSLayoutConstraint(item: stackView, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: stackView, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: stackView, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: stackView, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1, constant: 0),
        ])

        let guideView = buildGuideView()
        guideView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(guideView)
        self.view.addConstraints([
            NSLayoutConstraint(item: guideView, attribute: .Right, relatedBy: .Equal, toItem: self.view, attribute: .Right, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: guideView, attribute: .Bottom, relatedBy: .Equal, toItem: self.view, attribute: .Bottom, multiplier: 1, constant:0),
            NSLayoutConstraint(item: guideView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1, constant: 15),
            NSLayoutConstraint(item: guideView, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .Width, multiplier: 1, constant: 15),
        ])
    }
    
    private func buildCloseButton() -> UIButton {
        class RNTapExpandableButton : UIButton{
            override private func pointInside(point: CGPoint, withEvent event: UIEvent?) -> Bool {
                return CGRectContainsPoint(CGRect(x: bounds.origin.x - 3, y: bounds.origin.y - 10, width: bounds.width + 6, height: bounds.height + 20),
                                           point)
            }
        }
        let button = RNTapExpandableButton(type: .System)
        button.frame = CGRect(x: 0, y: 0, width: 15, height: 15)
        button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        button.setTitle("X", forState: .Normal)
        button.backgroundColor = UIColor.darkGrayColor()
        button.addTarget(self, action: #selector(RNDebugViewController.onTouchCloseButton(_:)), forControlEvents: .TouchDown)
        return button
    }
    func onTouchCloseButton(sender:UIButton){
        listener.closeWindow()
    }
    
    private func buildGuideView() -> UIView {
        let frame = CGRect(x:0, y: 0, width: 15, height: 15)
        let view = RNChangeGuide(frame:frame)
//        view.backgroundColor = UIColor.redColor()
        return view
    }
    
    private func buildScrollView() -> UIScrollView{
        let scrollView = UIScrollView(frame: CGRectZero)
        scrollView.backgroundColor = UIColor(white: 1.0, alpha: 0.5)
        return scrollView
    }
    
    private func buildVerticalStackView() -> UIStackView{
        let stackView = UIStackView()
        stackView.axis = .Vertical
        stackView.alignment = .Fill
        stackView.distribution = .EqualSpacing
        stackView.spacing = 8
        dataSource.getItems().forEach { item in
            stackView.addArrangedSubview(item.viewable.createViewForItem())
        }
        return stackView
    }
}

extension RNDebugViewController : RNDebugItemListener{
    func listenChangedValue(){
        dataSource.getItems().forEach{ $0.viewable.updateView() }
    }
}


public class RNChangeGuide : UIView {
    override init(frame: CGRect) {
        super.init(frame:frame)
        backgroundColor = UIColor.clearColor()
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override public func drawRect(rect: CGRect) {
        super.drawRect(rect)
        let context = UIGraphicsGetCurrentContext()!
        
        // Color
        let color = UIColor.darkGrayColor()
        CGContextSetStrokeColorWithColor(context, color.CGColor)

        // Line Width
        CGContextSetLineWidth(context, 2)
        
        let splitSize = 4
        for i in 0..<splitSize {
            let x = (bounds.size.width / CGFloat(splitSize)) * CGFloat(i)
            let points:[CGPoint] = [
                CGPointMake(x, bounds.size.height), CGPointMake(bounds.size.width, x)
            ]
            CGContextAddLines(context, points, points.count)
        }
        
        CGContextStrokePath(context)
    }
    
    
}