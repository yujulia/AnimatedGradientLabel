//
//  AnimatedGradientLabel.swift
//  AnimatedGradientLabel
//
//  Created by Julia Yu on 3/31/17.
//  Copyright © 2017 Julia Yu. All rights reserved.
//

import UIKit

@IBDesignable
public final class AnimatedGradientLabel: UILabel {

    // The center color in the gradient or the highlight effect
    @IBInspectable public var highlightColor: UIColor =  .yellow {
        didSet { self.startAnimation() }
    }

    // The edge colors of the gradient
    @IBInspectable public var fillColor: UIColor = .red {
        didSet { self.startAnimation() }
    }

    // How long it takes to animate the gradient across the label
    @IBInspectable public var duration: Float = 2.0 {
        didSet { self.startAnimation() }
    }

    // How many times to repeat the animation
    @IBInspectable public var repeatCount: Float = .infinity {
        didSet { self.startAnimation() }
    }

    // Where the gradient stops on the label
    public var locations: [Double] = [0.0, 0.5, 1.0] {
        didSet { self.startAnimation() }
    }

    // The start point of the gradient - currently set to sideways
    public var startPoint: CGPoint = CGPoint(x: 0.0, y: 0.5) {
        didSet { self.startAnimation() }
    }

    // The end point of the gradient - currently set to sideways
    public var endPoint: CGPoint = CGPoint(x: 1.0, y: 0.5) {
        didSet { self.startAnimation() }
    }

    // If the text on the label change we should restart animation as the mask has changed
    override public var text: String? {
        didSet {
            if self.text != oldValue {
                self.startAnimation()
            }
        }
    }

    // If the bounds on the label change we should restart animation as the gradient size changed
    override public var bounds: CGRect {
        didSet {
            if self.bounds != oldValue {
                self.startAnimation()
            }
        }
    }

    // Start animation on load
    override public func awakeFromNib() {
        super.awakeFromNib()
        self.startAnimation()
    }

    // MARK: Private Variables
    private var animationLayer: CALayer = CALayer()
    private var colors: [CGColor] {
        return [self.fillColor, self.highlightColor, self.fillColor].map { $0.cgColor }
    }

    // MARK: AnimatedGradientLabel
    // Stop the layer animation by removing the gradient layer and mask from this label
    public func stopAnimation() {
        self.animationLayer.removeFromSuperlayer()
        self.mask = nil
    }

    // Start the animation by creating the gradient layer based on current label size and settings
    public func startAnimation() {
        self.stopAnimation()

        self.animationLayer = self.createAnimationLayer()
        self.layer.addSublayer(self.animationLayer)
        self.mask = self.createTextMask()
    }

    // MARK: Private Helpers
    private func createTextMask() -> UILabel {
        let textMask = UILabel()

        textMask.frame = self.bounds
        textMask.text = self.text
        textMask.adjustsFontSizeToFitWidth = self.adjustsFontSizeToFitWidth
        textMask.attributedText = self.attributedText
        textMask.baselineAdjustment = self.baselineAdjustment
        textMask.font = self.font
        textMask.lineBreakMode = self.lineBreakMode
        textMask.minimumScaleFactor = self.minimumScaleFactor
        textMask.numberOfLines = self.numberOfLines
        textMask.preferredMaxLayoutWidth = self.preferredMaxLayoutWidth
        textMask.textAlignment = self.textAlignment

        return textMask
    }

    private func createAnimationLayer() -> CALayer {
        let width = self.frame.width
        let height = self.frame.height

        let startLayer = CALayer()
        startLayer.frame = CGRect(x: 0, y: 0, width: width, height: height)
        startLayer.backgroundColor = self.fillColor.cgColor

        let endLayer = CALayer()
        endLayer.backgroundColor = self.fillColor.cgColor
        endLayer.frame = CGRect(x: width * 2, y: 0, width: width, height: height)

        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: width, y: 0, width: width, height: height)
        gradientLayer.colors = self.colors
        gradientLayer.locations = self.locations as [NSNumber]
        gradientLayer.startPoint = self.startPoint
        gradientLayer.endPoint = self.endPoint

        let animationLayer = CALayer()
        animationLayer.frame = CGRect(x: 0, y: 0, width: width * 3, height: height)
        animationLayer.backgroundColor = UIColor.clear.cgColor
        animationLayer.addSublayer(gradientLayer)
        animationLayer.addSublayer(startLayer)
        animationLayer.addSublayer(endLayer)

        let animation = CABasicAnimation(keyPath: "transform.translation.x")
        animation.fromValue = -width * 2
        animation.toValue = 0
        animation.duration = CFTimeInterval(self.duration)
        animation.repeatCount = self.repeatCount
        animationLayer.add(animation, forKey: nil)
        
        return animationLayer
    }
}
