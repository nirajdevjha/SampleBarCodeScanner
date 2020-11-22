//
//  CartItemTVC.swift
//  SampleBarCodeScanner
//
//  Created by Niraj Kumar Jha on 22/11/20.
//  Copyright © 2020 Niraj Kumar Jha. All rights reserved.
//

import UIKit

protocol CartItemCellProtocol: class {
    func removeProductFromCart(cell: CartItemTVC)
}

class CartItemTVC: UITableViewCell {

    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var prodNameLbl: UILabel!
    @IBOutlet private weak var prodImgView: UIImageView!
    @IBOutlet private weak var priceLbl: UILabel!
    
    weak var delegate: CartItemCellProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.cornerRadius = 4.0
        containerView.addtShadow(requirePath: false)
    }
   
    @IBAction
    private func didTapRemoveFromCart(_ sender: UIButton) {
        delegate?.removeProductFromCart(cell: self)
    }
    
    func configure(from model: CartListItemRowModel, delegate: CartItemCellProtocol?) {
        self.delegate = delegate
        prodNameLbl.text = model.productName
        priceLbl.text = "₹\(model.price)"
        imageView?.image = UIImage(named: model.imageName)
        
    }
}
