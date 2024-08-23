//
//  ProductCell.swift
//  FrictionLog
//
//  Created by Joyce Qin on 8/21/24.
//

import Foundation
import UIKit

class ProductCell: UITableViewCell {
    
    private let containerView = UIView()
    private let productImageView = UIImageView()
    private let productNameLabel = UILabel()
    private let quantityLabel = UILabel()
    private let productPriceLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        setupContainerView()
        setupImageView()
        setupLabels()
        setupConstraints()
        contentView.backgroundColor = Constants.background
    }
    
    private func setupContainerView() {
        // Set up container view
        containerView.backgroundColor = Constants.secondaryBackground
        containerView.layer.cornerRadius = Constants.cornerRadius
        containerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(containerView)
    }
    
    private func setupImageView() {
        // Set up image view
        productImageView.clipsToBounds = true
        productImageView.translatesAutoresizingMaskIntoConstraints = false
        productImageView.contentMode = .scaleAspectFit
        containerView.addSubview(productImageView)
    }
    
    private func setupLabels() {
        // Set up labels
        productNameLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        productNameLabel.numberOfLines = 0
        productNameLabel.translatesAutoresizingMaskIntoConstraints = false
        productNameLabel.textColor = Constants.textColor
        quantityLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        quantityLabel.translatesAutoresizingMaskIntoConstraints = false
        quantityLabel.textColor = Constants.textColor
        productPriceLabel.font = UIFont.preferredFont(forTextStyle: .body)
        productPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        productPriceLabel.textColor = Constants.textColor
        containerView.addSubview(productNameLabel)
        containerView.addSubview(quantityLabel)
        containerView.addSubview(productPriceLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Set up layout constraints for containerView
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.padding),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.padding),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.padding/2),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.padding/2),
            // Set up layout constraints for imageView
            productImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Constants.padding),
            productImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            productImageView.heightAnchor.constraint(equalToConstant: Constants.productImageHeight),
            productImageView.widthAnchor.constraint(equalTo: productImageView.heightAnchor),
            // Set up layout constraints for productNameLabel
            productNameLabel.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: Constants.padding),
            productNameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: Constants.padding),
            productNameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -Constants.padding),
            // Set up layout constraints for quantityLabel
            quantityLabel.leadingAnchor.constraint(equalTo: productNameLabel.leadingAnchor),
            quantityLabel.topAnchor.constraint(equalTo: productNameLabel.bottomAnchor, constant: 4),
            quantityLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            //             Set up layout constraints for productPriceLabel
            productPriceLabel.leadingAnchor.constraint(equalTo: productNameLabel.leadingAnchor),
            productPriceLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -Constants.padding)
        ])
    }
    
    func configure(with cartItem: CartItem) {
        // Update the UI with the Product data
        Util.loadImage(from: cartItem.product.images[0], imageView: productImageView)
        productNameLabel.text = cartItem.product.name
        quantityLabel.text = "x \(cartItem.quantity)"
        productPriceLabel.text = "$\(String(format: "%.2f", Double(cartItem.price.unitAmount! * cartItem.quantity)/100.0))"
    }
    
    func configure(with product: Product, price: Price) {
        // Update the UI with the Product data
        Util.loadImage(from: product.images[0], imageView: productImageView)
        productNameLabel.text = product.name
        productPriceLabel.text = "$\(String(format: "%.2f", Double(price.unitAmount!)/100.0))"
    }
}
