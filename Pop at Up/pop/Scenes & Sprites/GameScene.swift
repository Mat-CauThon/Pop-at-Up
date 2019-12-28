//
//  GameScene.swift
//  pop
//
//  Created by Roman Mishchenko on 7/6/19.
//  Copyright © 2019 Roman Mishchenko. All rights reserved.
//

import SpriteKit
import GameplayKit
import Foundation
import CoreData
import AVFoundation

class GameScene: SKScene {
    
    let context = PersistentService.persistentContainer.viewContext

    func saveData(shopState: Int32, sound: Bool, skin: Int16, money: Int32, score: Int32) {
        
        let moc = context
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PopModel")
        let result = try? moc.fetch(fetchRequest)
        let resultData = result as! [PopModel]
        for object in resultData {
            context.delete(object)
        }
        
        do {
            try context.save()
            print("saved!")
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        } catch {}
        
        let info = PopModel(entity: PopModel.entity(), insertInto: context)//MainInfo(entity: MainInfo.entity(), insertInto: context)
        
        
        
        info.score = score
        info.sound = sound
        info.shopState = shopState
        info.skin = skin
        info.money = money
        
        PersistentService.saveContext()
    }
//    var reclamCounter = 0
    var popListCount: Int = 0
    var popList: [Int: PopCircle] = [:]
    var pauseGame = false
    
    var sound: Bool = false
    var shopState: Int32 = 1
    var skinState: Int16 = 0
    var money = 0
    var savedMoney = 0
    
    var saveOnce = true
    var counter: Float = 0
    var reloadSpeed: Float = 10
    var reloadCount: Float = 0
    var scoreLabel: SKLabelNode!
    
    var ggLabel: SKLabelNode!
    var moneyLabel: SKLabelNode!
    var coin: SKSpriteNode!
    var newRecordLabel: SKLabelNode!
    var resultLabel: SKLabelNode!
    var pauseLabel: SKLabelNode!
    var reloadSprite: SKSpriteNode!
    var exitSprite: SKSpriteNode!
//    var reclamSprite: SKSpriteNode!
    var maxHP = 1
    var reloadHp = 0
    var myhp: [SKSpriteNode] = []
    var savedScore = 0
    var textrures: [SKTexture] = []
    
    
    
    func loadTexture() {
        
        var localTexture: [SKTexture] = []
        for i in 1...18 {
            let texture = SKTexture(imageNamed: "\(self.skinState+1) - \(i).png")
            localTexture.append(texture)
        }
        self.textrures = localTexture
    }
    
    
    var score: Int = 0 {
        didSet {
            scoreLabel.text = "\(score)"
        }
    }
   
   
  
    
    func setHpBar() {
        var floatI:CGFloat = 0.0
        for i in 0...(maxHP-1)
        {
            floatI = CGFloat(i)
            myhp.append(returnCircleHP())
            myhp.last!.position.x = (appDelegate.width*0.15)+(appDelegate.width*0.15)*floatI
            myhp.last!.position.y = appDelegate.height-(appDelegate.width*0.15)
            self.addChild(myhp.last!)
            
        }
    }
    
    func prepareGame(hp: Int, sound: Bool, shop: Int32, skin: Int16, globalMoney: Int32, globalScore: Int)
    {
        self.backgroundColor = .black
        self.sound = sound
        shopState = shop
        skinState = skin
        savedMoney = Int(globalMoney)
        savedScore = globalScore
        maxHP = hp
        reloadHp = hp
        loadTexture()
        
        
        setHpBar()
        
        pauseLabel = SKLabelNode(text: "II")
        pauseLabel.name = "Pause"
        pauseLabel.fontName = "BPreplay"
        pauseLabel.fontSize = appDelegate.width * 0.09
        pauseLabel.fontColor = UIColor.white
        pauseLabel.position = CGPoint(x: (appDelegate.width*0.15), y: (appDelegate.width*0.15))
        self.addChild(pauseLabel)
        
        
        scoreLabel = SKLabelNode(text: "0")
        scoreLabel.fontName = "BPreplay"
        scoreLabel.fontSize = appDelegate.width * 0.09
        scoreLabel.name = "Score"
        scoreLabel.fontColor = UIColor.white
        scoreLabel.position = CGPoint(x: appDelegate.width - (appDelegate.width*0.15), y: appDelegate.height - (appDelegate.width*0.185))
        if reloadHp != 1 {
            scoreLabel.fontColor = self.backgroundColor
        }
        self.addChild(scoreLabel)
        
    }
    
    func returnCircleHP()->SKSpriteNode
    {
        let circle = SKSpriteNode(imageNamed: "heart0.png", normalMapped: false)
        circle.size = CGSize(width: appDelegate.width/7, height: appDelegate.width/8)
        circle.name = "hpCircle"
        return circle
    }
    
    
    override func sceneDidLoad() {
        
       startGame()
        
    }
    
   
   
   
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       
        let touch = touches.first
        var onlyOnce = true
        if let location = touch?.location(in: self) {
        
            let nodesArray = self.nodes(at: location)
                    
            let name = nodesArray.first?.name!
            if name == "Pause" {
                
                if isPaused {
                    
                    var runCount = 3
                    self.ggLabel = SKLabelNode(text: "\(runCount)")
                    self.ggLabel.fontName = "BPreplay"
                    self.ggLabel.fontSize = appDelegate.width * 0.3
                    self.ggLabel.zPosition = 100
                    self.ggLabel.name = "GG"
                    self.pauseLabel.name = "Pause Off"
                    self.ggLabel.fontColor = UIColor.white
                    self.ggLabel.position = CGPoint(x: appDelegate.width/2, y: appDelegate.height/2)
                    self.addChild(ggLabel)
                    var _ = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                        self.ggLabel.text = "\(runCount)"
                        
                        if self.sound {
                            let path = Bundle.main.path(forResource: "pop.wav", ofType:nil)!
                            let url = URL(fileURLWithPath: path)

                            do {
                                bombSoundEffect = try AVAudioPlayer(contentsOf: url)
                                bombSoundEffect?.play()
                            } catch {
                                print("Audio don't load \(error)")
                            }
                        }
                        
                        if runCount == 0 {
                            self.pauseLabel.name = "Pause"
                            self.pauseLabel.text = "II"
                            timer.invalidate()
                            self.ggLabel.removeFromParent()
                            self.isPaused.toggle()
                            self.pauseGame.toggle()
                        }
                        runCount -= 1
                    }
                    
                } else {
                    
                    if self.sound {
                        let path = Bundle.main.path(forResource: "pop.wav", ofType:nil)!
                        let url = URL(fileURLWithPath: path)

                        do {
                            bombSoundEffect = try AVAudioPlayer(contentsOf: url)
                            bombSoundEffect?.play()
                        } catch {
                            print("Audio don't load \(error)")
                        }
                    }
                    
                    if self.ggLabel != nil {
                        self.ggLabel.text = ""
                        self.ggLabel.removeFromParent()
                    }
                    
                    self.pauseLabel.text = "▶︎"
                    isPaused.toggle()
                    pauseGame.toggle()
                    
                }
                
            }
            let fullNameArr = name?.components(separatedBy: " ")
            
                    
            if fullNameArr?[0] == "circle" && !isPaused {
                
                if self.sound {
                    let path = Bundle.main.path(forResource: "pop.wav", ofType:nil)!
                    let url = URL(fileURLWithPath: path)

                    do {
                        bombSoundEffect = try AVAudioPlayer(contentsOf: url)
                        bombSoundEffect?.play()
                    } catch {
                        print("Audio don't load \(error)")
                    }
                }
                
                score += 10
                self.popList[Int((fullNameArr?[1])!)!]!.circle.removeFromParent()
                self.popList.removeValue(forKey: Int((fullNameArr?[1])!)!)
                onlyOnce = false
            }
            else if nodesArray.first?.name == "reloadGame" {
                
                if self.sound {
                    let path = Bundle.main.path(forResource: "pop.wav", ofType:nil)!
                    let url = URL(fileURLWithPath: path)

                    do {
                        bombSoundEffect = try AVAudioPlayer(contentsOf: url)
                        bombSoundEffect?.play()
                    } catch {
                        print("Audio don't load \(error)")
                    }
                }
                
//                reclamCounter += 1
                myhp.removeAll()
                self.removeAllChildren()
                self.popList.removeAll()
                self.addChild(scoreLabel)
                self.addChild(pauseLabel)
                
                maxHP = reloadHp
                score = 0
                counter = 0
                saveOnce = true
                popListCount = 0
                
                setHpBar()
                startGame()
                
                
            } else if nodesArray.first?.name == "exitGame" {
                
                if self.sound {
                    let path = Bundle.main.path(forResource: "pop.wav", ofType:nil)!
                    let url = URL(fileURLWithPath: path)

                    do {
                        bombSoundEffect = try AVAudioPlayer(contentsOf: url)
                        bombSoundEffect?.play()
                    } catch {
                        print("Audio don't load \(error)")
                    }
                }
                
                if let scene = SKScene(fileNamed: "Menu") {
                    
                  
                    
                    if let view = self.view {
                        let transition = SKTransition.fade(withDuration: 0.5)
                        view.presentScene(scene, transition: transition)
                        
                        view.ignoresSiblingOrder = true
                        
                       
                    }
                    
                }
                
            }
//            else if nodesArray.first?.name == "showMovie" {
//
//                if self.sound {
//                    let path = Bundle.main.path(forResource: "pop.wav", ofType:nil)!
//                    let url = URL(fileURLWithPath: path)
//
//                    do {
//                        bombSoundEffect = try AVAudioPlayer(contentsOf: url)
//                        bombSoundEffect?.play()
//                    } catch {
//                        print("Audio don't load \(error)")
//                    }
//                }
//
//                MARK: INSERT RECLAM
//
//                let bonusMoney = 20
//
//                let moc = context
//                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PopModel")
//                let result = try? moc.fetch(fetchRequest)
//                let resultData = result as! [PopModel]
//                for object in resultData {
//
//                    moc.delete(object)
//                }
//
//                do {
//                    try context.save()
//                    print("saved!")
//                } catch let error as NSError {
//                    print("Could not save \(error), \(error.userInfo)")
//                } catch {}
//
//                let info = PopModel(entity: PopModel.entity(), insertInto: context)//MainInfo(entity: MainInfo.entity(), insertInto: context)
//                info.score = Int32(self.savedScore)//score)
//                info.sound = self.sound
//                info.shopState = self.shopState
//                info.skin = self.skinState
//                self.savedMoney = self.savedMoney + bonusMoney
//                info.money = Int32(self.savedMoney)
//                PersistentService.saveContext()
//                self.moneyLabel.text = "You got \(self.money+bonusMoney)"
//                self.reclamSprite.removeFromParent()
//                self.reclamCounter = 0
//
//            }
            else if onlyOnce && maxHP > 0 && !isPaused {
                
                //spawn enemy
                self.popListCount += 1
                self.popList[self.popListCount] = PopCircle.init(max: Int.random(in: 1..<5), time: CGFloat(Int.random(in: 3..<7)), number: self.popListCount)
                self.addChild(self.popList[self.popListCount]!.circle)
                
                
                let animations = self.popList[self.popListCount]?.getAnimation(textures: self.textrures)
                let group = SKAction.group([animations!.scale, animations!.texture])
                let iCount = self.popListCount
                self.popList[self.popListCount]?.circle.run(group) { [iCount] in
                    
                    
                    if self.maxHP > 0 {
                        
                        
                        let Image = UIImage(named: "heart1.png")
                                                   
                        self.myhp[self.maxHP-1].texture = SKTexture(image: Image!)
                        self.maxHP -= 1
                        self.popList[iCount]?.circle.removeFromParent()
                        self.popList.removeValue(forKey: iCount)
                    }
                    
                    
                }
            }
            
        }
                    
                
     
        
    }
    
     
    
    func startGame() {
        
        var _ = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { timer in
            
            self.isPaused = self.pauseGame
           
            self.reloadCount = 1000/(abs(Float((self.score+100)/2)*cos(Float((self.score+100)/2))) + abs(Float((self.score+100)/2)*sin(Float((self.score+100)/2))))
//            print(self.reloadCount)
            
            if self.maxHP > 0 && !self.isPaused {
                
              
                self.counter += 1
              
                if self.counter > self.reloadCount {
                    self.counter = 0
                    //spawn enemy
                    self.popListCount += 1
                    self.popList[self.popListCount] = PopCircle.init(max: Int.random(in: 1..<5), time: CGFloat(Int.random(in: 3..<7)), number: self.popListCount)
                    self.addChild(self.popList[self.popListCount]!.circle)
                    
                    
                    let animations = self.popList[self.popListCount]?.getAnimation(textures: self.textrures)
                    let group = SKAction.group([animations!.scale, animations!.texture])
                    let iCount = self.popListCount
                    self.popList[self.popListCount]?.circle.run(group) { [iCount] in
                        
                        
                        if self.maxHP > 0 {
                            let Image = UIImage(named: "heart1.png")
                                                       
                            self.myhp[self.maxHP-1].texture = SKTexture(image: Image!)
                            self.maxHP -= 1
                            self.popList[iCount]?.circle.removeFromParent()
                            self.popList.removeValue(forKey: iCount)
                        }
                        
                        
                    }
                    
                }
            } else if !self.isPaused {
                
                
                if self.sound {
                    let path = Bundle.main.path(forResource: "lose.wav", ofType:nil)!
                    let url = URL(fileURLWithPath: path)

                    do {
                        bombSoundEffect = try AVAudioPlayer(contentsOf: url)
                        bombSoundEffect?.play()
                    } catch {
                        print("Audio don't load \(error)")
                    }
                }
                
                self.removeAllChildren()
                self.popList.removeAll()
                
                for i in self.popList.keys {
                    self.popList[i]?.circle.removeAllActions()
                }
                
                self.money = 1 + self.score / 100
                if self.money > 0 {
                    self.money = 1+Int.random(in: self.money/2..<self.money)
                }
                
                self.ggLabel = SKLabelNode(text: "Game Over")
                self.ggLabel.fontName = "BPreplay"
                self.ggLabel.name = "ggLabel"
                self.ggLabel.fontSize = appDelegate.width * 0.15
                self.ggLabel.fontColor = UIColor.white
                self.ggLabel.position = CGPoint(x: appDelegate.width/2, y: appDelegate.height/2)
                self.addChild(self.ggLabel)
                
                self.moneyLabel = SKLabelNode(text: "You got \(self.money)")
                self.moneyLabel.fontName = "BPreplay"
                self.moneyLabel.fontSize = appDelegate.width * 0.08
                self.moneyLabel.fontColor = UIColor.white
                self.moneyLabel.name = "coin"
                
                self.moneyLabel.position = CGPoint(x: appDelegate.width/2, y: appDelegate.height/2 - appDelegate.height*0.1)
                self.addChild(self.moneyLabel)
                self.coin = SKSpriteNode(imageNamed: "coin.png", normalMapped: false)
                self.coin.size = CGSize(width: 1.5*appDelegate.width/15, height: 1.5*appDelegate.width/15)
                self.coin.anchorPoint = CGPoint(x: 0.5, y: 0.5)
                
                self.coin.position = CGPoint(x: appDelegate.width/2 + self.moneyLabel.frame.size.width*0.8, y: appDelegate.height/2 - appDelegate.height*0.088)
                self.coin.name = "coin"
                self.coin.zPosition = 100
                self.addChild(self.coin)
                
//                MARK: SET TO 5-6
//                if self.reclamCounter > 0 {
//                    self.reclamCounter = 0
//
//                    self.reclamSprite = SKSpriteNode(imageNamed: "movie.png", normalMapped: false)
//                    self.reclamSprite.size = CGSize(width: 1.5*self.width/8, height: 1.5*self.width/10)
//                    self.reclamSprite.position = CGPoint(x: self.width/2, y: self.height*0.15)
//                    self.reclamSprite.name = "showMovie"
//                    self.reclamSprite.anchorPoint = CGPoint(x: 0.5, y: 0.5)
//                    self.reclamSprite.zPosition = 100
//                    self.addChild(self.reclamSprite)
//                }
                
                
                self.reloadSprite = SKSpriteNode(imageNamed: "replay.png", normalMapped: false)
                self.reloadSprite.size = CGSize(width: 1.5*appDelegate.width/10, height: 1.5*appDelegate.width/10)
                
                self.reloadSprite.position = CGPoint(x: appDelegate.width/2 + appDelegate.width*0.3, y: appDelegate.height*0.15)
                self.reloadSprite.name = "reloadGame"
                self.reloadSprite.anchorPoint = CGPoint(x: 0.5, y: 0.5)
                self.reloadSprite.zPosition = 100
                self.addChild(self.reloadSprite)
                
                self.exitSprite = SKSpriteNode(imageNamed: "home.png", normalMapped: false)
                self.exitSprite.size = CGSize(width: 1.5*appDelegate.width/10, height: 1.5*appDelegate.width/10)
                self.exitSprite.position = CGPoint(x: appDelegate.width/2 - appDelegate.width*0.3, y: appDelegate.height*0.15)
                self.exitSprite.name = "exitGame"
                self.exitSprite.anchorPoint = CGPoint(x: 0.5, y: 0.5)
                self.exitSprite.zPosition = 100
                self.addChild(self.exitSprite)
                
                
                
                
                if(self.reloadHp == 1) {
                    
                    self.resultLabel = SKLabelNode(text: "Your result: \(self.score)")
                    self.resultLabel.fontName = "BPreplay"
                    self.resultLabel.fontSize = appDelegate.width * 0.09
                    self.resultLabel.name = "Score Result"
                    self.resultLabel.fontColor = UIColor.white
                    self.resultLabel.position = CGPoint(x: appDelegate.width/2, y: appDelegate.height/2 + appDelegate.height*0.3)
                    self.addChild(self.resultLabel)
                    
                    if self.score > self.savedScore {
                        
                        self.newRecordLabel = SKLabelNode(text: "New Record")
                        self.newRecordLabel.fontName = "BPreplay"
                        self.newRecordLabel.fontSize = appDelegate.width * 0.09
                        self.newRecordLabel.name = "New Record"
                        self.newRecordLabel.fontColor = UIColor.white
                        self.newRecordLabel.position = CGPoint(x: appDelegate.width/2, y: appDelegate.height/2 + appDelegate.height*0.15)
                        self.addChild(self.newRecordLabel)
                    }
                    self.savedScore = max(self.score, self.savedScore)
                }
                
                self.savedMoney = self.money + self.savedMoney
                self.saveData(shopState: self.shopState, sound: self.sound, skin: self.skinState, money: Int32(self.savedMoney), score: Int32(self.savedScore))
                
                timer.invalidate()
                
                
            }
            
            
        }
    }
}
