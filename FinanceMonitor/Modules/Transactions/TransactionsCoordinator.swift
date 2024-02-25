import Depin
import UIKit
import XCoordinator

final class TransactionsCoordinator: NavigationCoordinator<TransactionsRoute> {

    init(
        rootViewController: UINavigationController = UINavigationController(),
        initialRoute: TransactionsRoute = .initial
    ) {
        super.init(
            rootViewController: rootViewController,
            initialRoute: initialRoute
        )
    }

    override func prepareTransition(for route: TransactionsRoute) -> NavigationTransition {
        switch route {
        case .initial:
            let viewController = moduleBuilder.build(.transactions(router: strongRouter))
            return .set([viewController])
        }
    }
}
