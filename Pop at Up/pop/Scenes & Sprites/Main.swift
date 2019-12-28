//
//  Main.swift
//  pop
//
//  Created by Roman Mishchenko on 7/9/19.
//  Copyright © 2019 Roman Mishchenko. All rights reserved.
//

import SpriteKit
import CoreData
import AVFoundation

class Main: SKScene {
   
    var mainInfo = [PopModel]()
    
    
    
    var recordLabel: SKLabelNode!
    var surviveLabel: SKLabelNode!
    var arcadeLabel: SKLabelNode!
    var shopLabel: SKLabelNode!
    var popUp: SKSpriteNode!
    var sound: SKSpriteNode!
//    var width = UIScreen.main.bounds.size.width
//    var height = UIScreen.main.bounds.size.height
    var trophy: SKSpriteNode!
    
    var menuSound = NSURL(fileURLWithPath: Bundle.main.path(forResource: "menuSound", ofType: "mp3")!)
    
    
    override func didMove(to view: SKView) {
        
        
        
        
        
        popUp = (self.childNode(withName: "popUp") as! SKSpriteNode)
        popUp.size.width = appDelegate.width - appDelegate.width/2.9
        popUp.size.height = appDelegate.width - appDelegate.width/2.9
        popUp.position = CGPoint(x: appDelegate.width/2, y: appDelegate.height - appDelegate.height/4)
        
        self.backgroundColor = .black

        surviveLabel = SKLabelNode(text: "Survive")
        surviveLabel.fontName = "BPreplay"
        surviveLabel.fontSize = appDelegate.width * 0.1
        surviveLabel.name = "survive"
        surviveLabel.fontColor = UIColor.white
        surviveLabel.position = CGPoint(x: appDelegate.width/2 , y: popUp.position.y - popUp.frame.size.height/2 - appDelegate.height*0.09)
        self.addChild(surviveLabel)
        
        arcadeLabel = SKLabelNode(text: "Arcade")
        arcadeLabel.fontName = "BPreplay"
        arcadeLabel.fontSize = appDelegate.width * 0.1
        arcadeLabel.name = "arcade"
        arcadeLabel.fontColor = UIColor.white
        arcadeLabel.position = CGPoint(x: appDelegate.width/2 , y: surviveLabel.position.y - surviveLabel.frame.size.height/2 - appDelegate.height*0.09)
        self.addChild(arcadeLabel)
        
        shopLabel = SKLabelNode(text: "Shop")
        shopLabel.fontName = "BPreplay"
        shopLabel.fontSize = appDelegate.width * 0.1
        shopLabel.name = "shop"
        shopLabel.fontColor = UIColor.white
        shopLabel.position = CGPoint(x: appDelegate.width/2 , y: arcadeLabel.position.y - arcadeLabel.frame.size.height/2 - appDelegate.height*0.09)
        self.addChild(shopLabel)
        
        recordLabel = (self.childNode(withName: "record") as! SKLabelNode)
        recordLabel.position = CGPoint(x: appDelegate.width/2, y: appDelegate.height*0.12)
        recordLabel.fontSize = appDelegate.width * 0.06
        recordLabel.fontColor = UIColor.white
        recordLabel.fontName = "BPreplay"
        
        trophy = SKSpriteNode(imageNamed: "trophy.png", normalMapped: false)
        trophy.size = CGSize(width: appDelegate.height*0.06, height: appDelegate.height*0.06)
        trophy.position = CGPoint(x: appDelegate.width/2, y: appDelegate.height*0.07)
        trophy.name = "trophy"
        self.addChild(trophy)
        
        
        
        do {
            mainInfo = try appDelegate.context.fetch(PopModel.fetchRequest())
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        if mainInfo.count < 1 {
            appDelegate.saveData(shopState: 1, sound: true, skin: 0, money: 0, score: 0)
            do {
                mainInfo = try appDelegate.context.fetch(PopModel.fetchRequest())
            } catch let error as NSError {
                print("Could not fetch \(error), \(error.userInfo)")
            }
        }
        
    
        recordLabel.text = String(mainInfo.first!.score)
       
        if mainInfo.first!.sound {
            
            sound = SKSpriteNode(imageNamed: "sound_on.png", normalMapped: false)
            menuSoundEffect?.play()
        } else {
            
            sound = SKSpriteNode(imageNamed: "sound_off.png", normalMapped: false)
            menuSoundEffect?.stop()
        }
        
        sound.size = CGSize(width: appDelegate.height*0.06, height: appDelegate.height*0.06)
        sound.position = CGPoint(x: appDelegate.height*0.07, y: appDelegate.height*0.07)
        sound.name = "sound"
        self.addChild(sound)
          
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if let location = touch?.location(in: self) {
            
            let nodesArray = self.nodes(at: location)
            
            if nodesArray.first?.name == "survive" {
                
                if mainInfo.first?.sound ?? true {
                    let path = Bundle.main.path(forResource: "pop.wav", ofType:nil)!
                    let url = URL(fileURLWithPath: path)

                    do {
                        bombSoundEffect = try AVAudioPlayer(contentsOf: url)
                        bombSoundEffect?.play()
                    } catch {
                        print("Audio don't load \(error)")
                    }
                }
                
                menuSoundEffect?.stop()
                
                
                let transition = SKTransition.fade(withDuration: 0.7)
                
                appDelegate.gameScene = GameScene(size: CGSize(width: appDelegate.width, height: appDelegate.height))
                appDelegate.gameScene!.prepareGame(hp: 1, sound: mainInfo.first?.sound ?? true, shop: mainInfo.first?.shopState ?? 1, skin: mainInfo.first?.skin ?? 0, globalMoney: mainInfo.first?.money ?? 0, globalScore: Int(mainInfo.first?.score ?? 0))
                self.view?.presentScene(appDelegate.gameScene!, transition: transition)
                
            } else if nodesArray.first?.name == "arcade" {
                
                if mainInfo.first?.sound ?? true {
                    let path = Bundle.main.path(forResource: "pop.wav", ofType:nil)!
                    let url = URL(fileURLWithPath: path)

                    do {
                        bombSoundEffect = try AVAudioPlayer(contentsOf: url)
                        bombSoundEffect?.play()
                    } catch {
                        print("Audio don't load \(error)")
                    }
                }
                
                menuSoundEffect?.stop()
                let transition = SKTransition.fade(withDuration: 0.7)
//                let gameScene = GameScene(size: CGSize(width: appDelegate.width, height: appDelegate.height))
                appDelegate.gameScene = GameScene(size: CGSize(width: appDelegate.width, height: appDelegate.height))
                appDelegate.gameScene!.prepareGame(hp: 3, sound: mainInfo.first?.sound ?? true, shop: mainInfo.first?.shopState ?? 1, skin: mainInfo.first?.skin ?? 1, globalMoney: mainInfo.first?.money ?? 0, globalScore: Int(mainInfo.first?.score ?? 0))
                self.view?.presentScene(appDelegate.gameScene!, transition: transition)
                
            } else if nodesArray.first?.name == "shop" {
                
                if mainInfo.first?.sound ?? true {
                    let path = Bundle.main.path(forResource: "pop.wav", ofType:nil)!
                    let url = URL(fileURLWithPath: path)

                    do {
                        bombSoundEffect = try AVAudioPlayer(contentsOf: url)
                        bombSoundEffect?.play()
                    } catch {
                        print("Audio don't load \(error)")
                    }
                }
                
                let shopScene = ShopScene(size: CGSize(width: appDelegate.width, height: appDelegate.height))
                let transition = SKTransition.fade(withDuration: 0.7)
                shopScene.prepare(shopState: mainInfo.first?.shopState ?? 1, sound: mainInfo.first?.sound ?? true, skin: mainInfo.first?.skin ?? 0, globalMoney: mainInfo.first?.money ?? 0, globalScore: Int(mainInfo.first?.score ?? 0))
                self.view?.presentScene(shopScene, transition: transition)
            } else if nodesArray.first?.name == "sound" {
                if mainInfo[0].sound {
                    mainInfo[0].sound = false
                    
                    appDelegate.saveData(shopState: mainInfo[0].shopState, sound: false, skin: mainInfo[0].skin, money: mainInfo[0].money, score: mainInfo[0].score)
                    do {
                        mainInfo = try appDelegate.context.fetch(PopModel.fetchRequest())
                    } catch let error as NSError {
                        print("Could not fetch \(error), \(error.userInfo)")
                    }
                    
                    menuSoundEffect?.stop()
                    sound.removeFromParent()
                    sound = SKSpriteNode(imageNamed: "sound_off.png", normalMapped: false)
                    sound.size = CGSize(width: appDelegate.height*0.06, height: appDelegate.height*0.06)
                    sound.position = CGPoint(x: appDelegate.height*0.07, y: appDelegate.height*0.07)
                    sound.name = "sound"
                    self.addChild(sound)
                    
                } else {
                    menuSoundEffect?.play()
                    
                    mainInfo[0].sound = true
                    
                    appDelegate.saveData(shopState: mainInfo[0].shopState, sound: true, skin: mainInfo[0].skin, money: mainInfo[0].money, score: mainInfo[0].score)
                    do {
                        mainInfo = try appDelegate.context.fetch(PopModel.fetchRequest())
                    } catch let error as NSError {
                        print("Could not fetch \(error), \(error.userInfo)")
                    }
                    
                    sound.removeFromParent()
                    sound = SKSpriteNode(imageNamed: "sound_on.png", normalMapped: false)
                    sound.size = CGSize(width: appDelegate.height*0.06, height: appDelegate.height*0.06)
                    sound.position = CGPoint(x: appDelegate.height*0.07, y: appDelegate.height*0.07)
                    sound.name = "sound"
                    self.addChild(sound)
                }
                
                
                
                
                
            }
        }
    }
}
