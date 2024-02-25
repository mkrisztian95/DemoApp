import FoundationPlus

class I18n {

    enum StringKey {
        case creditBalance(String)
        case ownBalance(String)
        case settings
        case payments
        case transactions
    }

    func str(_ key: StringKey) -> String {
        switch key {
        case .creditBalance(let string):
            "credit_balance".localized(arguments: string)
        case .ownBalance(let string):
            "own_balance".localized(arguments: string)
        case .settings:
            "settings".localized()
        case .payments:
            "payments".localized()
        case .transactions:
            "transactions".localized()
        }
    }
}
