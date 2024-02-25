import Foundation

enum TransactionsEndpoint: Endpoint {

    case transactions

    var host: String {
        switch Environment.current {
        case .testing:
            "https://wetick-876d1-default-rtdb.europe-west1.firebasedatabase.app"
        case .production:
            "https://wetick-876d1-default-rtdb.europe-west1.firebasedatabase.app"
        }
    }

    var path: String {
        switch self {
        case .transactions:
            "/transactions.json"
        }
    }

    var queryItems: [URLQueryItem]? {
        switch self {
        case .transactions:
            nil
        }
    }

    var method: HTTPMethod {
        switch self {
        case .transactions:
                .get
        }
    }

    var body: Encodable? {
        switch self {
        case .transactions:
            nil
        }
    }
}
