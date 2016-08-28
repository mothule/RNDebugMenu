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

protocol RNDebugItemDrawable {
    func createItem() -> UIView
    func updateItem()
}
public class RNDebugItem{
    var drawer:RNDebugItemDrawable!
}

public class RNDebugItemLabel : RNDebugItem, RNDebugItemDrawable {
    var format:String
    var value:Any?
    weak var view:UIView?
    
    init(format:String, value:Any?){
        self.format = format
        self.value = value
        super.init()
        super.drawer = self
    }
    
    func createItem() -> UIView {
        let frame = CGRect(x: 0, y: 0, width: 0, height: 50)
        let label = UILabel(frame: frame)
        label.numberOfLines = 0
        view = label
        updateItem()
        return label
    }
    func updateItem() {
        let label = view as! UILabel
        label.text = format + "\(value)"
        label.sizeToFit()
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
