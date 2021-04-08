//
//  CompanyProfil+CoreDataProperties.swift
//  
//
//  Created by Илья Че on 07.04.2021.
//
//

import Foundation
import CoreData


extension CompanyProfil {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CompanyProfil> {
        return NSFetchRequest<CompanyProfil>(entityName: "CompanyProfil")
    }

    @NSManaged public var companyName: String?
    @NSManaged public var country: String?
    @NSManaged public var currensy: String?
    @NSManaged public var exchange: String?
    @NSManaged public var ipoDate: String?
    @NSManaged public var logoData: Data?
    @NSManaged public var logoUrl: String?
    @NSManaged public var tiker: String?
    @NSManaged public var webUrl: String?
    @NSManaged public var symbol: Symbol?

}
