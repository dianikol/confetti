//
//  SAConfettiView.swift
//  Pods
//
//  Created by Sudeep Agarwal on 12/14/15.
//
// Updated by Robert Hanlon on 03/26/2018: Swift 4 support
//

import UIKit
import QuartzCore

@objc public class SAConfettiView: UIView {

    @objc public enum ConfettiType: Int {
        case confetti
        case triangle
        case star
        case diamond
        case image
    }

    var emitter: CAEmitterLayer?
    public var colors: [UIColor]?
    public var intensity: Float?
    public var type: ConfettiType?
    private var active :Bool?
    public var customImage: UIImage?

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    func setup() {
        colors = [UIColor(red:0.95, green:0.40, blue:0.27, alpha:1.0),
            UIColor(red:1.00, green:0.78, blue:0.36, alpha:1.0),
            UIColor(red:0.48, green:0.78, blue:0.64, alpha:1.0),
            UIColor(red:0.30, green:0.76, blue:0.85, alpha:1.0),
            UIColor(red:0.58, green:0.39, blue:0.55, alpha:1.0)]
        intensity = 0.5
        type = .confetti
        active = false
    }

    @objc public func startConfetti() {
        emitter = CAEmitterLayer()

        emitter?.emitterPosition = CGPoint(x: frame.size.width / 2.0, y: 0)
        emitter?.emitterShape = CAEmitterLayerEmitterShape.line
        emitter?.emitterSize = CGSize(width: frame.size.width, height: 1)

        var cells = [CAEmitterCell]()
        
        guard let colors = self.colors else {
            return
        }
        
        for color in colors {
            if let confetti = confettiWithColor(color: color) {
                cells.append(confetti)
            }
        }

        emitter?.emitterCells = cells
        
        guard let emitter = emitter else {
            return
        }
        
        layer.addSublayer(emitter)
        active = true
    }

    @objc public func stopConfetti() {
        emitter?.birthRate = 0
        active = false
    }

    @objc public func setType(type: ConfettiType) {
        self.type = type
    }

    @objc public func setColors(colors: [UIColor]) {
        self.colors = colors
    }

    @objc public func setIntensity(intensity: Float) {
        self.intensity = intensity
    }

    @objc func imageForType(type: ConfettiType) -> UIImage? {

        var fileName: String!

        switch type {
        case .confetti:
            fileName = "confetti"
        case .triangle:
            fileName = "triangle"
        case .star:
            fileName = "star"
        case .diamond:
            fileName = "diamond"
        case .image:
            return customImage
        }

        let path = Bundle(for: SAConfettiView.self).path(forResource: "SAConfettiView", ofType: "bundle")
        let bundle = Bundle(path: path!)
        let imagePath = bundle?.path(forResource: fileName, ofType: "png")
        let url = URL(fileURLWithPath: imagePath!)
        do {
            let data = try Data(contentsOf: url)
            return UIImage(data: data)
        } catch {
            print(error)
        }
        return nil
    }

    @objc func confettiWithColor(color: UIColor) -> CAEmitterCell? {
        guard let intensity = self.intensity, let type = type else {
            return nil
        }
        
        let confetti = CAEmitterCell()
        confetti.birthRate = 6.0 * intensity
        confetti.lifetime = 14.0 * intensity
        confetti.lifetimeRange = 0
        confetti.color = color.cgColor
        confetti.velocity = CGFloat(350.0 * intensity)
        confetti.velocityRange = CGFloat(80.0 * intensity)
        confetti.emissionLongitude = CGFloat(Double.pi)
        confetti.emissionRange = CGFloat(Double.pi)
        confetti.spin = CGFloat(3.5 * intensity)
        confetti.spinRange = CGFloat(4.0 * intensity)
        confetti.scaleRange = CGFloat(intensity)
        confetti.scaleSpeed = CGFloat(-0.1 * intensity)
        confetti.contents = imageForType(type: type)?.cgImage
        return confetti
    }

    @objc public func isActive() -> Bool {
        return self.active ?? false
    }
}
