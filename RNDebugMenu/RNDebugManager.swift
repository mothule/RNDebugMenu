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


public class RNDebugManager {
    private static var instance: RNDebugManager!
    public static var sharedInstance: RNDebugManager {
        if instance == nil { instance = RNDebugManager() }
        return instance
    }

    private var window: RNDebugWindow!
    private var items: [RNDebugItem] = []
    private var listener: RNDebugItemListener?

    public func addValueLabel(drawer: RNViewDrawFunc) {
        let item = RNDebugItemLabel(drawFunc: drawer)
        items.append(item)
    }
    public func addValueSlider(ctrlFunc: RNViewSliderCtrlFunc, minValue: Float, maxValue: Float) {
        let item = RNDebugItemSlider(ctrlFunc: ctrlFunc, minValue:minValue, maxValue:maxValue)
        items.append(item)
    }
    public func addValueTextField(ctrlFunc: RNViewTextFieldCtrlFunc) {
        let item = RNDebugItemTextField(ctrlFunc:ctrlFunc)
        items.append(item)
    }
    public func addButton(ctrlFunc: RNViewButtonCtrlFunc, drawFunc: RNViewButtonDrawFunc){
        let item = RNDebugItemButton(ctrlFunc: ctrlFunc, drawFunc: drawFunc)
        items.append(item)
    }


    public func switchShowOrClose() {
        let size = UIScreen.mainScreen().bounds.size
        let frame = CGRect(x: 0, y: 0, width: size.width, height: 50)

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
        window = nil
    }
}

extension RNDebugManager : RNDebugItemDatasource {
    func getItems() -> [RNDebugItem] {
        return self.items
    }
}
