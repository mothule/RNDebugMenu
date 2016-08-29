//
//  RNDebugManager.swift
//  ResearchWindow
//
//  Created by mothule on 2016/08/28.
//  Copyright © 2016年 mothule. All rights reserved.
//

import Foundation
import UIKit

// features
// - It will remove when release mode.(No DEBUG)


public typealias RNViewDrawFunc = () -> (Any?)

// Wait for Swift3
//public typealias RNViewCtrlFunc<T> (T?) -> ()
public typealias RNViewSliderCtrlFunc = (UISlider?) -> ()
public typealias RNViewTextFieldCtrlFunc = (UITextField?) -> ()


protocol RNDebugItemDrawable {
    func createViewForItem() -> UIView
    func updateView()
}
public class RNDebugItem{
    var drawer:RNDebugItemDrawable!
}

public class RNDebugItemLabel : RNDebugItem, RNDebugItemDrawable {
    var format:String
    var value:Any?
    weak var view:UIView?
    var loopTimer:NSTimer!
    var drawFunc:RNViewDrawFunc?
    
    init(format:String, value:Any?){
        self.format = format
        self.value = value
        super.init()
        super.drawer = self
    }
    init(drawFunc:RNViewDrawFunc){
        self.format = ""
        super.init()
        super.drawer = self
        self.drawFunc = drawFunc
    }
    
    func createViewForItem() -> UIView {
        let frame = CGRect(x: 0, y: 0, width: 0, height: 50)
        let label = UILabel(frame: frame)
        label.numberOfLines = 0
        view = label
        updateView()
        
        loopTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(RNDebugItemLabel.repeatsTimer(_:)), userInfo: nil, repeats: true)
        
        return label
    }
    
    deinit{
        if loopTimer != nil { loopTimer.invalidate() }
    }
    
    @objc func repeatsTimer(timer:NSTimer){
        updateView()
    }
    
    func updateView() {
        let label = view as! UILabel
        
        if let drawFunc = drawFunc {
            label.text = drawFunc() as? String
        }else{
            label.text = format + "\(value)"
        }
    }
}
public class RNDebugItemSlider : RNDebugItem, RNDebugItemDrawable {
    weak var view:UIView?
    var ctrlFunc:RNViewSliderCtrlFunc?
    init(ctrlFunc:RNViewSliderCtrlFunc){
        super.init()
        super.drawer = self
        self.ctrlFunc = ctrlFunc
    }
    func createViewForItem() -> UIView {
        let frame = CGRect(x: 0, y: 0, width: 200, height: 10)
        let slider = UISlider(frame: frame)
        slider.minimumValue = 0.0
        slider.maximumValue = 1.0
        slider.value = 0.5
        slider.addTarget(self, action: #selector(RNDebugItemSlider.onValueChanged(_:)), forControlEvents: .ValueChanged)
        
        view = slider
        updateView()
        return view!
    }
    @objc func onValueChanged(sender:UISlider){
        ctrlFunc?(sender)
        
    }
    func updateView() {
    }
}
public class RNDebugItemTextField : RNDebugItem, RNDebugItemDrawable{
    weak var view:UIView?
    var ctrlFunc:RNViewTextFieldCtrlFunc?
    init(ctrlFunc:RNViewTextFieldCtrlFunc){
        super.init()
        super.drawer = self
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
    @objc func onEditingChanged(sender:UITextField){
        ctrlFunc?(sender)
    }
}



protocol RNDebugItemDatasource {
    func getItems() -> [RNDebugItem]
}
protocol RNDebugItemListener{
    func listenChangedValue()
}


public class RNDebugManager {
    private static var instance:RNDebugManager!
    public static var sharedInstance:RNDebugManager {
        if instance == nil { instance = RNDebugManager() }
        return instance
    }
    
    private var window:RNDebugWindow!
    private var items:[RNDebugItem] = []
    private var listener:RNDebugItemListener?
    
    public func addValueLabel(labelFormat:String, value:Any?){
        let item = RNDebugItemLabel(format: labelFormat, value: value)
        items.append(item)
    }
    public func addValueLabel(drawer:RNViewDrawFunc){
        let item = RNDebugItemLabel(drawFunc: drawer)
        items.append(item)
    }
    public func addValueSlider(ctrlFunc: RNViewSliderCtrlFunc){
        let item = RNDebugItemSlider(ctrlFunc: ctrlFunc)
        items.append(item)
    }
    public func addValueTextField(ctrlFunc: RNViewTextFieldCtrlFunc){
        let item = RNDebugItemTextField(ctrlFunc:ctrlFunc)
        items.append(item)
    }
    
    
    public func switchShowOrClose(){
        let size = UIScreen.mainScreen().bounds.size
        let frame = CGRect(x: 0, y: 0, width: size.width, height: 50)
        
        if window == nil {
            window = RNDebugWindow(frame: frame)
            
            if let viewController = window.rootViewController as? RNDebugViewController {
                viewController.dataSource = self
                listener = viewController
            }
            
            window.makeKeyAndVisible()
        }else {
            window = nil
        }
    }
    
    public func notifyChangedValue(){
        if window != nil {
            listener?.listenChangedValue()
        }
    }
}

extension RNDebugManager : RNDebugItemDatasource {
    func getItems() -> [RNDebugItem] {
        return self.items
    }
}
