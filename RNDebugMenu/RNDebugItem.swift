//
//  RNDebugItem.swift
//  Demo
//
//  Created by mothule on 2016/09/04.
//  Copyright © 2016年 mothule. All rights reserved.
//

import Foundation
import UIKit

public typealias RNViewDrawFunc = () -> (Any?)
public typealias RNViewButtonDrawFunc = (UIButton?) -> ()

// Wait for Swift3
//public typealias RNViewCtrlFunc<T> (T?) -> ()
public typealias RNViewSliderCtrlFunc = (UISlider?) -> ()
public typealias RNViewTextFieldCtrlFunc = (UITextField?) -> ()
public typealias RNViewButtonCtrlFunc = (UIButton?) -> ()
public typealias RNViewTextViewCtrlFunc = (UITextView?) -> ()





protocol RNDebugItemViewable {
    func createViewForItem() -> UIView
    func updateView()
}
public class RNDebugItem : NSObject{
    var viewable: RNDebugItemViewable!
    weak var view: UIView?
}


/**
    It is UILabel wrapper.
    This class Display label on a debug window.
 */
public class RNDebugItemLabel: RNDebugItem, RNDebugItemViewable {
    var loopTimer: NSTimer!
    var drawFunc: RNViewDrawFunc?
    
    init(drawFunc: RNViewDrawFunc) {
        super.init()
        super.viewable = self
        self.drawFunc = drawFunc
    }
    
    func createViewForItem() -> UIView {
        let frame = CGRect(x: 0, y: 0, width: 300, height: 50)
        let label = UILabel(frame: frame)
        label.numberOfLines = 0
        view = label
        updateView()
        
        loopTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(RNDebugItemLabel.repeatsTimer(_:)), userInfo: nil, repeats: true)
        
        return label
    }
    
    deinit {
        if loopTimer != nil { loopTimer.invalidate() }
    }
    
    @objc func repeatsTimer(timer: NSTimer) {
        updateView()
    }
    
    func updateView() {
        let label = view as! UILabel
        label.text = drawFunc?() as? String
    }
}

/**
    It is UISlider wrapper.
    This class display on a debug window.
    And it can be control UISlider.
 */
public class RNDebugItemSlider: RNDebugItem, RNDebugItemViewable {
    var ctrlFunc: RNViewSliderCtrlFunc?
    var minValue: Float = 0.0
    var maxValue: Float = 1.0
    init(ctrlFunc: RNViewSliderCtrlFunc, minValue: Float, maxValue: Float) {
        super.init()
        super.viewable = self
        self.ctrlFunc = ctrlFunc
        self.minValue = minValue
        self.maxValue = maxValue
    }
    func createViewForItem() -> UIView {
        let frame = CGRect(x: 0, y: 0, width: 300, height: 10)
        let slider = UISlider(frame: frame)
        slider.minimumValue = self.minValue
        slider.maximumValue = self.maxValue
        slider.value = 0.0
        slider.addTarget(self, action: #selector(RNDebugItemSlider.onValueChanged(_:)), forControlEvents: .ValueChanged)
        
        view = slider
        updateView()
        return view!
    }
    @objc func onValueChanged(sender: UISlider) {
        ctrlFunc?(sender)
        
    }
    func updateView() {
    }
}

/**
    It is UITextField wrapper.
    This class display on a debug window.
    And it can be input strings.
 */
public class RNDebugItemTextField: RNDebugItem, RNDebugItemViewable {
   
    var ctrlFunc: RNViewTextFieldCtrlFunc?
    init(ctrlFunc: RNViewTextFieldCtrlFunc) {
        super.init()
        super.viewable = self
        self.ctrlFunc = ctrlFunc
    }
    func createViewForItem() -> UIView {
        let frame = CGRect(x: 0, y: 0, width: 200, height: 10)
        let textField = UITextField(frame: frame)
        textField.addTarget(self, action: #selector(RNDebugItemTextField.onEditingChanged(_:)), forControlEvents: .EditingChanged)
        textField.borderStyle = .RoundedRect
        textField.placeholder = "Here is UITextField"
        view = textField
        updateView()
        return view!
    }
    func updateView() {
        
    }
    @objc func onEditingChanged(sender: UITextField) {
        ctrlFunc?(sender)
    }
}

public class RNDebugItemTextView: RNDebugItem, RNDebugItemViewable, UITextViewDelegate {
    
    

    var ctrlFunc: RNViewTextViewCtrlFunc?
    init(ctrlFunc:RNViewTextViewCtrlFunc){
        super.init()
        super.viewable = self
        self.ctrlFunc = ctrlFunc
    }
    
    func createViewForItem() -> UIView {
        let frame = CGRect(x: 0, y: 0, width: 200, height: 50)
        let textView = UITextView(frame: frame)
        textView.delegate = self
        view = textView
        return textView
    }
    func updateView() {
        
    }
    @objc public func textViewDidChange(textView: UITextView)
    {
        ctrlFunc?(textView)
    }
}

/**
    It is UIButton wapper.
    This class display on a debug window.
    And it can be invoke event.
 */
public class RNDebugItemButton : RNDebugItem, RNDebugItemViewable {
   
    var ctrlFunc: RNViewButtonCtrlFunc?
    var drawFunc: RNViewButtonDrawFunc?
    
    init(ctrlFunc: RNViewButtonCtrlFunc, drawFunc:RNViewButtonDrawFunc){
        super.init()
        super.viewable = self
        self.ctrlFunc = ctrlFunc
        self.drawFunc = drawFunc
    }
    
    func createViewForItem() -> UIView {
        let frame = CGRect(x: 0, y: 0, width: 200, height: 10)
        let button = UIButton(type: .System)
        button.layer.cornerRadius = 0.5
        button.layer.borderWidth = 1.1
        button.layer.borderColor = UIColor(red: 30.0/255.0, green: 108/255.0, blue: 232/255.0, alpha: 1).CGColor
        button.frame = frame
        button.addTarget(self, action: #selector(RNDebugItemButton.onTouchButton(_:)), forControlEvents: .TouchUpInside)
        view = button
        updateView()
        return button
    }
    func updateView() {
        drawFunc?(view as? UIButton)
    }
    @objc func onTouchButton(sender:UIButton){
        ctrlFunc?(sender)
    }
}