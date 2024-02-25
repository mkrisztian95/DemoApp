import Depin
import UIKit
import XCoordinator

final class SettingsCoordinator: NavigationCoordinator<SettingsRoute> {

    init(
        rootViewController: UINavigationController = UINavigationController(),
        initialRoute: SettingsRoute = .initial
    ) {
        super.init(
            rootViewController: rootViewController,
            initialRoute: initialRoute
        )
    }

    override func prepareTransition(for route: SettingsRoute) -> NavigationTransition {
        switch route {
        case .initial:
            let viewController = moduleBuilder.build(.settings(router: strongRouter))
            return .set([viewController])
        }
    }
}
