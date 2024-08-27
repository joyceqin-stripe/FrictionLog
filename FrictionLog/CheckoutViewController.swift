//
//  CheckoutViewController.swift
//  FrictionLog
//
//  Created by Joyce Qin on 8/22/24.
//

import UIKit
import StripePaymentSheet

class CheckoutViewController: UIViewController {
    private let cartLabel = UILabel()
    private let tableView = UITableView()
    private let checkoutButton = UIButton()
    var paymentSheet: PaymentSheet?
    let backendCheckoutUrl = URL(string: "https://protective-verdant-ping.glitch.me/checkout")!
    let postPaymentUrl = URL(string: "https://protective-verdant-ping.glitch.me/post-payment")!
    private var cartItems: [CartItem] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        cartItems = ShopData.cart.map{ key, value in (value) }
        setupCartLabel()
        setupTableView()
        setupCheckoutButton()
        setupLayout()
        view.backgroundColor = Constants.background
        tableView.backgroundColor = Constants.background
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cartItems = ShopData.cart.map{ key, value in (value) }
        checkoutEndpoint()
        tableView.reloadData()
    }
    
    private func checkoutEndpoint() {
        // MARK: Fetch the PaymentIntent client secret, Ephemeral Key secret, Customer ID, and publishable key
        var request = URLRequest(url: backendCheckoutUrl)
        request.httpMethod = "POST"
        request.httpBody = Util.toJSON(codable: cartItems)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = URLSession.shared.dataTask(with: request, completionHandler: { [weak self] (data, response, error) in
            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any],
                  let customerId = json["customer"] as? String,
                  let customerEphemeralKeySecret = json["ephemeralKey"] as? String,
                  let paymentIntentClientSecret = json["paymentIntent"] as? String,
                  let publishableKey = json["publishableKey"] as? String,
                  let self = self else {
                // Handle error
                return
            }
            
            STPAPIClient.shared.publishableKey = publishableKey
            // MARK: Create a PaymentSheet instance
            var configuration = PaymentSheet.Configuration()
            configuration.returnURL = "stripe.FrictionLog://stripe-redirect"
            configuration.merchantDisplayName = "Survivor Texas"
            configuration.style = .alwaysDark
            configuration.customer = .init(id: customerId, ephemeralKeySecret: customerEphemeralKeySecret)
            // Set `allowsDelayedPaymentMethods` to true if your business handles
            // delayed notification payment methods like US bank accounts.
            configuration.allowsDelayedPaymentMethods = true
            self.paymentSheet = PaymentSheet(paymentIntentClientSecret: paymentIntentClientSecret, configuration: configuration)
        })
        task.resume()
    }
    
    private func setupCartLabel() {
        cartLabel.font = UIFont.preferredFont(forTextStyle: .title1)
        cartLabel.textAlignment = .center
        cartLabel.translatesAutoresizingMaskIntoConstraints = false
        cartLabel.textColor = Constants.textColor
        cartLabel.text = "Cart"
        view.addSubview(cartLabel)
    }
    
    private func setupTableView() {
        tableView.register(ProductCell.self, forCellReuseIdentifier: "ProductCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = Constants.padding * 2 + Constants.productImageDimension
        view.addSubview(tableView)
    }
    
    private func setupCheckoutButton() {
        checkoutButton.setTitle("Checkout", for: .normal)
        checkoutButton.addTarget(self, action: #selector(checkoutTapped), for: .touchUpInside)
        checkoutButton.backgroundColor = Constants.accentColor
        checkoutButton.setTitleColor(.white, for: .normal)
        checkoutButton.layer.cornerRadius = 8
        checkoutButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(checkoutButton)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            cartLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            cartLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cartLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            cartLabel.bottomAnchor.constraint(equalTo: tableView.topAnchor, constant: -Constants.padding),
            
            //            tableView.topAnchor.constraint(equalTo: cartLabel.bottomAnchor, constant: Constants.padding),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: checkoutButton.topAnchor, constant: -Constants.padding),
            
            checkoutButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.padding),
            checkoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.padding),
            checkoutButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Constants.padding),
        ])
    }
    
    @objc func checkoutTapped() {
        paymentSheet?.present(from: self) { paymentResult in
            // MARK: Handle the payment result
            switch paymentResult {
            case .completed:
                print("Your order is confirmed")
            case .canceled:
                print("Canceled!")
            case .failed(let error):
                print("Payment failed: \(error)")
            }
            
        }
    }
}

extension CheckoutViewController: UITableViewDelegate, UITableViewDataSource, ProductCellDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = ShopData.cart.count
        if count == 0 {
            checkoutButton.isEnabled = false
        }
        return ShopData.cart.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath) as! ProductCell
        let cartItem = cartItems[indexPath.row]
        cell.configure(with: cartItem)
        cell.delegate = self
        return cell
    }
    
    func didTapProductDetails(in cell: ProductCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            let selectedItem = cartItems[indexPath.row]
            let productDetailsViewController = ProductDetailsViewController()
            productDetailsViewController.product = selectedItem.product
            productDetailsViewController.price = selectedItem.price
            productDetailsViewController.quantity = selectedItem.quantity
            navigationController?.pushViewController(productDetailsViewController, animated: true)
        }
    }
}

