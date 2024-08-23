//
//  Product.swift
//  FrictionLog
//
//  Created by Joyce Qin on 8/21/24.
//

import Foundation

// MARK: - Response Struct

struct ProductListResponse: Codable {
    let data: [Product]
    let object: String
    let hasMore: Bool
    let url: String
    
    // Coding keys to match JSON keys with different property names in Swift
    private enum CodingKeys: String, CodingKey {
        case data
        case object
        case hasMore = "has_more"
        case url
    }
}

// MARK: - Product Struct
struct Product: Codable {
    let id: String
    let object: String
    let active: Bool
    let attributes: [String]
    let created: Int
    let defaultPrice: String
    let description: String?
    let images: [String]
    let livemode: Bool
    let marketingFeatures: [MarketingFeature]
    let metadata: [String: String] // Adjust as necessary
    let name: String
    let packageDimensions: String?
    let shippable: Bool?
    let statementDescriptor: String?
    let taxCode: String?
    let type: String
    let unitLabel: String?
    let updated: Int
    let url: String?

    // Coding keys to match JSON keys with different property names in Swift
    private enum CodingKeys: String, CodingKey {
        case id, object, active, attributes, created
        case defaultPrice = "default_price"
        case description, images, livemode
        case marketingFeatures = "marketing_features"
        case metadata, name
        case packageDimensions = "package_dimensions"
        case shippable, statementDescriptor = "statement_descriptor"
        case taxCode = "tax_code"
        case type, unitLabel = "unit_label"
        case updated, url
    }
    static func toJSON(product: Product) -> Data {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted // Optional: for human-readable JSON
        
        do {
            let jsonData = try encoder.encode(product)
            return jsonData
        } catch {
            print("Error encoding Product: \(error.localizedDescription)")
            return Data()
        }
    }
}

// MARK: - MarketingFeature Struct

struct MarketingFeature: Codable {
    let name: String
}

