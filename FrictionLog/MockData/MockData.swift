//
//  MockData.swift
//  FrictionLog
//
//  Created by Joyce Qin on 8/21/24.
//

import Foundation
import UIKit

struct MockData {
    static let products: [Product] = [
        Product(id: "prod_QhixdsHITLlyKH",
                object: "product",active: true,
                attributes: [],
                created: 1724265842,
                defaultPrice: "price_1PqJVmEknSev8kwTSEG6oLbZ",
                description:
                    "A natural cotton-blend t-shirt with the Survivor Texas logo over your heart and \"CREW\" on the back in Survivant font.",
                images:
                    [ "https://files.stripe.com/links/MDB8YWNjdF8xUG9BS3lFa25TZXY4a3dUfGZsX3Rlc3RfbWhHMkFsZnV1MDhlTUNOTWFnbDd1UDRt00YknM6Rcn" ],
                livemode: false,
                marketingFeatures: [],
                metadata: [:],
                name: "Survivor Texas Crew T-Shirt",
                packageDimensions: nil,
                shippable: nil,
                statementDescriptor: nil,
                taxCode: nil,
                type: "service",
                unitLabel: nil,
                updated: 1724265842,
                url: nil),
    ]
    
    static let prices: [Price] = [
        Price(id: "price_1PqJVmEknSev8kwTSEG6oLbZ",
              object: "price",
              active: true,
              billingScheme: "per_unit",
              created: 1724265842,
              currency: "usd",
              customUnitAmount: nil,
              livemode: false,
              lookupKey: nil,
              metadata: [:],
              nickname: nil,
              product: "prod_QhixdsHITLlyKH",
              recurring: nil,
              taxBehavior: "unspecified",
              tiersMode: nil,
              transformQuantity: nil,
              type: "one_time",
              unitAmount: 10000,
              unitAmountDecimal: "10000")]
    
    static var cartItems: [CartItem] = [
        CartItem(product: products[0], price: prices[0], quantity: 1)
    ]
}
