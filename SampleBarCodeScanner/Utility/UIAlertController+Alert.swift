//
//  UIAlertController+Alert.swift
//  SampleBarCodeScanner
//
//  Created by Niraj Kumar Jha on 22/11/20.
//  Copyright © 2020 Niraj Kumar Jha. All rights reserved.
//

import UIKit

extension UIAlertController {
    class func showAlert(
        from viewController: UIViewController?,
        title: String, msg: String) {
        
        guard let viewController = viewController else { return }
        
        let okAction = UIAlertAction(
            title: "Ok",
            style: .default)
        
        let alertController = UIAlertController(
            title: title,
            message: msg,
            preferredStyle: .alert)
        
        alertController.addAction(okAction)

        viewController.present(alertController, animated: true)
        
    }
}
