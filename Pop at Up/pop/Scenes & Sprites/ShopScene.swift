//
//  ShopScene.swift
//  pop
//
//  Created by Roman Mishchenko on 9/21/19.
//  Copyright © 2019 Roman Mishchenko. All rights reserved.
//


import SpriteKit
import CoreData
import AVFoundation

class ShopScene: SKScene {

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
    
    var nodes: [SKSpriteNode] = []
    var textures: [[SKTexture]] = []
    var circle: SKSpriteNode!
    var shopState = 1
    var buyButtonArray: [SKLabelNode] = []
    

    var shopLabel: SKLabelNode!
    var moneyLabel: SKLabelNode!
    var costLabel: SKLabelNode!
    var backButton: SKLabelNode!
    var selected: Int = 0
    var money: Int!
    var score: Int!
    var sound: Bool!
    
    
    
    func prepare(shopState: Int32, sound: Bool, skin: Int16, globalMoney: Int32, globalScore: Int) {
        
        let positionX = Int(appDelegate.width/4)
        var positionY = Int(appDelegate.height - appDelegate.width/8)
        self.backgroundColor = .black
        self.selected = Int(skin)
        self.shopState = Int(shopState)
        self.money = Int(globalMoney)
        self.score = globalScore
        self.sound = sound
        
        shopLabel = SKLabelNode(text: "Welcome to the shop")
        shopLabel.fontName = "BPreplay"
        shopLabel.name = "shop label"
        shopLabel.fontSize = appDelegate.width * 0.09
        shopLabel.fontColor = UIColor.white
        shopLabel.position = CGPoint(x: appDelegate.width/2 , y: appDelegate.height - appDelegate.height*0.08)
        self.addChild(shopLabel)
        
        
        moneyLabel = SKLabelNode(text: "You have \(money!) coins")
        moneyLabel.fontName = "BPreplay"
        moneyLabel.fontSize = appDelegate.width * 0.06
        moneyLabel.name = "money label"
        moneyLabel.fontColor = UIColor.white
        moneyLabel.position = CGPoint(x: appDelegate.width/2 , y: appDelegate.height - (shopLabel.frame.height + appDelegate.height*0.09 ) )
        self.addChild(moneyLabel)
        
        costLabel = SKLabelNode(text: "All costs 100 coins")
        costLabel.fontName = "BPreplay"
        costLabel.name = "cost"
        costLabel.fontSize = appDelegate.width * 0.05
        costLabel.fontColor = UIColor.white
        costLabel.position = CGPoint(x: appDelegate.width/2 , y: appDelegate.height - (shopLabel.frame.height + appDelegate.height*0.13 ) )
        self.addChild(costLabel)
        
        backButton = SKLabelNode(text: "Back")
        backButton.name = "Back"
        backButton.fontName = "BPreplay"
        backButton.fontSize = appDelegate.width * 0.09
        backButton.fontColor = UIColor.white
        backButton.position = CGPoint(x: appDelegate.width/2 , y: appDelegate.height*0.08)
        self.addChild(backButton)
        
        positionY = Int(appDelegate.height - (shopLabel.frame.height + appDelegate.height*0.08))
        
        for skinNumber in 1...4 {
            
            positionY = positionY - Int(appDelegate.width/4.5)
            circle = SKSpriteNode(imageNamed: "1 - 1.png", normalMapped: false)
            circle.size = CGSize(width: appDelegate.width/8, height: appDelegate.width/8)
            circle.position = CGPoint(x: positionX, y: positionY)
            circle.name = "circle"
            nodes.append(circle)
            self.scene?.addChild(nodes.last!)
            var localTexture: [SKTexture] = []
                   for i in 1...18 {
                       let texture = SKTexture(imageNamed: "\(skinNumber) - \(i).png")
                       localTexture.append(texture)
                   }
            localTexture += localTexture.reversed()
            textures.append(localTexture)
            let animation = SKAction.animate(with: textures[skinNumber-1], timePerFrame: 0.1)
            nodes[skinNumber-1].run(SKAction.repeatForever(animation))
            
            let newButton: SKLabelNode
            if self.shopState & (1<<(skinNumber-1)) > 0 {
                newButton = SKLabelNode(text: "Select")
                newButton.name = "Select \(skinNumber-1)"
            } else {
                newButton = SKLabelNode(text: "Get it")
                newButton.name = "Buy \(skinNumber-1)"
            }
            newButton.fontName = "BPreplay"
            newButton.fontSize = appDelegate.width * 0.06
            
            newButton.fontColor = UIColor.white
            newButton.position = CGPoint(x: Int(appDelegate.width) - positionX, y: positionY - Int(appDelegate.height*0.01))
            newButton.zPosition = 100
            buyButtonArray.append(newButton)
            self.scene?.addChild(buyButtonArray.last!)
            
        }
        print(selected)
        buyButtonArray[selected].text = "Selected"
        buyButtonArray[selected].name = "Diselect \(selected)"
    }
    
   
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    
        
        let touch = touches.first
        if let location = touch?.location(in: self) {
     
            let nodesArray = self.nodes(at: location)
            let name = nodesArray.first?.name!
            let fullNameArr = name?.components(separatedBy: " ")
            if fullNameArr?[0] == "Buy" {
                if(buyButtonArray[Int((fullNameArr?[1])!)!].text == "Get it") && money >= 100 {
                    
                    if sound {
                        let path = Bundle.main.path(forResource: "pop.wav", ofType:nil)!
                        let url = URL(fileURLWithPath: path)

                        do {
                            bombSoundEffect = try AVAudioPlayer(contentsOf: url)
                            bombSoundEffect?.play()
                        } catch {
                            print("Audio don't load \(error)")
                        }
                    }
                    
                    buyButtonArray[Int((fullNameArr?[1])!)!].name = "Select \(Int((fullNameArr?[1])!)!)"
                    buyButtonArray[Int((fullNameArr?[1])!)!].text = "Select"
                   
                    shopState = shopState | (1 << Int((fullNameArr?[1])!)!)
                    money -= 100
                    moneyLabel.text = "You have \(money!) coins"
                    saveData(shopState: Int32(shopState), sound: sound, skin: Int16(selected), money: Int32(money), score: Int32(score))
                    
                } else if (buyButtonArray[Int((fullNameArr?[1])!)!].text == "Get it") {
                    if sound {
                        let path = Bundle.main.path(forResource: "lose.wav", ofType:nil)!
                        let url = URL(fileURLWithPath: path)

                        do {
                            bombSoundEffect = try AVAudioPlayer(contentsOf: url)
                            bombSoundEffect?.play()
                        } catch {
                            print("Audio don't load \(error)")
                        }
                    }
                }
                
            } else if fullNameArr?[0] == "Select" {
                if buyButtonArray[Int((fullNameArr?[1])!)!].text == "Select" {
                    
                    if sound {
                        let path = Bundle.main.path(forResource: "pop.wav", ofType:nil)!
                        let url = URL(fileURLWithPath: path)

                        do {
                            bombSoundEffect = try AVAudioPlayer(contentsOf: url)
                            bombSoundEffect?.play()
                        } catch {
                            print("Audio don't load \(error)")
                        }
                    }
                    
                    buyButtonArray[Int((fullNameArr?[1])!)!].text = "Selected"
                    buyButtonArray[Int((fullNameArr?[1])!)!].name = "Diselect \(Int((fullNameArr?[1])!)!)"
                    buyButtonArray[selected].name = "Select \(selected)"
                    buyButtonArray[selected].text = "Select"
                    selected = Int((fullNameArr?[1])!)!
                    print("----------")
                    print(Int16(selected))
                    print("----------")
                    saveData(shopState: Int32(shopState), sound: sound, skin: Int16(selected), money: Int32(money), score: Int32(score))
                }
            } else if fullNameArr?[0] == "Back" {
                
                if sound {
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
            
            
        }
    }
    

}
