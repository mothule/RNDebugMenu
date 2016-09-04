//
//  ViewController.swift
//  ResearchWindow
//
//  Created by mothule on 2016/08/27.
//  Copyright © 2016年 mothule. All rights reserved.
//

import UIKit


enum Gender : Int {
    case Male = 0
    case Female = 1
}


class Profile {
    var name: String = ""
    var age: Int?
    var gender:Gender?

    init() {}
    init(name: String) {
        self.name = name
    }
}



class ViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    private var name: String!
    private var profile:Profile? = Profile()

    @IBOutlet weak var textField: UITextField!
    
    
    @IBAction func onEditingDidEnd(sender: UITextField) {
        profile?.name = sender.text!
    }

    @IBAction func onEditingChanged(sender: UITextField) {
        profile?.name = sender.text!
    }

    @IBAction func onTouchReleaseProfile(sender: UIButton) {
        profile = nil
        RNDebugManager.sharedInstance.notifyChangedValue()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        profile?.name = "RNDebugMenu"
        textField.text = profile?.name
        
        initDebugMenu()
    }

    @IBAction func onTouchButton(sender: UIButton) {
        RNDebugManager.sharedInstance.switchShowOrClose()
    }

    func changeColor(slider: UISlider) {
        let color = UIColor(red: CGFloat(slider.value), green: 0.0, blue: 0.0, alpha: 1.0)
        label.textColor = color
    }
    
    private func initDebugMenu(){
        RNDebugManager.sharedInstance.addValueLabel { [weak self] () in
            return "Name:\(self?.profile?.name)"
        }
        RNDebugManager.sharedInstance.addValueSlider({ [weak self] (slider) in
            self?.changeColor(slider!)
            }, minValue: 0.0, maxValue: 1.0)
        RNDebugManager.sharedInstance.addValueSlider({ [weak self] (slider) in
            self?.label.font = UIFont.systemFontOfSize(CGFloat((slider?.value)!))
            self?.label.sizeToFit()
            }, minValue: 1.0, maxValue: 32.0)
        
        RNDebugManager.sharedInstance.addValueTextField { [weak self] (textField) in
            self?.profile?.name = (textField?.text)!
            self?.textField.text = textField?.text
        }
        
        RNDebugManager.sharedInstance.addValueTextView{ [weak self] (textView) in
            self?.profile?.name = (textView?.text)!
        }
        
        RNDebugManager.sharedInstance.addButton({ [weak self] (button) in
            self?.profile?.name = ""
            self?.textField.text = ""
            }, drawFunc: {(button) in
                button?.setTitle("Clear", forState: .Normal)
        })
        
    }
}
