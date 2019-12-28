//
//  CircleClass.swift
//  pop
//
//  Created by Roman Mishchenko on 7/6/19.
//  Copyright © 2019 Roman Mishchenko. All rights reserved.
//

import SpriteKit


class PopCircle {
    
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let maxScale: Int
    public var circle: SKSpriteNode!
    private let duration: CGFloat
    private var notAnimated = true
    private var scaleAnimation: SKAction!
    private var animation: SKAction!
    private var durate = TimeInterval.random(in: 3.1..<6.1)
    
    func getAnimation(textures: [SKTexture]) -> (scale: SKAction, texture: SKAction) {
        notAnimated = false
        animation = SKAction.animate(with: textures,
                                     timePerFrame: (durate-0.65)/18,
                                     resize: false,
                                     restore: false)
        return (scaleAnimation, animation)
    }
    
    init(max: Int, time: CGFloat, number: Int) {
        maxScale = max
        duration = time
        scaleAnimation = SKAction(named: "scaleCircle\(maxScale)", duration: durate)
        
        
        
        
        circle = SKSpriteNode(imageNamed: "1 - 1.png", normalMapped: false)
        
        circle.position = CGPoint.init(x: Int.random(in: Int(appDelegate.width*0.2)..<(Int(appDelegate.width-(appDelegate.width*0.2)))) , y: Int.random(in: Int(appDelegate.height*0.2)..<(Int(appDelegate.height - (appDelegate.height*0.2)))))
        circle.size = CGSize(width: appDelegate.width/14, height: appDelegate.width/14)
        circle.name = "circle \(number)"

        
    }
    
}
