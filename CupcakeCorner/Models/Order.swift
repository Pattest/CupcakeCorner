//
//  Order.swift
//  CupcakeCorner
//
//  Created by Baptiste Cadoux on 20/09/2021.
//

import Foundation

class Order: ObservableObject, Codable {
    static let types = ["Vanilla", "Strawberry", "Chocolate", "Rainbow"]
    
    @Published var type = 0
    @Published var quantity = 3

    @Published var specialRequestEnabled = false {
        didSet {
            if specialRequestEnabled == false {
                extraFrosting = false
                addSprinkles = false
            }
        }
    }
    @Published var extraFrosting = false
    @Published var addSprinkles = false

    @Published var name = ""
    @Published var streetAddress = ""
    @Published var city = ""
    @Published var zip = ""

    var hasValidAddress: Bool {
        if name.isEmpty || streetAddress.isEmpty ||
            city.isEmpty || zip.isEmpty {
            return false
        }

        return true
    }

    var cost: Double {
        // $2 per cake
        var cost = Double(quantity) * 2

        // complicated cakes cost more
        cost += (Double(type) / 2)

        // $1/cake for extra frosting
        if extraFrosting {
            cost += Double(quantity)
        }

        // $0.50/cake for sprinkles
        if addSprinkles {
            cost += Double(quantity) / 2
        }

        return cost
    }

    // MARK: - Initializer

    init() {}
    
    // MARK: - Codable

    enum CodingKeys: CodingKey {
        case type
        case quantity
        case extraFrosting
        case addSprinkles
        case name
        case streetAddress
        case city
        case zip
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.type = try container.decode(Int.self, forKey: .type)
        self.quantity = try container.decode(Int.self, forKey: .quantity)

        self.extraFrosting = try container.decode(Bool.self, forKey: .extraFrosting)
        self.addSprinkles = try container.decode(Bool.self, forKey: .addSprinkles)

        self.name = try container.decode(String.self, forKey: .name)
        self.streetAddress = try container.decode(String.self, forKey: .streetAddress)
        self.city = try container.decode(String.self, forKey: .city)
        self.zip = try container.decode(String.self, forKey: .zip)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(type, forKey: .type)
        try container.encode(quantity, forKey: .quantity)
        
        try container.encode(extraFrosting, forKey: .extraFrosting)
        try container.encode(addSprinkles, forKey: .addSprinkles)
        
        try container.encode(name, forKey: .name)
        try container.encode(streetAddress, forKey: .streetAddress)
        try container.encode(city, forKey: .city)
        try container.encode(zip, forKey: .zip)
    }
}
