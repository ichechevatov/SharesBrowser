//
//  Price+CoreDataProperties.swift
//  
//
//  Created by Илья Че on 07.04.2021.
//
//

import Foundation
import CoreData


extension Price {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Price> {
        return NSFetchRequest<Price>(entityName: "Price")
    }

    @NSManaged public var currentPrice: Double
    @NSManaged public var openPriceOfTheDay: Double
    @NSManaged public var symbol: Symbol?

}
