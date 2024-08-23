//
//  ShopViewController.swift
//  FrictionLog
//
//  Created by Joyce Qin on 8/22/24.
//

import UIKit
import StripePaymentSheet

class ShopViewController: UIViewController {
    private let searchBar = UISearchBar()
    private let tableView = UITableView()
    
    var allProducts: [Product] = []
    var prices: [String: Price] = [:]
    let backendProductsUrl = URL(string: "https://protective-verdant-ping.glitch.me/products")!
    let backendPricesBaseUrl = "https://protective-verdant-ping.glitch.me/prices"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        view.backgroundColor = Constants.background
        tableView.backgroundColor = Constants.background
//        testJsonParsing()
        getAllProducts()
    }
    
    private func setupSearchBar() {
        searchBar.delegate = self
        navigationItem.titleView = searchBar
        if let searchField = searchBar.value(forKey: "searchField") as? UITextField {
            searchField.textColor = Constants.textColor
        }
    }
    
    private func getAllProducts() {
        // MARK: Fetch the PaymentIntent client secret, Ephemeral Key secret, Customer ID, and publishable key
        var request = URLRequest(url: backendProductsUrl)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = URLSession.shared.dataTask(with: request, completionHandler: { [weak self] (data, response, error) in
            guard let data = data,
                  let jsonString = String(data: data, encoding: .utf8),
                  let self = self else {
                // Handle error
                return
            }
            if let jsonData = jsonString.data(using: .utf8) {
                
                do {
                    let decoder = JSONDecoder()
                    let productList = try decoder.decode(ProductListResponse.self, from: jsonData)
                    self.allProducts = productList.data
                    for product in self.allProducts {
                        getPrice(product: product)
                    }
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    
                } catch {
                    print("Error decoding JSON: \(error.localizedDescription)")
                }
            }
            
        })
        task.resume()
        setupTableView()
        setupLayout()
    }
    
    private func getPrice(product: Product) {
        var request = URLRequest(url: URL(string: "\(backendPricesBaseUrl)/\(product.defaultPrice)")!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = URLSession.shared.dataTask(with: request, completionHandler: { [weak self] (data, response, error) in
            guard let data = data,
                  let jsonString = String(data: data, encoding: .utf8),
                  let self = self else {
                // Handle error
                return
            }
            if let jsonData = jsonString.data(using: .utf8) {
                do {
                    let decoder = JSONDecoder()
                    let price = try decoder.decode(Price.self, from: jsonData)
                    
                    self.prices.updateValue(price, forKey: product.defaultPrice)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    
                } catch {
                    print("Error decoding JSON: \(error.localizedDescription)")
                }
            }
            
        })
        task.resume()
    }
    
    private func setupTableView() {
        tableView.register(ProductCell.self, forCellReuseIdentifier: "ProductCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = Constants.padding * 2 + Constants.productImageHeight
        view.addSubview(tableView)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.padding),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -Constants.padding),

        ])
    }
    
}
extension ShopViewController : UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder() // Dismiss the keyboard
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath) as! ProductCell
        let product = self.allProducts[indexPath.row]
        cell.configure(with: product, price: self.prices[product.defaultPrice] ?? MockData.prices[0])
        return cell
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
}
