//
//  VCCryptoDetail.swift
//  CryptoRiver
//
//  Created by The Peter Sun on 9/11/22.
//  Copyright © 2022 Peter Sun. All rights reserved.
//

import UIKit

class VCCryptoDetail: UIViewController {
    var assetName:String?
    lazy var cryptoDataModel: ModelCrypto = {
        return ModelCrypto.shared
    }()
    var assetDetail: CryptoData = CryptoData()
    var priceOnSelectedDate: Float?
    
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var lblSymbol: UILabel!
    @IBOutlet weak var lbl_last_updated: UILabel!
    
    @IBOutlet weak var lbl_current_price: UILabel!
    
    @IBOutlet weak var lbl_hi_lo: UILabel!
    
    @IBOutlet weak var lbl_market_cap: UILabel!
    
    @IBOutlet weak var lbl_market_cap_rank: UILabel!
    
    @IBOutlet weak var lbl_ath: UILabel!
    
    @IBOutlet weak var lbl_ath_date: UILabel!
    
    @IBOutlet weak var lbl_atl: UILabel!
    
    @IBOutlet weak var lbl_atl_date: UILabel!
    
    @IBOutlet weak var lbl_roi_percentage: UILabel!
    
    @IBOutlet weak var lbl_price_on_date: UILabel!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var btnFetchPrice: UIButton!
    
    @IBAction func fetchPriceButtonClicked(_ sender: UIButton) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let selectedDate = dateFormatter.string(from: datePicker.date)
        self.lbl_price_on_date.text = "fetching price from server..."
        Task {
            do {
                let historicalPrice = try await cryptoDataModel.fetchPrice(cryptoId: assetDetail.id, date: selectedDate)
                let currencyFormatter = NumberFormatter()
                currencyFormatter.numberStyle = .currency
                currencyFormatter.minimumFractionDigits = 2
                currencyFormatter.maximumFractionDigits = 2
                
                self.lbl_price_on_date.text =  currencyFormatter.string(from: NSNumber(value:historicalPrice ))
            } catch {
                self.lbl_price_on_date.text = "price not found for the date"
                print("Request failed with error:  \(error)")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let name = assetName {
            assetDetail = cryptoDataModel.dataSet.first(where: { $0.name == name })!
        }
        // Do any additional setup after loading the view.
        lblName.text = assetDetail.name
        lblSymbol.text = assetDetail.symbol
        lbl_last_updated.text = assetDetail.last_updated
        
        let currencyFormatter = NumberFormatter()
        currencyFormatter.numberStyle = .currency
        currencyFormatter.minimumFractionDigits = 2
        currencyFormatter.maximumFractionDigits = 2
        
        lbl_current_price.text = currencyFormatter.string(from: NSNumber(value:assetDetail.current_price ?? 0.0))
        lbl_hi_lo.text = currencyFormatter.string(from: NSNumber(value:assetDetail.low_24h ?? 0.0))! +  " - " + currencyFormatter.string(from: NSNumber(value:assetDetail.high_24h ?? 0.0))!
        
        lbl_market_cap.text = currencyFormatter.string(from: NSNumber(value:assetDetail.market_cap ?? 0.0))
        lbl_market_cap_rank.text = "\(assetDetail.market_cap_rank)"
        
        lbl_ath.text = currencyFormatter.string(from: NSNumber(value:assetDetail.ath ?? 0.0))
        lbl_ath_date.text = String(Array(assetDetail.ath_date)[..<10])
        
        lbl_atl.text = currencyFormatter.string(from: NSNumber(value:assetDetail.atl ?? 0.0))
        lbl_atl_date.text = String(Array(assetDetail.atl_date)[..<10])
        
        let pctFormatter = NumberFormatter()
        pctFormatter.numberStyle = .percent
        pctFormatter.minimumFractionDigits = 2
        pctFormatter.maximumFractionDigits = 2
        lbl_roi_percentage.text = assetDetail.roi != nil ? pctFormatter.string(from: NSNumber(value:assetDetail.roi?.percentage ?? 0.0)) : "Data not available"
        
        if let historicalPrice = self.priceOnSelectedDate {
            lbl_price_on_date.text = currencyFormatter.string(from: NSNumber(value:historicalPrice ))!
        } else {
            lbl_price_on_date.text = lbl_current_price.text
        }
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
