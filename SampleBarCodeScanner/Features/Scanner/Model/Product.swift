//
//  Product.swift
//  SampleBarCodeScanner
//
//  Created by Niraj Kumar Jha on 22/11/20.
//  Copyright © 2020 Niraj Kumar Jha. All rights reserved.
//

import Foundation

struct Product {
    let productName: String?
    let productImg: String? // can use image url instead from local
    let productPrice: Float?
    
    init(dict: [String: Any]) {
        self.productName = dict["productName"] as? String
        self.productImg = dict["productImg"] as? String
        self.productPrice = dict["price"] as? Float
    }
}
