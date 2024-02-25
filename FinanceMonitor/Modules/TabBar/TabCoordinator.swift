import Depin
import UIKit
import XCoordinator

enum TabRoute: Route {
    case transactions
    case newPayment
    case settings
}

final class TabCoordinator: XCoordinator.TabBarCoordinator<TabRoute> {

    @Injected var moduleBuilder: ModuleBuilder

    private let transactionsRouter: StrongRouter<TransactionsRoute>
    private let newPaymentRouter: StrongRouter<PaymentsRoute>
    private let settingsRouter: StrongRouter<SettingsRoute>

    init() {
        UITabBar.appearance().tintColor = UIColor.black950
        UITabBar.appearance().unselectedItemTintColor = UIColor.black950.withAlphaComponent(0.5)

        let transactionsCoordinator = TransactionsCoordinator()
        let newPaymentCoordinator = PaymentsCoordinator()
        let settingsCoordinator = SettingsCoordinator()

        transactionsCoordinator.rootViewController.tabBarItem = TabBarItem(with: TabItem.transactions)
        newPaymentCoordinator.rootViewController.tabBarItem = TabBarItem(with: TabItem.payments)
        settingsCoordinator.rootViewController.tabBarItem = TabBarItem(with: TabItem.settings)

        transactionsRouter = transactionsCoordinator.strongRouter
        newPaymentRouter = newPaymentCoordinator.strongRouter
        settingsRouter = settingsCoordinator.strongRouter

        super.init(
            tabs: [
                newPaymentCoordinator.strongRouter,
                transactionsCoordinator.strongRouter,
                settingsCoordinator.strongRouter
            ],
            select: transactionsCoordinator.strongRouter
        )
    }

    override func prepareTransition(for route: TabRoute) -> TabBarTransition {
        switch route {
        case .transactions:
            return .select(transactionsRouter)
        case .newPayment:
            return .select(newPaymentRouter)
        case .settings:
            return .select(settingsRouter)
        }
    }
}
