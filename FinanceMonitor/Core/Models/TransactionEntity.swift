import Foundation

struct TransactionEntity: Decodable {
    enum TransactionCategory: String, Decodable, CustomStringConvertible {
        case housing
        case travel
        case food
        case utilities
        case insurance
        case healthcare
        case financial
        case lifestyle
        case entertainment
        case miscellaneous
        case clothing
        case unknown

        var description: String {
            rawValue
        }
    }

    let id: String
    let summary: String
    let category: TransactionCategory
    let sum: Double
    let currency: String
    let paid: Date

    enum CodingKeys: String, CodingKey {
        case id, summary, category, sum, currency, paid
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        summary = try container.decode(String.self, forKey: .summary)
        category = try container.decodeIfPresent(TransactionCategory.self, forKey: .category) ?? .unknown
        sum = try container.decode(Double.self, forKey: .sum)
        currency = try container.decode(String.self, forKey: .currency)

        let paidString = try container.decode(String.self, forKey: .paid)
        let formatter = ISO8601DateFormatter()
        paid = formatter.date(from: paidString) ?? Date()
    }

    init(id: String, summary: String, category: TransactionCategory, sum: Double, currency: String, paid: Date) {
        self.id = id
        self.summary = summary
        self.category = category
        self.sum = sum
        self.currency = currency
        self.paid = paid
    }
}
