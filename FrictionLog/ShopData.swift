//
//  ShopData.swift
//  FrictionLog
//
//  Created by Joyce Qin on 8/22/24.
//

import UIKit
import Foundation

struct ShopData {
    static var products: [Product] = []
    static var prices: [String: Price] = [:]
    static var cart: [String: CartItem] = [:]
    private static let backendProductsUrl = URL(string: "https://protective-verdant-ping.glitch.me/products")!
    private static let backendPricesBaseUrl = "https://protective-verdant-ping.glitch.me/prices"
    static func getProducts() {
        var request = URLRequest(url: backendProductsUrl)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            guard let data = data,
                  let jsonString = String(data: data, encoding: .utf8)
            else {
                return
            }
            if let jsonData = jsonString.data(using: .utf8) {
                do {
                    let decoder = JSONDecoder()
                    let productList = try decoder.decode(ProductListResponse.self, from: jsonData)
                    products = productList.data
                    for product in products {
                        getPrice(product: product)
                        for image in product.images {
                            Util.loadImage(from: image)
                        }
                    }
                    
                } catch {
                    print("Error decoding JSON. Please try restarting the server.")
                }
            }
            
        })
        task.resume()
    }
    
    static func getPrice(product: Product) {
        var request = URLRequest(url: URL(string: "\(backendPricesBaseUrl)/\(product.defaultPrice)")!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            guard let data = data,
                  let jsonString = String(data: data, encoding: .utf8)
            else {
                // Handle error
                return
            }
            if let jsonData = jsonString.data(using: .utf8) {
                do {
                    let decoder = JSONDecoder()
                    let price = try decoder.decode(Price.self, from: jsonData)
                    
                    prices.updateValue(price, forKey: product.defaultPrice)
                    
                } catch {
                    print("Error decoding JSON. Please try restarting the server.")
                }
            }
            
        })
        task.resume()
    }
    static func addToCart(product: Product, quantity: Int) {
        var cartItem = cart[product.id] ?? CartItem(product: product, price: prices[product.defaultPrice] ?? MockData.price, quantity: 0)
        
        cartItem.quantity = quantity
        cart.updateValue(cartItem, forKey: product.id)
        
    }
}
