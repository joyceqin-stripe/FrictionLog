//
//  Price.swift
//  FrictionLog
//
//  Created by Joyce Qin on 8/22/24.
//

import Foundation

struct Price: Codable {
    let id: String
    let object: String
    let active: Bool
    let billingScheme: String
    let created: Int
    let currency: String
    let customUnitAmount: Int?
    let livemode: Bool
    let lookupKey: String?
    let metadata: [String: String]
    let nickname: String?
    let product: String
    let recurring: Recurring?
    let taxBehavior: String?
    let tiersMode: String?
    let transformQuantity: String?
    let type: String
    let unitAmount: Int?
    let unitAmountDecimal: String?
    // Coding keys to match JSON keys with different property names in Swift
    private enum CodingKeys: String, CodingKey {
        case id, object, active, billingScheme = "billing_scheme"
        case created, currency, customUnitAmount = "custom_unit_amount"
        case livemode, lookupKey = "lookup_key"
        case metadata, nickname, product, recurring, taxBehavior = "tax_behavior"
        case tiersMode = "tiers_mode"
        case transformQuantity = "transform_quantity"
        case type, unitAmount = "unit_amount"
        case unitAmountDecimal = "unit_amount_decimal"
    }
}

struct Recurring: Codable {
    let aggregateUsage: String?
    let interval: String
    let intervalCount: Int
    let trialPeriodDays: Int?
    let usageType: String
    private enum CodingKeys: String, CodingKey {
        case aggregateUsage = "aggregate_usage"
        case interval, intervalCount = "interval_count"
        case trialPeriodDays = "trial_period_days"
        case usageType = "usageType"
    }
}
