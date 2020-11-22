//
//  EmptyCartAlert.swift
//  HotelUI
//
//  CCreated by Niraj Kumar Jha on 22/11/20.
//  Copyright © 2020 Niraj Kumar Jha. All rights reserved.
//

import UIKit

protocol EmptyCartAlertProtocol: class {
    func didTapScan()
}

final class EmptyCartAlert: UIView {

    @IBOutlet private weak var msgLbl: UILabel!
    @IBOutlet private weak var scanBtn: UIButton!
    
    weak var delegate: EmptyCartAlertProtocol?
    
    @IBAction
    private func didTapScan(_ sender: UIButton) {
        delegate?.didTapScan()
    }
    
    private func configureView(from msg: String, delegate: EmptyCartAlertProtocol?) {
        scanBtn.cornerRadius = scanBtn.frame.height / 2
        msgLbl.text = msg
        self.delegate = delegate
    }
    
    class func presentEmptyCartAlert(from view: UIView, delegate: EmptyCartAlertProtocol?, msg: String) {
        let cartView = EmptyCartAlert.loadFromNib(bundle: Bundle.main)
        cartView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cartView)
        NSLayoutConstraint.activate([
            cartView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cartView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            cartView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            cartView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cartView.heightAnchor.constraint(equalToConstant: 100)
        ])
        cartView.layoutIfNeeded()
        cartView.configureView(from: msg, delegate: delegate)
    }
}
