//
//  CartListViewModel.swift
//  SampleBarCodeScanner
//
//  Created by Niraj Kumar Jha on 22/11/20.
//  Copyright © 2020 Niraj Kumar Jha. All rights reserved.
//

import Foundation

class CartListViewModel {
    private let addedProductList: [Product]
    
    private(set) var rowModels = [CartListRowModel]()
    
    /// Output Callbacks
    var reloadTable: () -> () = {}
    
    init(addedProductList: [Product]) {
        self.addedProductList =  addedProductList
        prepareRowModels()
        reloadTable()
    }
    
    
    private func prepareRowModels() {
        rowModels.removeAll()
        guard addedProductList.count > 0 else {
            return
        }
        for product in addedProductList {
            guard let productName = product.productName,
                let productImgUrl = product.productImgUrl,
                let productPrice = product.productPrice else {
                    return
            }
            let prodItemRowModel = CartListItemRowModel(rowType: .cartItem, productName: productName, imageUrl: productImgUrl, price: productPrice)
            rowModels.append(prodItemRowModel)
        }
    }
    
    func numOfRows(in section: Int) -> Int {
        return rowModels.count
    }
    
    func carCellModel(at index: Int) -> CartListRowModel? {
        guard index < rowModels.count else { return nil }
        return rowModels[index]
    }
}
