//
//  ScannerViewModel.swift
//  SampleBarCodeScanner
//
//  Created by Niraj Kumar Jha on 22/11/20.
//  Copyright © 2020 Niraj Kumar Jha. All rights reserved.
//

import Foundation

class ScannerViewModel {
    
    private(set) var addedProductsToCart: [Product] = []
    
    /// Output Callbacks
    var updateCartCount: (Int) -> () = {_ in}
    
    func addProductToCart(_ product: Product) {
        addedProductsToCart.append(product)
        updateCartCount(addedProductsToCart.count)
    }
    
    func removeAllProds() {
        addedProductsToCart.removeAll()
        updateCartCount(addedProductsToCart.count)
    }
}
