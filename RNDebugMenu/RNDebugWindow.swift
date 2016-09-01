//
//  RNDebugWindow.swift
//  ResearchWindow
//
//  Created by mothule on 2016/08/28.
//  Copyright © 2016年 mothule. All rights reserved.
//

import Foundation
import UIKit

public class RNDebugWindow : UIWindow
{
    enum BehaviorMode : Int{
        case None
        case MoveWindowPosition
        case ChangeWindowSize
    }
    
    private var behaviorMode:BehaviorMode = .None
    private var locationInitialTouch:CGPoint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(red: 0.3, green: 0.4, blue: 0.5, alpha: 0.7)
        self.userInteractionEnabled = true
        self.windowLevel = UIWindowLevelAlert
        self.rootViewController = RNDebugViewController()
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Window Behavior
    override public func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.locationInView(self)
            locationInitialTouch = location
            if location.x > bounds.width - 20 && location.y > bounds.height - 20{
                behaviorMode = .ChangeWindowSize
            }else{
                behaviorMode = .MoveWindowPosition
            }
        }
    }
    
    override public func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.locationInView(self)
            if behaviorMode == .ChangeWindowSize {
                frame = CGRect(origin: frame.origin, size: CGSize(width: location.x, height: location.y ))
            }else{
                frame = frame.offsetBy(dx: location.x - locationInitialTouch.x, dy: location.y - locationInitialTouch.y)
            }
        }
    }
    override public func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.locationInView(self)
            if behaviorMode == .ChangeWindowSize {
                frame = CGRect(origin: frame.origin, size: CGSize(width: location.x, height: location.y ))
            }else{
                frame = frame.offsetBy(dx: location.x - locationInitialTouch.x, dy: location.y - locationInitialTouch.y)
            }
            behaviorMode = .None
        }
    }
}











































