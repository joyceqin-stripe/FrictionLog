//
//  ShopData.swift
//  FrictionLog
//
//  Created by Joyce Qin on 8/22/24.
//

import UIKit
import Foundation

struct ShopData {
    static var prices: [String: Price] = [:]
    static var cart: [String: CartItem] = [:]
    private static let backendProductsUrl = URL(string: "https://protective-verdant-ping.glitch.me/products")!
    private static let backendPricesBaseUrl = "https://protective-verdant-ping.glitch.me/prices"
    static func getProducts(completion: @escaping ([Product], [String:Price], [String:UIImage]) -> ()) {
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
                    let products = productList.data
                    var prices: [String: Price] = [:]
                    var images: [String: UIImage] = [:]
                    var totalImages = 0
                    for product in products {
                        totalImages += product.images.count
                    }
                    for product in productList.data {
                        getPrice(product: product) { price in
                            prices[product.defaultPrice] = price
                        }
                        for image in product.images {
                            Util.loadImage(from: image) { thumbnail in
                                images[image] = thumbnail
                                if images.count == totalImages {
                                    DispatchQueue.main.async {
                                        completion(productList.data, prices, images)
                                    }
                                }
                            }
                        }
                    }
                    
                } catch {
                    print("Error decoding JSON. Please try restarting the server.")
                    var images: [String: UIImage] = [:]
                    let product = MockData.product
                    let price = MockData.price
                    let image = product.images[0]
                    Util.loadImage(from: image) { thumbnail in
                        images[image] = thumbnail
                        DispatchQueue.main.async {
                            completion([product], [product.defaultPrice:price], images)
                        }
                    }
                }
            }
            
        })
        task.resume()
    }
    
    static func getPrice(product: Product, completion: @escaping (Price) -> ()) {
        var request = URLRequest(url: URL(string: "\(backendPricesBaseUrl)/\(product.defaultPrice)")!)
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
                    let price = try decoder.decode(Price.self, from: jsonData)
                    completion(price)
                    ShopData.prices.updateValue(price, forKey: product.defaultPrice)
                    
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
