import Depin
import UIKit
import XCoordinator

final class PaymentsCoordinator: NavigationCoordinator<PaymentsRoute> {

    init(
        rootViewController: UINavigationController = UINavigationController(),
        initialRoute: PaymentsRoute = .initial
    ) {
        super.init(
            rootViewController: rootViewController,
            initialRoute: initialRoute
        )
    }

    override func prepareTransition(for route: PaymentsRoute) -> NavigationTransition {
        switch route {
        case .initial:
            let viewController = moduleBuilder.build(.newPayment(router: strongRouter))
            return .set([viewController])
        }
    }
}
