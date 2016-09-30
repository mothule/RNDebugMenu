# RNDebugMenu
This library will display a menu that allows you to edit and display the variable.

![librarypromotionanimation](https://cloud.githubusercontent.com/assets/974367/18095335/a15d3a22-6f11-11e6-8506-83d179bcc9a3.gif)




# Features
- You can your any variables show using Default UIKit.
- You can your any variables tweak using Default UIKit.



# How to use

Prepare target model.

~~~swift
class Profile {
    var name: String?
    var age: Int?
    var email: String?

    init() {}
    init(name: String?, age: Int?, email: String?) {
        self.name = name
        self.age = age
        self.email = email
    }
}
~~~

~~~swift
override func viewDidLoad() {
    super.viewDidLoad()

    profile?.name = "RNDebugMenu"

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
        self?.profile?.name = textField?.text
        self?.textField.text = textField?.text
    }

    RNDebugManager.sharedInstance.addButton({ [weak self] (button) in
        self?.profile?.name = ""
        self?.textField.text = ""
    }, drawFunc: {(button) in
        button?.setTitle("Clear", forState: .Normal)
    })

    textField.text = profile?.name
}

func changeColor(slider: UISlider) {
    let color = UIColor(red: CGFloat(slider.value), green: 0.0, blue: 0.0, alpha: 1.0)
    label.textColor = color
}
~~~


# Runtime Requirements

- iOS 10 later
- Swift 3.0 later

# Future roadmap

- Redesign Demo Project
- Support CocoaPods
- Support Carthage


# Installation and Setup

- Download a zip and copies files into your project.
- Not supported CocoaPods yet.
- Not supported Carthage yet.

# Attention

I am a Japanese programmer, so I have some trouble writing in English. 
You may find a typo or mistake but just be nice with your feedback.

Thank you for your support and kindness.

