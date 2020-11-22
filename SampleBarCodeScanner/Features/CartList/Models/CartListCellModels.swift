//
//  CartListCellModels.swift
//  SampleBarCodeScanner
//
//  Created by Niraj Kumar Jha on 22/11/20.
//  Copyright © 2020 Niraj Kumar Jha. All rights reserved.
//

import Foundation

protocol CartListRowModel {
    var rowType: CartListRowType { get }
}

enum CartListRowType {
    case cartItem
}

struct CartListItemRowModel: CartListRowModel {
    var rowType: CartListRowType
    let productName: String
    let imageName: String
    let price: Double
}
