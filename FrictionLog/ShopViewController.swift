//
//  ShopViewController.swift
//  FrictionLog
//
//  Created by Joyce Qin on 8/22/24.
//

import UIKit
import StripePaymentSheet

class ShopViewController: UIViewController {
//    private let searchBar = UISearchBar()
    private let productsLabel = UILabel()
    private let tableView = UITableView()
    private var products: [Product] = []
    private var prices: [String:Price] = [:]
    private var images: [String:UIImage] = [:]
    
    let backendProductsUrl = URL(string: "https://protective-verdant-ping.glitch.me/products")!
    let backendPricesBaseUrl = "https://protective-verdant-ping.glitch.me/prices"
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        setupSearchBar()
        setupProductsLabel()
        setupTableView()
        setupLayout()
        view.backgroundColor = Constants.background
        tableView.backgroundColor = Constants.background
        ShopData.getProducts(completion: handleProducts)
//        NotificationCenter.default.addObserver(self, selector: #selector(handleImageLoad(_:)), name: .didLoadProductThumbnail, object: nil)
    }
    
    private func handleProducts(products: [Product], prices: [String:Price], images: [String:UIImage]) {
        self.products = products
        self.prices = prices
        self.images = images
        self.tableView.reloadData()
    }
    
    @objc private func handleImageLoad(_ notification: Notification) {
        tableView.reloadData()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
//    private func setupSearchBar() {
//        searchBar.delegate = self
//        navigationItem.titleView = searchBar
//        if let searchField = searchBar.value(forKey: "searchField") as? UITextField {
//            searchField.textColor = Constants.textColor
//        }
//    }
    
    private func setupProductsLabel() {
        productsLabel.font = UIFont.preferredFont(forTextStyle: .title1)
        productsLabel.textAlignment = .center
        productsLabel.translatesAutoresizingMaskIntoConstraints = false
        productsLabel.textColor = Constants.textColor
        productsLabel.text = "Shop"
        view.addSubview(productsLabel)
    }
    
    private func setupTableView() {
        tableView.register(ProductCell.self, forCellReuseIdentifier: "ProductCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isUserInteractionEnabled = true // Make sure user interaction is enabled
        tableView.rowHeight = Constants.padding * 2 + Constants.productImageDimension
        view.addSubview(tableView)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            productsLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            productsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            productsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            productsLabel.bottomAnchor.constraint(equalTo: tableView.topAnchor, constant: -Constants.padding),
            
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -Constants.padding),
            
        ])
    }
    
}
extension ShopViewController : UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, ProductCellDelegate {
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//    }
//    
//    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        searchBar.text = ""
//        searchBar.resignFirstResponder()
//    }
//    
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        searchBar.resignFirstResponder() // Dismiss the keyboard
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath) as! ProductCell
        let product = self.products[indexPath.row]
        cell.delegate = self
        cell.configure(with: product, price: self.prices[product.defaultPrice] ?? MockData.price, image: self.images[product.images[0]]!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    
    func didTapProductDetails(in cell: ProductCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            let selectedItem = self.products[indexPath.row]
            let productDetailsViewController = ProductDetailsViewController()
            productDetailsViewController.product = selectedItem
            productDetailsViewController.price = self.prices[selectedItem.defaultPrice]
            productDetailsViewController.quantity = ShopData.cart[selectedItem.id]?.quantity
            navigationController?.pushViewController(productDetailsViewController, animated: true)
        }
    }
}
