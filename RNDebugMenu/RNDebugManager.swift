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

protocol RNDebugItemListener {
    func listenChangedValue()
}

public protocol RNKey {
    var Name:String { get }
}

extension String: RNKey {
    public var Name:String { get{ return self } }
}
extension Int:RNKey{
    public var Name:String { get{return String(self) }}
}
extension Float:RNKey{
    public var Name:String { get{return String(self) }}
}
extension Double:RNKey{
    public var Name:String { get{return String(self) }}
}

open class RNDebugManager {
    
    fileprivate static var instance: RNDebugManager!
    open static var sharedInstance: RNDebugManager {
        if instance == nil { instance = RNDebugManager() }
        return instance
    }

    fileprivate var window: RNDebugWindow!
    fileprivate var items: [RNDebugItem] = []
    fileprivate var itemHash: [String:RNDebugItem] = [:]
    fileprivate var listener: RNDebugItemListener?

    open func addValueLabel(_ drawer: @escaping RNViewDrawFunc) {
        items.append(RNDebugItemLabel(drawFunc: drawer))
    }
    open func addValueSlider(_ ctrlFunc: @escaping RNViewSliderCtrlFunc, minValue: Float, maxValue: Float) {
        items.append(RNDebugItemSlider(ctrlFunc: ctrlFunc, minValue:minValue, maxValue:maxValue))
    }
    open func addValueTextField(_ ctrlFunc: @escaping RNViewTextFieldCtrlFunc) {
        items.append(RNDebugItemTextField(ctrlFunc:ctrlFunc))
    }
    open func addValueTextView(_ key:RNKey, ctrlFunc: @escaping RNViewTextViewCtrlFunc){
        let item = RNDebugItemTextView(ctrlFunc:ctrlFunc)
        items.append(item)
        itemHash[key.Name] = item
    }
    open func addButton(_ ctrlFunc: @escaping RNViewButtonCtrlFunc, drawFunc: @escaping RNViewButtonDrawFunc){
        items.append(RNDebugItemButton(ctrlFunc: ctrlFunc, drawFunc: drawFunc))
    }
    
    open func viewByName<T>(_ name:String) -> T? {
        if itemHash.contains(where: {k,_ in k == name }) {
            return itemHash[name]!.view as? T
        }
        return nil
    }


    open func switchShowOrClose() {
        let size = UIScreen.main.bounds.size
        let frame = CGRect(x: 0, y: size.height * 0.3 , width: size.width, height: size.height * 0.5)

        if window == nil {
            window = RNDebugWindow(frame: frame)

            if let viewController = window.rootViewController as? RNDebugViewController {
                viewController.dataSource = self
                viewController.listener = self
                listener = viewController
            }

            window.makeKeyAndVisible()
        } else {
            window = nil
        }
    }

    open func notifyChangedValue() {
        if window != nil {
            listener?.listenChangedValue()
        }
    }
}

extension RNDebugManager : RNDebugViewControllerListener {
    func closeWindow() {
        window.rootViewController = nil
        window = nil
    }
}

extension RNDebugManager : RNDebugItemDatasource {
    func getItems() -> [RNDebugItem] {
        return self.items
    }
}
