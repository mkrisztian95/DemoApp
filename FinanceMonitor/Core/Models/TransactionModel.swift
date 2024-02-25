import Foundation

struct TransactionModel {

    struct TransactionItem {
        let id: String
        let summary: String
        let category: TransactionEntity.TransactionCategory
        let sum: Double
        let currency: String
        let paid: Date
    }

    var items: [TransactionItem]
    var aggregatedAverage: [String: Double]

    init(
        items: [TransactionItem],
        aggregatedAverage: [String: Double]
    ) {
        self.items = items
        self.aggregatedAverage = aggregatedAverage
    }

    init(from entities: [TransactionEntity]) {
        items = entities.map {
            TransactionItem(
                id: $0.id,
                summary: $0.summary,
                category: $0.category,
                sum: $0.sum,
                currency: $0.currency,
                paid: $0.paid
            )
        }
        var aggregated: [String: [Double]] = [:]
        for item in entities {
            aggregated[item.category.rawValue] = (aggregated[item.category.rawValue] ?? []) + [item.sum]
        }

        var combined: [String: Double] = [:]
        for (category, values) in aggregated {
            let average = values.reduce(0, +)
            combined[category] = average
        }

        self.aggregatedAverage = combined
    }
}
