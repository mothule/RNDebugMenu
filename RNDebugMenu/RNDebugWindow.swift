//
//  RNDebugWindow.swift
//  ResearchWindow
//
//  Created by mothule on 2016/08/28.
//  Copyright © 2016年 mothule. All rights reserved.
//

import Foundation
import UIKit

open class RNDebugWindow : UIWindow
{
    enum BehaviorMode : Int{
        case none
        case moveWindowPosition
        case changeWindowSize
    }
    
    fileprivate var behaviorMode:BehaviorMode = .none
    fileprivate var locationInitialTouch:CGPoint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(red: 0.3, green: 0.4, blue: 0.5, alpha: 0.7)
        self.isUserInteractionEnabled = true
        self.windowLevel = UIWindowLevelAlert
        self.rootViewController = RNDebugViewController()
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Window Behavior
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            locationInitialTouch = location
            if location.x > bounds.width - 20 && location.y > bounds.height - 20{
                behaviorMode = .changeWindowSize
            }else{
                behaviorMode = .moveWindowPosition
            }
        }
    }
    
    override open func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            if behaviorMode == .changeWindowSize {
                frame = CGRect(origin: frame.origin, size: CGSize(width: location.x, height: location.y ))
            }else{
                frame = frame.offsetBy(dx: location.x - locationInitialTouch.x, dy: location.y - locationInitialTouch.y)
            }
        }
    }
    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            if behaviorMode == .changeWindowSize {
                frame = CGRect(origin: frame.origin, size: CGSize(width: location.x, height: location.y ))
            }else{
                frame = frame.offsetBy(dx: location.x - locationInitialTouch.x, dy: location.y - locationInitialTouch.y)
            }
            behaviorMode = .none
        }
    }
}











































