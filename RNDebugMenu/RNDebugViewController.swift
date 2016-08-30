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
        
        let closeButton = buildCloseButton()
        self.view.addSubview(closeButton)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        self.view.addConstraints([
            NSLayoutConstraint(item: view, attribute: .Top, relatedBy: .Equal, toItem: self.view, attribute: .Top, multiplier: 1, constant: 15),
            NSLayoutConstraint(item: view, attribute: .Bottom, relatedBy: .Equal, toItem: self.view, attribute: .Bottom, multiplier: 1, constant: -10),
            NSLayoutConstraint(item: view, attribute: .Left, relatedBy: .Equal, toItem: self.view, attribute: .Left, multiplier: 1, constant: 10),
            NSLayoutConstraint(item: view, attribute: .Right, relatedBy: .Equal, toItem: self.view, attribute: .Right, multiplier: 1, constant: -10),
        ])
        
        let stackView = buildVerticalStackView()
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints([
            NSLayoutConstraint(item: stackView, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: stackView, attribute: .Bottom, relatedBy: .Equal, toItem: view, attribute: .Bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: stackView, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: stackView, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1, constant: 0),
        ])
    }
    
    private func buildCloseButton() -> UIButton {
        let button = UIButton(type: .System)
        button.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
        button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        button.setTitle("x", forState: .Normal)
        button.addTarget(self, action: #selector(RNDebugViewController.onTouchCloseButton(_:)), forControlEvents: .TouchDown)
        return button
    }
    
    func onTouchCloseButton(sender:UIButton){
        listener.closeWindow()
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