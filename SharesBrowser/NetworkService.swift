//
//  NetworkService.swift
//  Yandex_Test_Task
//
//  Created by Илья Че on 16.03.2021.
//

import Foundation
import Alamofire
import SwiftyJSON

protocol NetworkService: class {
    func getSharesSymbols(callback: @escaping (Array<String>) ->())
    func getProfilCompanyFor(symbol: String, callback: @escaping ((name: String, tiker: String, currency: String, logoUrl: String, webUrl: String,ipoDate: String, exchange: String,country: String, error: String )) ->())
    func getLogoImageFor(logoUrl: String , callback: @escaping (Data?) -> () )
    func getSharePriceFor(ticker: String, callback: @escaping ((openPriceOfTheDay: Double, currentPrice: Double)) -> () )
    func getCompanyNews()
}

class NetworkServiceImplimentation: NetworkService {
    // попробовать Response Caching
    
    let token = "c189tsf48v6ojusa0aj0"
    let mic = "XNYS"
    let exchange = "US"
    let finhubCallsLimitSemaphore = DispatchSemaphore(value: 4)
    
    func getProfilCompanyFor(symbol: String, callback: @escaping ((name: String, tiker: String, currency: String, logoUrl: String, webUrl: String,ipoDate: String, exchange: String,country: String, error: String )) ->()) {
        
        let url = URL(string: "https://finnhub.io/api/v1/stock/profile2")
        let param = ["symbol" : symbol , "token" : token]
        
        finhubCallsLimitSemaphore.wait()
        self.finnhubCallsTimer()
        
        AF.request(url!, method: .get, parameters: param).response { (data) in
            switch data.result {
            case .failure(let error):
                print("ERROR!!!!!!________________\(error)")
            case .success(let value):
                let json = JSON(value as Any)
                
                callback((name: json["name"].stringValue, tiker: json["ticker"].stringValue, currency: json["currency"].stringValue, logoUrl: json["logo"].stringValue, webUrl: json["weburl"].stringValue, ipoDate: json["ipo"].stringValue, exchange: json["exchange"].stringValue,country: json["country"].stringValue, error: json["error"].stringValue ))
            }
        }
    }
    
    func getSharePriceFor(ticker: String, callback: @escaping ((openPriceOfTheDay: Double, currentPrice: Double)) -> ()) {
        let urlString = "https://finnhub.io/api/v1/quote"
        let param = ["symbol": ticker, "token": token]
        
        guard let url = URL(string: urlString) else {return}
        finhubCallsLimitSemaphore.wait()
        self.finnhubCallsTimer()
        
        AF.request(url, method: .get, parameters: param).response { (data) in
            switch data.result{
            case .failure(let  error):
                print(error)
            case .success(let value):
                let json = JSON(value)
                
                callback((openPriceOfTheDay: json["o"].doubleValue, currentPrice: json["c"].doubleValue))
            }
        }
    }
    
    func getCompanyNews() {
        
    }
    
    func getSharesSymbols(callback: @escaping (Array<String>) ->())  {
        var result = Array<String>()
        let symbolsUrlString = "https://finnhub.io/api/v1/stock/symbol"
        let param = ["exchange" : exchange ,"mic" : mic , "token" : token]
        guard let urlSymbols = URL(string: symbolsUrlString) else {return}
        
        finhubCallsLimitSemaphore.wait()
        self.finnhubCallsTimer()
        
        AF.request(urlSymbols, method: .get, parameters: param).response  { (data) in
            switch data.result{
            case .failure(let error):
                print(error)
            case .success(let value):
                let json = JSON(value as Any)
                result = json[].arrayValue.map { $0["symbol"].stringValue}
                callback(result)
            }
        }
    }
    
    
    func getLogoImageFor(logoUrl: String, callback: @escaping (Data?) -> ()) {
        
        guard let url = URL(string: logoUrl) else {
            callback(nil)
            return
        }
        
        finhubCallsLimitSemaphore.wait()
        self.finnhubCallsTimer()
        
        AF.request(url, method: .get).response { (data) in
            switch data.result {
            case .failure(let error):
                print(error)
            case .success(let value):
                callback(value)
            }
        }
    }
    
    func finnhubCallsTimer(){
        DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(4)) { [unowned self] in
            finhubCallsLimitSemaphore.signal()
        }
    }
}
