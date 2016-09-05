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

public class RNDebugManager {
    
    private static var instance: RNDebugManager!
    public static var sharedInstance: RNDebugManager {
        if instance == nil { instance = RNDebugManager() }
        return instance
    }

    private var window: RNDebugWindow!
    private var items: [RNDebugItem] = []
    private var itemHash: [String:RNDebugItem] = [:]
    private var listener: RNDebugItemListener?

    public func addValueLabel(drawer: RNViewDrawFunc) {
        items.append(RNDebugItemLabel(drawFunc: drawer))
    }
    public func addValueSlider(ctrlFunc: RNViewSliderCtrlFunc, minValue: Float, maxValue: Float) {
        items.append(RNDebugItemSlider(ctrlFunc: ctrlFunc, minValue:minValue, maxValue:maxValue))
    }
    public func addValueTextField(ctrlFunc: RNViewTextFieldCtrlFunc) {
        items.append(RNDebugItemTextField(ctrlFunc:ctrlFunc))
    }
    public func addValueTextView(key:RNKey, ctrlFunc: RNViewTextViewCtrlFunc){
        let item = RNDebugItemTextView(ctrlFunc:ctrlFunc)
        items.append(item)
        itemHash[key.Name] = item
    }
    public func addButton(ctrlFunc: RNViewButtonCtrlFunc, drawFunc: RNViewButtonDrawFunc){
        items.append(RNDebugItemButton(ctrlFunc: ctrlFunc, drawFunc: drawFunc))
    }
    
    public func viewByName<T>(name:String) -> T? {
        if itemHash.contains({k,_ in k == name }) {
            return itemHash[name]!.view as? T
        }
        return nil
    }


    public func switchShowOrClose() {
        let size = UIScreen.mainScreen().bounds.size
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

    public func notifyChangedValue() {
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
