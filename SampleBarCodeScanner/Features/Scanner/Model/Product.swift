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
    let productImgUrl: String?
    let productPrice: String?
    
    init(dict: [String: Any]) {
        self.productName = dict["productName"] as? String
        self.productImgUrl = dict["imageUrl"] as? String
        self.productPrice = dict["price"] as? String
    }
}
