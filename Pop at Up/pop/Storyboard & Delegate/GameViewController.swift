//
//  GameViewController.swift
//  pop
//
//  Created by Roman Mishchenko on 7/6/19.
//  Copyright © 2019 Roman Mishchenko. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import AVFoundation
class GameViewController: UIViewController {
    
    
    

    enum ValidationError: Error {
        case loadAudio
    }
    
    override func viewWillAppear(_ animated: Bool) {
        AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load 'GameScene.sks' as a GKScene. This provides gameplay related content
        // including entities and graphs.
        if let scene = SKScene(fileNamed: "Menu") {
            
            let path = Bundle.main.path(forResource: "menuSound.mp3", ofType:nil)!
            let url = URL(fileURLWithPath: path)

            do {
                menuSoundEffect = try AVAudioPlayer(contentsOf: url)
                menuSoundEffect?.numberOfLoops = 10
//                menuSoundEffect?.play()
            } catch {
                print("Audio don't load \(error)")
            }
                
                // Present the scene
                
                if let view = self.view as! SKView? {
                    let transition = SKTransition.fade(withDuration: 0.8)
                    view.presentScene(scene, transition: transition)
                    
                    view.ignoresSiblingOrder = true
//                    view.showsFPS = true
                }
        }
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
