//
//  AppDelegate.swift
//  pop
//
//  Created by Roman Mishchenko on 7/6/19.
//  Copyright © 2019 Roman Mishchenko. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var orientationLock = UIInterfaceOrientationMask.all
    var width = UIScreen.main.bounds.size.width
    var height = UIScreen.main.bounds.size.height
    var gameScene: GameScene? = nil
    


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
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return self.orientationLock
    }
    struct AppUtility {
        static func lockOrientation(_ orientation: UIInterfaceOrientationMask) {
            if let delegate = UIApplication.shared.delegate as? AppDelegate {
                delegate.orientationLock = orientation
            }
        }
        
        static func lockOrientation(_ orientation: UIInterfaceOrientationMask, andRotateTo rotateOrientation:UIInterfaceOrientation) {
            self.lockOrientation(orientation)
            UIDevice.current.setValue(rotateOrientation.rawValue, forKey: "orientation")
        }
    }
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        
        
        #if targetEnvironment(macCatalyst)
        
            width = 800
            height = 1200
            UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }.forEach { windowScene in
                windowScene.sizeRestrictions?.minimumSize = CGSize(width: width, height: height)
                windowScene.sizeRestrictions?.maximumSize = CGSize(width: width, height: height)
            }
        #endif
        
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        if gameScene?.ggLabel != nil {
            gameScene?.ggLabel.text = ""
            gameScene?.ggLabel.removeFromParent()
        }
        
        gameScene?.pauseLabel.text = "▶︎"
        gameScene?.pauseGame = true
        
        
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
//        saveData(shopState: gameScene.shopState, sound: gameScene.sound, skin: gameScene.skinState, money: Int32(gameScene.savedMoney), score: Int32(gameScene.savedScore))
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
//        gameScene =
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
      
    }

    
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
       
    }


}

