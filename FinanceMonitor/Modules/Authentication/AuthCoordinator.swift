import Depin
import UIKit
import XCoordinator

final class AuthCoordinator: NavigationCoordinator<AuthRoute> {

    init(
        rootViewController: UINavigationController = UINavigationController(),
        initialRoute: AuthRoute = .login
    ) {
        super.init(
            rootViewController: rootViewController,
            initialRoute: initialRoute
        )
    }

    override func prepareTransition(for route: AuthRoute) -> NavigationTransition {
        switch route {
        case .login:
            let viewController = moduleBuilder.build(.login(router: strongRouter))
            return .set([viewController])

        case .main:
            return .set([TabCoordinator()])
        }
    }
}
