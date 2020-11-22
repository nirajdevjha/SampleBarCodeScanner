//
//  CartListingVMSpec.swift
//  SampleBarCodeScannerTests
//
//  Created by Niraj Kumar Jha on 22/11/20.
//  Copyright © 2020 Niraj Kumar Jha. All rights reserved.
//

import Quick
import Nimble

@testable import SampleBarCodeScanner

class CartListingVMSpec: QuickSpec {
    
    override func spec() {
        var listingVM: CartListViewModel!
        var productList: [Product] = []
        let sampleData: [[String: Any]] = [["productName": "Kissan Fruit Jam", "productImg": "jam", "productPrice": 20.0], ["productName": "Real juice", "productImg": "real", "productPrice": 99.0]]
        sampleData.forEach { data in
            let product = Product(dict: data)
            productList.append(product)
        }
        listingVM = CartListViewModel(addedProductList: productList)
        
        describe("Cart Listing") {
            beforeEach {
            }
            
            afterEach {
            }
            
            context("added prods in cart") {
                it("view model initialized") {
                    expect(listingVM).toNot((beNil()))
                }
                
                it("maps to correct props") {
                    expect(listingVM.addedProductList).toNot((beNil()))
                    expect(listingVM.addedProductList.count).to(equal(2))
                    expect(listingVM.getTotalPriceText()) == "₹ 119.0"
                }
                
                
                it("table view data source") {
                    expect(listingVM.numOfRows(in: 0)) == 2
                    let testRow: Int = 0
                    if let rowModel = listingVM.cartCellModel(at: testRow) as? CartListItemRowModel {
                        expect(rowModel).toNot((beNil()))
                        expect(rowModel.rowType) == .cartItem
                        expect(rowModel.productName) == "Kissan Fruit Jam"
                        expect(rowModel.imageName) == "jam"
                        expect(rowModel.price) == 20.0
                    }
                }
            }
            
            context("remove item from  cart") {
                it("remove from cart") {
                    let testRow: Int = 0
                    listingVM.removeRowModels(at: testRow)
                    // after removing product from cart, there is only 1 left
                    expect(listingVM.addedProductList.count).to(equal(1))
                    expect(listingVM.getTotalPriceText()) == "₹ 99.0"
                    if let rowModel = listingVM.cartCellModel(at: testRow) as? CartListItemRowModel {
                        expect(rowModel).toNot((beNil()))
                        expect(rowModel.rowType) == .cartItem
                        expect(rowModel.productName) == "Real juice"
                        expect(rowModel.imageName) == "real"
                        expect(rowModel.price) == 99.0
                    }
                }
            }
            
        }
    }
    
}
