//  Created by Peter Sun on 9/9/22.
//  Copyright © 2022 Peter Sun. All rights reserved.

import UIKit

class VCPreference: UIViewController {
    lazy var cryptoDataModel: ModelCrypto = {
        return ModelCrypto.shared
    }()
    
    @IBOutlet weak var sortBy: UISegmentedControl!
    
    
    @IBOutlet weak var refreshFrequency: UISlider!
    @IBOutlet weak var showOnlyRoi: UISwitch!
    
    @IBOutlet weak var showCount: UIStepper!
    
    @IBOutlet weak var showCountLabel: UILabel!
    
    @IBOutlet weak var lblRefresh: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        refreshFrequency.value =  Float(cryptoDataModel.displayPreference.refreshFrequency)
        showCount.value =  Double(cryptoDataModel.displayPreference.showCount)
        sortBy.selectedSegmentIndex = cryptoDataModel.displayPreference.sortBy == "Price" ? 0 : 1
        showOnlyRoi.isOn = cryptoDataModel.displayPreference.showOnlyROIAvailable
        
        showCountLabel.text = "show top \(cryptoDataModel.displayPreference.showCount)"
        lblRefresh.text = "update every \(cryptoDataModel.displayPreference.refreshFrequency) seconds"
    }
    
    @IBAction func sortedByChanged(_ sender: UISegmentedControl) {
        if(sender.selectedSegmentIndex == 0) {
            cryptoDataModel.displayPreference.sortBy = "Price"
        } else {
            cryptoDataModel.displayPreference.sortBy = "Market Cap"
        }
    }
    
    @IBAction func refreshFrequencyChanged(_ sender: UISlider) {
        cryptoDataModel.displayPreference.refreshFrequency = Int(sender.value)
        lblRefresh.text = "update every \(cryptoDataModel.displayPreference.refreshFrequency) sec"
    }

    
    @IBAction func roiFlagChanged(_ sender: UISwitch) {
        cryptoDataModel.displayPreference.showOnlyROIAvailable = sender.isOn
    }
    
    @IBAction func showCountChanged(_ sender: UIStepper) {
        cryptoDataModel.displayPreference.showCount = Int(sender.value)
        showCountLabel.text = "show top \(cryptoDataModel.displayPreference.showCount)"
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
