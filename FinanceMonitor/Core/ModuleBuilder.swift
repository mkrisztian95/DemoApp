import Depin
import UIKit
import XCoordinator

class ModuleBuilder {

    // MARK: - Injected properties

    enum Module {
        case transactions(
            router: StrongRouter<TransactionsRoute>
        )
        case newPayment(
            router: StrongRouter<PaymentsRoute>
        )
        case settings(
            router: StrongRouter<SettingsRoute>
        )
        case login(
            router: StrongRouter<AuthRoute>
        )
    }

    func build(_ module: Module) -> UIViewController {
        switch module {

        case let .transactions(router):
            let view = TransactionsListViewController()
            let presenter = TransactionsListPresenter(
                router: router,
                view: view
            )

            view.presenter = presenter
            return view

        case .newPayment:

            return BaseViewController()

        case .settings:

            return BaseViewController()

        case .login(let router):
            let view = AuthViewController()
            let presenter = AuthPresenter(
                router: router,
                view: view
            )
            view.presenter = presenter
            return view
        }
    }
}
