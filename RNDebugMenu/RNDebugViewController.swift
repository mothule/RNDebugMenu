//
//  RNDebugViewController.swift
//  ResearchWindow
//
//  Created by mothule on 2016/08/30.
//  Copyright © 2016年 mothule. All rights reserved.
//

import Foundation
import UIKit

protocol RNDebugItemDatasource {
    func getItems() -> [RNDebugItem]
}

protocol RNDebugViewControllerListener {
    func closeWindow()
}

open class RNDebugViewController : UIViewController {
    var dataSource:RNDebugItemDatasource!
    var listener:RNDebugViewControllerListener!
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        let view = buildScrollView()
        self.view.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        self.view.addConstraints([
            NSLayoutConstraint(item: view, attribute: .top,    relatedBy: .equal, toItem: self.view, attribute: .top,    multiplier: 1, constant: 15),
            NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1, constant: -10),
            NSLayoutConstraint(item: view, attribute: .left,   relatedBy: .equal, toItem: self.view, attribute: .left,   multiplier: 1, constant: 10),
            NSLayoutConstraint(item: view, attribute: .right,  relatedBy: .equal, toItem: self.view, attribute: .right,  multiplier: 1, constant: -10),
            ])
        
        // Add a close button
        let closeButton = buildCloseButton()
        self.view.addSubview(closeButton)

        
        let stackView = buildVerticalStackView()
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints([
            NSLayoutConstraint(item: stackView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: stackView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: stackView, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: stackView, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1, constant: 0),
        ])

        let guideView = buildGuideView()
        guideView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(guideView)
        self.view.addConstraints([
            NSLayoutConstraint(item: guideView, attribute: .right, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: guideView, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1, constant:0),
            NSLayoutConstraint(item: guideView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 15),
            NSLayoutConstraint(item: guideView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 15),
        ])        
    }
    
    fileprivate func buildCloseButton() -> UIButton {
        class RNTapExpandableButton : UIButton{
            override fileprivate func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
                return CGRect(x: bounds.origin.x - 3, y: bounds.origin.y - 10, width: bounds.width + 6, height: bounds.height + 20).contains(point)
            }
        }
        let button = RNTapExpandableButton(type: .system)
        button.frame = CGRect(x: 0, y: 0, width: 15, height: 15)
        button.setTitleColor(UIColor.white, for: UIControlState())
        button.setTitle("X", for: UIControlState())
        button.backgroundColor = UIColor.darkGray
        button.addTarget(self, action: #selector(RNDebugViewController.onTouchCloseButton(_:)), for: .touchDown)
        return button
    }
    func onTouchCloseButton(_ sender:UIButton){
        listener.closeWindow()
    }
    
    fileprivate func buildGuideView() -> UIView {
        let frame = CGRect(x:0, y: 0, width: 15, height: 15)
        let view = RNChangeGuide(frame:frame)
        return view
    }
    
    fileprivate func buildScrollView() -> UIScrollView{
        let scrollView = UIScrollView(frame: CGRect.zero)
        scrollView.backgroundColor = UIColor(white: 1.0, alpha: 0.5)
        return scrollView
    }
    
    fileprivate func buildVerticalStackView() -> UIStackView{
        let frame = view.bounds
        let stackView = UIStackView(frame: frame)
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.spacing = 8
        dataSource.getItems().forEach { item in
            let v:UIView = item.viewable.createViewForItem()
            stackView.addArrangedSubview(v)

            v.translatesAutoresizingMaskIntoConstraints = false
            stackView.addConstraints([
                NSLayoutConstraint(item: v, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 0, constant: 300)
            ])
            if v is UITextView {
                stackView.addConstraint(
                    NSLayoutConstraint(item: v, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 0, constant: 50)
                    )
            }
        }
        return stackView
    }
}

extension RNDebugViewController : RNDebugItemListener{
    func listenChangedValue(){
        dataSource.getItems().forEach{ $0.viewable.updateView() }
    }
}


open class RNChangeGuide : UIView {
    override init(frame: CGRect) {
        super.init(frame:frame)
        backgroundColor = UIColor.clear
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override open func draw(_ rect: CGRect) {
        super.draw(rect)
        let context = UIGraphicsGetCurrentContext()!
        
        // Color
        let color = UIColor.lightText
        context.setStrokeColor(color.cgColor)

        // Line Width
        context.setLineWidth(2)
        
        let splitSize = 3
        for i in 0..<splitSize {
            let x = (bounds.size.width / CGFloat(splitSize)) * CGFloat(i)
            let points:[CGPoint] = [
                CGPoint(x: x, y: bounds.size.height-2), CGPoint(x: bounds.size.width-2, y: x)
            ]
            
            context.addLines(between: points)
        }
        
        context.strokePath()
    }
    
    
}
