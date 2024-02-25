import UIKit

enum TabItem: Int {
    case settings
    case payments
    case transactions
}

extension TabItem: TabItemPresentable {

    var titleKey: I18n.StringKey {
        switch self {
        case .settings:
                .settings
        case .payments:
                .payments
        case .transactions:
                .transactions
        }
    }

    var icon: UIImage {
        switch self {
        case .settings:
            UIImage(resource: .settingsTabIcon)
        case .payments:
            UIImage(resource: .paymentTabIcon)
        case .transactions:
            UIImage(resource: .transactionsTabIcon)
        }
    }

    var imageInset: UIEdgeInsets {
        switch self {
        case .settings:
                .zero
        case .payments:
                .zero
        case .transactions:
                .init(top: 10, left: 0, bottom: 0, right: 0)
        }
    }

    var tag: Int {
        rawValue
    }
}
