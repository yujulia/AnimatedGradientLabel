//
//  ViewController.swift
//  AnimatedGradientLabel
//
//  Created by Julia Yu on 3/31/17.
//  Copyright © 2017 Julia Yu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var label: AnimatedGradientLabel!
    @IBOutlet weak var secondLabel: AnimatedGradientLabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        let shadow = NSShadow()
        shadow.shadowBlurRadius = 3
        shadow.shadowOffset = CGSize(width: 3, height: 3)
        shadow.shadowColor = UIColor.gray
        let shadowStringText = "Shadow String"
        let shadowAttribute = [ NSShadowAttributeName: shadow ]
        let shadowString = NSAttributedString(string: shadowStringText, attributes: shadowAttribute)


        let underlineStringText = "Underline String"
        let underlineAttribute = [ NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue ]
        let underlineString = NSAttributedString(string: underlineStringText, attributes: underlineAttribute)

        executeAfter(3) {
            self.label.attributedText = shadowString
        }

        executeAfter(9) {
            self.label.attributedText = underlineString
        }

    }
}

public func executeAfter(_ delay: Double, queue: DispatchQueue? = nil, closure: @escaping () -> Void) {
    let time = DispatchTime.now() + DispatchTimeInterval.milliseconds(Int(delay * 1000))
    (queue ?? DispatchQueue.main).asyncAfter(deadline: time, execute: closure)
}
