//
//  PriceBottomBarView.swift
//  SampleBarCodeScanner
//
//  Created by Niraj Kumar Jha on 22/11/20.
//  Copyright © 2020 Niraj Kumar Jha. All rights reserved.
//

import UIKit

final class PriceBottomBarView: UIView {

    @IBOutlet private weak var priceLbl: UILabel!
    @IBOutlet private weak var payNowBtn: UIButton!

    @IBAction
    private func didTapPayNow(_ sender: UIButton) {
        //open payment page
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        payNowBtn.cornerRadius = payNowBtn.frame.height / 2
    }
    
    func removePriceView() {
        self.removeFromSuperview()
    }
    
    func updatePrice(_ totalPrice: String) {
        priceLbl.text = totalPrice
    }
}
