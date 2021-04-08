//
//  DataStoreManager.swift
//  Yandex_Test_Task
//
//  Created by Илья Че on 31.03.2021.
//

import Foundation
import CoreData

class DataStoreManager {
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    lazy var backgroundContex = persistentContainer.newBackgroundContext()
    
    lazy var context = persistentContainer.viewContext
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
  
    
    func obtainCompanyProfil(symbol: String,with context: NSManagedObjectContext ) -> CompanyProfil {
        
        let fetchRequest: NSFetchRequest<Symbol> = Symbol.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "symbol = %@", symbol)
        let symbol = try? context.fetch(fetchRequest) //данны передаются в ui мб надо в основном контексте? оюновление ячеек подвисает при пролистывании
        
        return symbol!.first!.companyProfil! // !!!!!!!!! Сделать проверки
    }
    
    func isContainSymbolInDS(symbol: String) -> Bool {
        let fetchRequest: NSFetchRequest<Symbol> = Symbol.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "symbol = %@", symbol)
        guard let symbol = try? backgroundContex.fetch(fetchRequest) else {return false}
        return !symbol.isEmpty // исправить реверсию ожидаемого значения
    }
}
