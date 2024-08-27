//
//  ProductDetailsViewController.swift
//  FrictionLog
//
//  Created by Joyce Qin on 8/23/24.
//

import UIKit
import Foundation

class ProductDetailsViewController: UIViewController {
    var product: Product?
    var price: Price?
    var quantity: Int?
    
    private let containerView = UIView()
    private let productImageView = UIImageView()
    private let productNameLabel = UILabel()
    private let productPriceLabel = UILabel()
    private let productDescription = UITextView()
    private let quantityLabel = UILabel()
    private let stepper = UIStepper()
    private var addToCartButton: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupContainerView()
        setupImageView()
        setupLabels()
//        stepper.addTarget(self, action: #selector(stepperValueChanged(_:)), for: .valueChanged)
        setupAddToCartButton()
        setupLayout()
        view.backgroundColor = Constants.background
        configure()
    }
    
    private func setupContainerView() {
        // Set up container view
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
    }
    
    private func setupImageView() {
        // Set up image view
        productImageView.clipsToBounds = true
        productImageView.translatesAutoresizingMaskIntoConstraints = false
        productImageView.contentMode = .scaleAspectFill
        containerView.addSubview(productImageView)
    }
    
    private func setupLabels() {
        // Set up labels
        productNameLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        productNameLabel.numberOfLines = 0
        productNameLabel.translatesAutoresizingMaskIntoConstraints = false
        productNameLabel.textColor = Constants.textColor
        
        productPriceLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        productPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        productPriceLabel.textColor = Constants.textColor
        
        productDescription.font = UIFont.preferredFont(forTextStyle: .body)
        productDescription.translatesAutoresizingMaskIntoConstraints = false
        productDescription.textColor = Constants.textColor
        productDescription.backgroundColor = Constants.background
        
//        quantityLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
//        quantityLabel.translatesAutoresizingMaskIntoConstraints = false
//        quantityLabel.textColor = Constants.textColor
//        
//        stepper.translatesAutoresizingMaskIntoConstraints = false
//        stepper.minimumValue = 0
//        stepper.stepValue = 1
//        stepper.value = 1
        
        containerView.addSubview(productNameLabel)
        containerView.addSubview(productPriceLabel)
        containerView.addSubview(productDescription)
//        containerView.addSubview(quantityLabel)
//        containerView.addSubview(stepper)
        
    }
    
//    @objc private func stepperValueChanged(_ sender: UIStepper) {
//        quantity = Int(sender.value)
////        quantityLabel.text = "Quantity: \(quantity!)"
//        if quantity == 0 {
//            addToCartButton!.isEnabled = false
//            ShopData.cart.removeValue(forKey: product!.id)
//        }
//        else {
//            addToCartButton!.isEnabled = true
//        }
//    }
    
    private func setupAddToCartButton() {
        var config = UIButton.Configuration.filled()
        config.title = "Add to cart"
        config.contentInsets = NSDirectionalEdgeInsets(top: Constants.padding, leading: Constants.padding, bottom: Constants.padding, trailing: Constants.padding) // Set padding
        config.baseBackgroundColor = Constants.accentColor
        addToCartButton = UIButton(configuration: config)
        addToCartButton!.setTitle("Add to cart", for: .normal)
        addToCartButton!.addTarget(self, action: #selector(addToCart), for: .touchUpInside)
        addToCartButton!.setTitleColor(.white, for: .normal)
        addToCartButton!.layer.cornerRadius = 8
        addToCartButton!.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(addToCartButton!)
    }
    
    @objc private func addToCart() {
        quantity = (quantity ?? 0) + 1
        ShopData.addToCart(product: product!, quantity: quantity!)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            // Set up layout constraints for containerView
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.padding),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.padding),
            containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.padding/2),
            containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Constants.padding/2),
            // Set up layout constraints for imageView
            productImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Constants.padding),
            productImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: Constants.padding),
            productImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -Constants.padding),
            productImageView.heightAnchor.constraint(equalTo: productImageView.widthAnchor),
            // Set up layout constraints for productName
            productNameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Constants.padding),
            productNameLabel.topAnchor.constraint(equalTo: productImageView.bottomAnchor, constant: Constants.padding),
            productNameLabel.trailingAnchor.constraint(equalTo: productPriceLabel.leadingAnchor, constant: -Constants.padding),
            // Set up layout constraints for productPrice
            productPriceLabel.topAnchor.constraint(equalTo: productImageView.bottomAnchor, constant: Constants.padding),
            productPriceLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -Constants.padding),
            productPriceLabel.bottomAnchor.constraint(equalTo: productNameLabel.bottomAnchor),
            // Set up layout constraints for productDescription
            productDescription.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Constants.padding),
            productDescription.topAnchor.constraint(equalTo: productPriceLabel.bottomAnchor, constant: Constants.padding),
            productDescription.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -Constants.padding),
            productDescription.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -Constants.padding),
            // Set up layout constraints for quantity
//            quantityLabel.centerYAnchor.constraint(equalTo: stepper.centerYAnchor),
            // Set up layout constraints for stepper
//            stepper.leadingAnchor.constraint(equalTo: quantityLabel.trailingAnchor, constant: Constants.padding),
//            stepper.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -Constants.padding),
            // Set up layout constraints for addToCartButton
            addToCartButton!.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Constants.padding),
            addToCartButton!.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -Constants.padding),
            addToCartButton!.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -Constants.padding),
        ])
    }
    
    private func configure() {
        let currentProduct = product ?? MockData.product
        productImageView.image = ImageData.images[currentProduct.images[0]]
        productNameLabel.text = currentProduct.name
        productPriceLabel.text = "$\(String(format: "%.2f", Double((price ?? MockData.price).unitAmount!)/100.0))"
        if currentProduct.description != nil {
            productDescription.text = currentProduct.description!
        }
//        quantityLabel.text = "Quantity: \(quantity!)"
    }
    
}
