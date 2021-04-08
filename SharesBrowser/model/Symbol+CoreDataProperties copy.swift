//
//  Symbol+CoreDataProperties.swift
//  
//
//  Created by Илья Че on 07.04.2021.
//
//

import Foundation
import CoreData


extension Symbol {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Symbol> {
        return NSFetchRequest<Symbol>(entityName: "Symbol")
    }

    @NSManaged public var symbol: String?
    @NSManaged public var companyProfil: CompanyProfil?
    @NSManaged public var price: Price?

}
