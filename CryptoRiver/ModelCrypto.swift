//
//  CrytoModel.swift
//  CryptoRiver
//
//  Created by Peter Sun on 9/5/22.
//  Copyright © 2022 MjC25 LLC. All rights reserved.
//

import Foundation
import UIKit

struct Roi: Codable {
    var times = 106.6034483927208
    var currency = "btc"
    var percentage =  10660.34483927208
}

struct CryptoData: Codable {
    var id = "bitcoin"
    var symbol = "btc"
    var name = "Bitcoin"
    var image = "https =//assets.coingecko.com/coins/images/1/large/bitcoin.png?1547033579"
    var current_price:Float? = 19932.93
    var market_cap:Double? = 381411254249
    var market_cap_rank = 1
    var fully_diluted_valuation:Double? = 418419743331
    var total_volume:Double? = 23764901272
    var high_24h:Float?  = 19952.83
    var low_24h:Float?  = 19657.12
    var price_change_24h:Float?  = 14.01
    var price_change_percentage_24h:Double? = 0.07036
    var market_cap_change_24h:Double? = -458392156.97943115
    var market_cap_change_percentage_24h = -0.12004
    var circulating_supply:Double? = 19142587.0
    var total_supply:Double? = 21000000.0
    var max_supply:Double? = 21000000.0
    var ath:Float?  = 69045
    var ath_change_percentage:Float?  = -71.2863
    var ath_date = "2021-11-10T14:24:11.849Z"
    var atl:Float?  = 67.81
    var atl_change_percentage:Float?  = 29136.95456
    var atl_date = "2013-07-06T00 =00 =00.000Z"
    var roi:Roi?
    var last_updated = "2022-09-06T00 =37 =50.953Z"
}

// display preference with default values
struct Preference: Codable {
    var showCount = 10 // only show 10 cryptos
    var sortBy = "Price" // sort array by price
    var refreshFrequency: Int = 10 // refresh every 10 seconds
    var currency = "USD" // show price in US dollar
    var showOnlyROIAvailable = false // show cryptos with or without ROI (return of investment data)
}

struct CryptoLogo {
    var name:String
    var logo: UIImage
}

class ModelCrypto{
    static let shared = ModelCrypto() // singleton
    
    var displayPreference = Preference()
    public private(set) var lastRefreshed: Date = Date.now
    var allLogos: [CryptoLogo] = []
    
    // data variable
    private var rows: [CryptoData] = []
    // property for the variable
    var dataSet: [CryptoData] {
        get {
            if rows.count == 0 {
                return []
            }
            
            // sort array based on preference
            rows.sort{ (s1, s2) -> Bool in
                return self.displayPreference.sortBy == "Price" ? s1.current_price! > s2.current_price! : s1.market_cap! > s2.market_cap!
            }
            
            // filter raw data array with preference
            return Array(self.rows.filter({
                (!displayPreference.showOnlyROIAvailable || ($0.roi != nil))})[0..<displayPreference.showCount])
        }
    }
    
    private init() { }
    
    enum CryptoDataFetcherError: Error {
        case invalidURL
        case missingData
    }
    
    func fetchDataSet() async throws -> Void {
        
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=\(displayPreference.currency)") else {
            throw CryptoDataFetcherError.invalidURL
        }
        
        // Use the async variant of URLSession to fetch data
        // Code might suspend here
        let (data, _) = try await URLSession.shared.data(from: url)
        
        // Parse the JSON data
        self.rows = try JSONDecoder().decode([CryptoData].self, from: data)
        self.lastRefreshed = Date.now
        if allLogos.count == 0 {
            for crypto in self.rows {
                do {
                    let url = URL(string: crypto.image)!
                    let data = try Data(contentsOf: url)
                    self.allLogos.append(CryptoLogo(name: crypto.name, logo: UIImage(data: data)!))
                }
                catch{
                    print(error)
                }
            }
        }
    }
    
    
    struct CurrentPrice: Codable {
        var usd: Float
    }
    
    struct MarketData: Codable {
        var current_price: CurrentPrice
    }
    
    struct HistoricalData: Codable {
        var market_data: MarketData
    }
    
    func fetchPrice(cryptoId:String, date: String) async throws -> Float {
        
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/\(cryptoId)/history?date=\(date)") else {
            throw CryptoDataFetcherError.invalidURL
        }
        
        // Use the async variant of URLSession to fetch data
        // Code might suspend here
        let (data, _) = try await URLSession.shared.data(from: url)
        
        // Parse the JSON data
        let historyData = try JSONDecoder().decode(HistoricalData.self, from: data)
        
        return historyData.market_data.current_price.usd
        
    }
    
    
}
