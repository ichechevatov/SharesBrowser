//
//  MainPresenterImplementation.swift
//  Yandex_Test_Task
//
//  Created by Илья Че on 18.03.2021.
//

import Foundation
import CoreData

protocol MainPresenter: class{
    
    var vc: MainViewController? { get }
    var model: MainModel {get}
    var networkService: NetworkService { get }
    
    init(viewController: MainViewController, model: MainModel, networkService: NetworkService)
    
    func numberOfDisplayedCell() -> Int
    func obtainShareNameCompanyFor(indexPath: IndexPath) -> (logoData: Data?, tiker: String?, nameConpany: String?, currency: String?, price: Double?,  changesForDay: Double?)
    func obtainShareFavoriteStatus(index: Int) -> Bool
    func changeShareFavoriteStatus(index: Int)
    
    func dataHasChanget()
    //func startLoadData()
    func loadPagingData()
    
}

// добавить проверку на выход за пределы массива символов
// когда список загрузок закончен таблица бесконечно обновляется
//лимит по времени на загрузку данных
// уведомление об ошибки сети/сервера
// в загрузке цены и лого обработать выход за лимит запросов и ошибки
// при запросах в сеть обработать ошибки сервера/ сети
// обновлять таблицу не целиком , а только новые ячейки

//{"error":"You don't have access to this resource."} - ошибка с сервера при запросе цены

class MainPresenterImplementation: MainPresenter{
    
    private var bufferEmptySymbols: Set<String> = []
    private let quantityOfDownloadsShares = 10
    
    private let dataManager = DataStoreManager()
    private let dispatchGroupProfilCompanyLoad = DispatchGroup()
    var networkService: NetworkService
    
    weak var vc: MainViewController?
    var model: MainModel
    
    required init(viewController: MainViewController, model: MainModel, networkService: NetworkService) {
        self.vc = viewController
        self.model = model
        self.networkService = networkService
        print(dataManager.persistentContainer.persistentStoreCoordinator.persistentStores.first?.url)
        startLoadData()
    }
    
    private func startLoadData(){
        if   model.symbolsForLoad.count == 0 {
            
            vc?.loadData(isActiv: true)
            vc?.updateTableview()
            
            networkService.getSharesSymbols(callback: { [unowned self] (symbols) in // обработать отсутствие интернета , лимит и ошибку
                self.model.symbolsForLoad = Set(symbols)
                self.model.maxNumberSymbols = self.model.symbolsForLoad.count //????
                self.vc?.maxNumberOfRow  = self.model.maxNumberSymbols
                print(self.model.symbolsForLoad.count)
                dataHasChanget()
                loadPagingData()
            })
        } else {
            loadPagingData()
        }
    }
    
    func loadPagingData() {
        guard  model.symbolsForLoad.count != 0 else {
            return
        }
        vc?.loadData(isActiv: true)
        vc?.updateTableview()
        
        if model.symbolsForLoad.count < quantityOfDownloadsShares {
            let count = model.loadSymbols.count
            for _ in 0...count {
                
                dispatchGroupProfilCompanyLoad.enter()
                guard let symbolForLoad = model.symbolsForLoad.popFirst() else {return}
                
                DispatchQueue.global(qos: .utility).async { [weak self] in
                    self?.loadCompanyProfilFor(symbol: symbolForLoad)
                }
            }
        }else {
            for _ in 0..<quantityOfDownloadsShares {
                
                dispatchGroupProfilCompanyLoad.enter()
                guard let symbolForLoad = model.symbolsForLoad.popFirst() else {return}
                
                DispatchQueue.global(qos: .utility).async { [weak self] in
                    self?.loadCompanyProfilFor(symbol: symbolForLoad)
                }
            }
        }
        dispatchGroupProfilCompanyLoad.notify(queue: .main) { [weak self] in
            guard let self = self else {return}
            self.model.maxNumberSymbols -= self.bufferEmptySymbols.count
            self.vc?.maxNumberOfRow  = self.model.maxNumberSymbols
            self.bufferEmptySymbols.removeAll()
            self.dataHasChanget()
        }
        
    }
    
    private func loadCompanyProfilFor(symbol: String){
        let contexCD = dataManager.persistentContainer.newBackgroundContext()
        if dataManager.isContainSymbolInDS(symbol: symbol){
            defer{dispatchGroupProfilCompanyLoad.leave()}
            let priceLoadGroup = DispatchGroup()
            let profilCompany = dataManager.obtainCompanyProfil(symbol: symbol, with: contexCD)
            
            guard let price = profilCompany.symbol?.price else {return}
            guard let tiker = profilCompany.tiker else {return}
            var openPrice = 0.0
            var currentPrice = 0.0
            
            priceLoadGroup.enter()
            
            networkService.getSharePriceFor(ticker: tiker, callback: { (open, current) in
                currentPrice = current
                openPrice = open
                priceLoadGroup.leave()
            })
            //print("LOGO GROUP                                BEFORE")
            //проверить принтами порядок выполнения
            priceLoadGroup.wait()
            contexCD.perform { [weak self] in
                price.currentPrice = currentPrice
                price.openPriceOfTheDay = openPrice
                try! contexCD.save()
                self?.model.loadSymbols.append(symbol)
            }
        }else {
            networkService.getProfilCompanyFor(symbol: symbol) { [weak self] (name, tiker, currency, logoUrl, webUrl, ipoDate, exchange, country, error ) in
                if error == "API limit reached. Please try again later. Remaining Limit: 0" {
                    self?.loadCompanyProfilFor(symbol: symbol)
                }
                else if tiker == "" {
                    self!.bufferEmptySymbols.insert(symbol)
                    self?.dispatchGroupProfilCompanyLoad.leave()
                }else{
                    DispatchQueue.global(qos: .background).async {
                        
                            let logoAndPriceLoadGroup = DispatchGroup()
                            var logoData:Data?
                            var currentPrice: Double = 0
                            var openPriceOfTheDay: Double = 0
                            
                            logoAndPriceLoadGroup.enter()
                            DispatchQueue.global(qos: .utility).async { [weak self] in
                                self?.networkService.getLogoImageFor(logoUrl: logoUrl) {  (data) in
                                    logoData = data
                                    logoAndPriceLoadGroup.leave()
                                }
                            }
                            
                            logoAndPriceLoadGroup.enter()
                            
                            DispatchQueue.global(qos: .utility).async { [weak self] in
                                self?.networkService.getSharePriceFor(ticker: tiker, callback: {   (open, current) in
                                    currentPrice = current
                                    openPriceOfTheDay = open
                                    logoAndPriceLoadGroup.leave()
                                })
                            }
                            
                            logoAndPriceLoadGroup.wait()
                            contexCD.perform {
                                let result = CompanyProfil(context: contexCD)
                                //result.setPrimitiveValue(<#T##value: Any?##Any?#>, forKey: <#T##String#>)// разобраться
                                result.companyName = name
                                result.country = country
                                result.currensy = currency
                                result.exchange = exchange
                                result.ipoDate = ipoDate
                                result.logoUrl = logoUrl
                                result.logoData = logoData
                                result.tiker = tiker
                                result.webUrl = webUrl
                                
                                let priceDSM = Price(context: contexCD)
                                priceDSM.currentPrice = currentPrice
                                priceDSM.openPriceOfTheDay = openPriceOfTheDay
                                
                                let symbolDSM = Symbol(context: contexCD)
                                symbolDSM.symbol = symbol
                                symbolDSM.price  = priceDSM
                                
                                result.symbol = symbolDSM
                                do{
                                    try contexCD.save()
                                    
                                    self?.model.loadSymbols.append(symbol)
                                    self?.dispatchGroupProfilCompanyLoad.leave()
                                    
                                }catch(let error){
                                    print("ERROR                \(error)")
                                }
                            }
                    }
                }
            }
        }
    }
    
    func obtainShareNameCompanyFor(indexPath: IndexPath) -> (logoData: Data?, tiker: String?, nameConpany: String?, currency: String?, price: Double?,  changesForDay: Double?) {// этот метод сейчас возвращает данные в таблицу
        let symbol = model.loadSymbols[indexPath.row]
        
        let profilCompany = dataManager.obtainCompanyProfil(symbol: symbol, with: dataManager.backgroundContex)
        
        let changesForDay = (profilCompany.symbol?.price!.openPriceOfTheDay)! - (profilCompany.symbol?.price!.currentPrice)!
        let result = (profilCompany.logoData, profilCompany.tiker, profilCompany.companyName, profilCompany.currensy, profilCompany.symbol?.price?.currentPrice,  changesForDay)
        
        return result
    }
    
    func numberOfDisplayedCell() ->Int {
        let number = model.loadSymbols.count
        return number
    }
    
    func dataHasChanget() {
        vc?.loadData(isActiv: false)
        vc?.updateTableview()// можно ли не всю таблицу обновлять??
    }
    
    func obtainShareFavoriteStatus(index: Int) -> Bool {
        //получить значение акции "избранный"
        return false
    }
    
    func changeShareFavoriteStatus(index: Int) {
        // менять в бд значение "избранный"
    }
}


