
//  Created by Peter Sun on 9/9/22.
//  Copyright © 2022 Peter Sun. All rights reserved.
//

import UIKit

class VCCryptoMain: UITableViewController {
    @IBOutlet weak var wait: UIActivityIndicatorView!
    
    override func viewWillAppear(_ animated:Bool) {
        super.viewWillAppear(animated)
        if cryptoDataModel.dataSet.count > 0 {
            tableView.reloadData()
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Start an async task
        Task {
            wait.startAnimating()
            do {
                try await cryptoDataModel.fetchDataSet()
                tableView.reloadData()
                wait.stopAnimating()
                DispatchQueue.main.asyncAfter(deadline: .now() + Double(cryptoDataModel.displayPreference.refreshFrequency)) {
                    self.update()}
                
            } catch {
                print("Request failed with error:  \(error)")
                wait.stopAnimating()
            }
        }
    }
    
    @objc func update() {
        print("timer is called")
        Task {
            wait.startAnimating()
            do {
                try await cryptoDataModel.fetchDataSet()
                tableView.reloadData()
                wait.stopAnimating()
                DispatchQueue.main.asyncAfter(deadline: .now() + Double(cryptoDataModel.displayPreference.refreshFrequency)) {
                    self.update()
                }
            } catch {
                print("Request failed with error:  \(error)")
                wait.stopAnimating()
            }
        }
    }
    
    lazy var cryptoDataModel: ModelCrypto = {
        return ModelCrypto.shared
    }()
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 4
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 3 {
            return cryptoDataModel.dataSet.count
        }
        
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // section for crypto quotes
        if indexPath.section == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CryptoQuoteCell", for: indexPath)
            
            // set crypto name for the cell
            cell.textLabel!.text = self.cryptoDataModel.dataSet[indexPath.row].name
            
            // format the string to be in currency format
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .currency
            numberFormatter.minimumFractionDigits = 2
            numberFormatter.maximumFractionDigits = 2
            cell.detailTextLabel!.text = numberFormatter.string(from: NSNumber(value:self.cryptoDataModel.dataSet[indexPath.row].current_price ?? 0.0))
            
            // if price > yesterday, set color to green, < yesterday, set color to red
            if let change = self.cryptoDataModel.dataSet[indexPath.row].price_change_24h {
                if change >= 0 {
                    cell.detailTextLabel!.textColor = .green
                } else {
                    cell.detailTextLabel!.textColor = .red
                }
            }
            return cell
            
        } else if indexPath.section == 2 {  // section for coin sign icons
            let cell = tableView.dequeueReusableCell(withIdentifier: "CollectionCell", for: indexPath)
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm:ss"
            
            cell.textLabel?.text = "Last updated at \(dateFormatter.string(from: cryptoDataModel.lastRefreshed))"
            // Configure the cell...
            cell.detailTextLabel!.text = "Cryptos in the River"
            
            cell.textLabel?.textAlignment = .right
            return cell
            
        } else if indexPath.section == 1 { // section for header
            let cell = tableView.dequeueReusableCell(withIdentifier: "Header", for: indexPath)
            
            // Configure the cell...
            cell.textLabel?.text = "Top \(cryptoDataModel.displayPreference.showCount) Assets by \(cryptoDataModel.displayPreference.sortBy)"
            cell.textLabel?.textAlignment = .center
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "creators", for: indexPath)
            return cell
        }
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if let vc = segue.destination as? VCTeamPhoto,
           let cell = sender as? UITableViewCell,
           let name = cell.textLabel?.text {
            vc.displayImageName = name
        }
        
        // passing selected cryto asset name to the Detail controller, unwrap bunch of optionals in chain
        if let vcCryptoDetail = segue.destination as? VCCryptoDetail, // unwrapping the destination view controller
           let cell = sender as? UITableViewCell, // unwrapping the sender cell
           let name = cell.textLabel?.text // unwrapping the text in the sender cell
        {
            vcCryptoDetail.assetName = name // assign name in selected cell to destination view controller
        }
    }
    
    
}
