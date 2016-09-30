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
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var birthDateTextField: UITextField!
    @IBOutlet weak var continueButton: UIButton!

    private var name: String!
    private var profile:Profile? = Profile()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profile?.name = "RNDebugMenu"
        textField.text = profile?.name
        
        initDebugMenu()
    }
    
    
    @IBAction func onValueChangedGender(_ sender: UISegmentedControl) {
        profile?.gender =  Gender.init(rawValue: sender.selectedSegmentIndex)
    }
    @IBAction func onTouchContinue(_ sender: UIButton) {
    }
    @IBAction func onEditingDidEnd(_ sender: UITextField) {
        profile?.name = sender.text!
    }
    @IBAction func onEditingChanged(_ sender: UITextField) {
        profile?.name = sender.text!
    }
    @IBAction func onTouchButton(_ sender: UIButton) {
        RNDebugManager.sharedInstance.switchShowOrClose()
    }

    func changeColor(slider: UISlider) {
        let oldColor = continueButton.backgroundColor
        var red:CGFloat = 1.0
        var green:CGFloat = 1.0
        var blue:CGFloat = 1.0
        var alpha:CGFloat = 1.0
        oldColor?.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        
        let color = UIColor(red: red, green: CGFloat(slider.value), blue: blue, alpha: alpha)
        continueButton.backgroundColor = color
    }
    
    private func initDebugMenu(){
        RNDebugManager.sharedInstance.addValueLabel { [weak self] () in
            return "Name:\(self?.profile?.name)"
        }
        RNDebugManager.sharedInstance.addValueLabel{ [weak self] () in
            return "Gender:\(self?.profile?.gender)"
        }
        
        RNDebugManager.sharedInstance.addValueSlider({ [weak self] (slider) in
            self?.changeColor(slider: slider!)
            }, minValue: 0.0, maxValue: 1.0)

        RNDebugManager.sharedInstance.addValueTextField { [weak self] (textField) in
            self?.profile?.name = (textField?.text)!
            self?.textField.text = textField?.text
        }
        
        RNDebugManager.sharedInstance.addValueTextView("area",ctrlFunc:{ [weak self] (textView) in
            self?.profile?.name = (textView?.text)!
        })
        
        RNDebugManager.sharedInstance.addButton({ [weak self] (button) in
            self?.profile?.name = ""
            self?.textField.text = ""
            }, drawFunc: {(button) in
                button?.setTitle("Clear", for: .normal)
        })
        
        RNDebugManager.sharedInstance.addButton({ [weak self] (button) in
            
            
            let textView:UITextView = RNDebugManager.sharedInstance.viewByName("area")!
            let alert = UIAlertController(title: "Debug", message: textView.text, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            self?.present(alert, animated: true, completion: nil)
            }, drawFunc:{(button) in
                button?.setTitle("Show Alert", for: .normal)
        })
        
        
    }
}
