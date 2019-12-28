//
//  PopModel+CoreDataProperties.swift
//  pop
//
//  Created by Roman Mishchenko on 28.10.2019.
//  Copyright © 2019 Roman Mishchenko. All rights reserved.
//
//

import Foundation
import CoreData


extension PopModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PopModel> {
        return NSFetchRequest<PopModel>(entityName: "PopModel")
    }

    @NSManaged public var money: Int32
    @NSManaged public var score: Int32
    @NSManaged public var shopState: Int32
    @NSManaged public var skin: Int16
    @NSManaged public var sound: Bool

}
