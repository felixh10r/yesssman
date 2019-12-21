//
//  TodayViewController.swift
//  yessman-today
//
//  Created by Felix on 21.12.19.
//  Copyright © 2019 scale. All rights reserved.
//

import NotificationCenter
import UIKit

private let ONE_MILLION = 1_000_000

class TodayViewController: UIViewController, NCWidgetProviding {
    @IBOutlet var freeText: UILabel!
    @IBOutlet var totalText: UILabel!
    @IBOutlet weak var effectView: UIVisualEffectView!
    @IBOutlet weak var usedWidth: NSLayoutConstraint!
    @IBOutlet weak var freeWidth: NSLayoutConstraint!
    @IBOutlet weak var barContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        effectView.layer.cornerRadius = 8
        effectView.clipsToBounds = true
        // Do any additional setup after loading the view.
    }

    func widgetPerformUpdate(completionHandler: @escaping (NCUpdateResult) -> Void) {
        YesssService().getCurrentQuota {
            guard let quotaData = $0 else {
                completionHandler(.failed)
                return
            }
            
            DispatchQueue.main.async {
                self.updateView(quotaData: quotaData)
            }
            
            completionHandler(.newData)
        }
    }
    
    private func updateView(quotaData: QuotaData) {
        let used = quotaData.total - quotaData.free
        
        let bcf = ByteCountFormatter()
        
        let ratio = CGFloat(used) / CGFloat(quotaData.total)
        
        freeWidth = freeWidth.constraintWithMultiplier(1 - 0.1)

        freeText.text = bcf.string(fromByteCount: Int64(used * ONE_MILLION))
        
        totalText.text = bcf.string(fromByteCount: Int64(quotaData.total * ONE_MILLION))
        
        let _usedWidth = usedWidth.constraintWithMultiplier(ratio)
        barContainer.removeConstraint(usedWidth)
        barContainer.addConstraint(_usedWidth)
        usedWidth = _usedWidth
        
        let _freeWidth = freeWidth.constraintWithMultiplier(1 - ratio)
        barContainer.removeConstraint(freeWidth)
        barContainer.addConstraint(_freeWidth)
        freeWidth = _freeWidth
        
        barContainer.layoutIfNeeded()
        barContainer.isHidden = false
    }
}
