//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate  {
    func didUpdateCoinData ( _ coinManager : CoinManager , coinData: CoinData)
    func didFailWithError(error : Error)
}

struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "75A2321C-9337-410B-86D4-A2B4B738D741"

    var delegate : CoinManagerDelegate?
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    func getCoinPrice(for currency: String) {
        
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
        
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                if let data = data {
//                    String(format: "%.2f", parseJSON(data) ?? 0.0)
                    if let rate =  parseJSON(data) {
                        self.delegate?.didUpdateCoinData(self, coinData: CoinData(rate: rate))
                    }
                }
            }
            task.resume()
        }
    }
    
    
    func parseJSON ( _ coinData : Data) -> Double? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CoinData.self, from: coinData)
            let rate = decodedData.rate
            return rate
            
        }catch{
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
}
