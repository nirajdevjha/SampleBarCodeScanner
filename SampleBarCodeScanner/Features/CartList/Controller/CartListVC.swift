//
//  CartListVC.swift
//  SampleBarCodeScanner
//
//  Created by Niraj Kumar Jha on 22/11/20.
//  Copyright © 2020 Niraj Kumar Jha. All rights reserved.
//

import UIKit

protocol CartListVCProtocol: class {
    func updateProducts()
}

class CartListVC: UIViewController {
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 80
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 16, right: 0)
        tableView.register(CartItemTVC.self, bundle: .main)
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    private lazy var closeBarBtn: UIBarButtonItem = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "cross"), for: .normal)
        button.addTarget(self, action: #selector(didTapClose), for: .touchUpInside)
        let barButton = UIBarButtonItem(customView: button)
        return barButton
    }()
    
    private lazy var priceView: PriceBottomBarView = {
          let view: PriceBottomBarView = UIView.loadfromNib()
          view.translatesAutoresizingMaskIntoConstraints = false
          return view
      }()
      
    private var tableBottomConstraint: NSLayoutConstraint!
    
    private let viewModel: CartListViewModel
    private weak var delegate: CartListVCProtocol?
    
       
    init(viewModel: CartListViewModel, delegate: CartListVCProtocol?) {
        self.viewModel = viewModel
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Cart"
        navigationItem.leftBarButtonItem = closeBarBtn
        navigationController?.setUpNavBar()
        setupViews()
        viewModelEvents()
        updateBottomBar()
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        view.addSubview(priceView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        tableBottomConstraint = tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        tableBottomConstraint.isActive = true
        
        NSLayoutConstraint.activate([
            priceView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            priceView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            priceView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            priceView.heightAnchor.constraint(equalToConstant: 54)
        ])
    }
    
    private func viewModelEvents() {
        viewModel.reloadTable = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
        viewModel.showCartEmptyView = { [weak self] msg in
            guard let self = self else { return }
            DispatchQueue.main.async {
                EmptyCartAlert.presentEmptyCartAlert(from: self.view, delegate: self, msg: msg)
                self.tableView.isHidden = true
            }
        }
        
        viewModel.updatePriceView = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.updateBottomBar()
            }
        }
    }
    
    private func updateBottomBar() {
        guard let totalPrice = viewModel.getTotalPriceText() else {
            priceView.removePriceView()
            return
        }
        priceView.updatePrice(totalPrice)
    }
    
    @objc
    private func didTapClose() {
        dismiss(animated: true)
    }
    
    @objc func didTapPayNow() {
        //payment page
    }
}

extension CartListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numOfRows(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let model = viewModel.carCellModel(at: indexPath.row) else {
            return UITableViewCell()
        }
        
        switch model.rowType {
        case .cartItem:
            if let model = model as? CartListItemRowModel {
                let cell: CartItemTVC = tableView.dequeueReuseCell(forIndexPath: indexPath)
                cell.configure(from: model, delegate: self)
                return cell
            }

        }
        return UITableViewCell()
    }
}

extension CartListVC: CartItemCellProtocol {
    func removeProductFromCart(cell: CartItemTVC) {
        guard let indexPath = tableView.indexPath(for: cell) else {
            return
        }
        viewModel.removeRowModels(at: indexPath.row)
    }
}

extension CartListVC: EmptyCartAlertProtocol {
    func didTapScan() {
        dismiss(animated: true) {
            self.delegate?.updateProducts()
        }
    }
}

