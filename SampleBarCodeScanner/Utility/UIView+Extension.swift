//
//  UIView+Extension.swift
//  SampleBarCodeScanner
//
//  Created by Niraj Kumar Jha on 22/11/20.
//  Copyright © 2020 Niraj Kumar Jha. All rights reserved.
//

import UIKit

protocol NibLoadView: class { }

extension NibLoadView {
    static var nibName: String {
        return String(describing: self)
    }
}

extension UIView: NibLoadView {}

protocol ReuseView: class { }

extension ReuseView where Self: UIView {
    static var identifier: String {
        return String(describing: self)
    }
}

extension UITableViewCell: ReuseView { }

extension UITableView {
    
    func register<T: UITableViewCell>(_: T.Type, bundle: Bundle? = nil) {
        let nib = UINib(nibName: T.nibName, bundle: bundle)
        register(nib, forCellReuseIdentifier: T.identifier)
    }
    
    func dequeueReuseCell<T: UITableViewCell>(forIndexPath indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.identifier, for: indexPath) as? T else {
            fatalError("failed to dequeue cell with identifier: \(T.identifier)")
        }
        return cell
    }
}

extension UIView {
    var cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set(newCornerRadius) {
            self.layer.cornerRadius = newCornerRadius
            layer.masksToBounds = newCornerRadius > 0
        }
    }
    
    func addtShadow(requirePath: Bool = true, opacity: Float = 0.2) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = 2.0
        if requirePath {
            self.layer.shadowPath = UIBezierPath(roundedRect: layer.bounds, cornerRadius: self.layer.cornerRadius == 0 ? 4.0 : self.layer.cornerRadius).cgPath
        }
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
    
}


public protocol NibLoadableView: class { }

public extension NibLoadableView {
    static var nibN: String {
        return String(describing: self)
    }
    
    static func loadFromNib(bundle: Bundle? = nil) -> Self {
        let nib = UINib(nibName: nibN, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as! Self
    }
}

extension UIView: NibLoadableView {}

extension UIView {
    class func loadfromNib<T: UIView>() -> T {
        return Bundle(for: T.self).loadNibNamed(String(describing: T.self), owner: nil, options: nil)?[0] as! T
    }
}
