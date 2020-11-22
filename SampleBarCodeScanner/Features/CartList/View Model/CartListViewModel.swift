//
//  CartListViewModel.swift
//  SampleBarCodeScanner
//
//  Created by Niraj Kumar Jha on 22/11/20.
//  Copyright © 2020 Niraj Kumar Jha. All rights reserved.
//

import Foundation

class CartListViewModel {
    private var addedProductList: [Product]
    
    private(set) var rowModels = [CartListRowModel]()
    private var totalPrice: Float = 0
    
    /// Output Callbacks
    var reloadTable: () -> () = {}
    var showCartEmptyView: (String) -> () = { _ in }
    var updatePriceView: () -> () = {}
    
    init(addedProductList: [Product]) {
        self.addedProductList =  addedProductList
        addedProductList.forEach { product in
            if let productPrice = product.productPrice {
                totalPrice += productPrice
            }
        }
        reloadModels()
    }
    
    private func reloadModels() {
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
                let productImgUrl = product.productImg,
                let productPrice = product.productPrice else {
                    return
            }
            let prodItemRowModel = CartListItemRowModel(rowType: .cartItem, productName: productName, imageName: productImgUrl, price: productPrice)
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
    
    func removeRowModels(at index: Int) {
        guard index < addedProductList.count else { return }
        updateTotalPrice(addedProductList[index].productPrice)
        addedProductList.remove(at: index)
        reloadModels()
        if addedProductList.count == 0 {
            showCartEmptyView("Your Cart is Empty!!")
        }
    }
    
    func updateTotalPrice(_ price: Float?) {
        guard let price = price else {
            return
        }
        totalPrice -= price
        updatePriceView()
    }
    
    func getTotalPriceText() -> String? {
        guard totalPrice > 0 else {
            return nil
        }
        return "₹ \(totalPrice)"
    }
}
