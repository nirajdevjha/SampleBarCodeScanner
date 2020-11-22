//
//  ProductList.swift
//  SampleBarCodeScanner
//
//  Created by Niraj Kumar Jha on 22/11/20.
//  Copyright © 2020 Niraj Kumar Jha. All rights reserved.
//

import Foundation

struct ProductList {
    private var products: [String: [String: Any]]?

    init() {
        var format = PropertyListSerialization.PropertyListFormat.xml
        guard let path = Bundle.main.path(forResource: "ProductInfo", ofType: "plist"),
            let contents = FileManager.default.contents(atPath: path) else { return }
        self.products = try? PropertyListSerialization.propertyList(from: contents,
                                                               options: .mutableContainersAndLeaves,
                                                               format: &format) as? [String: [String: Any]]
    }

    func product(forKey key: String) -> Product? {
        guard let products = products else { return nil }
        if let dict = products[key] {
            return Product(dict: dict)
        }
        
        return nil
    }
}



