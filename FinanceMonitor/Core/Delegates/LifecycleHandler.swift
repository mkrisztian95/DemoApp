import Depin
import UIKit
import XCoordinator

class LifecycleHandler: UIApplicationLifeCycleDelegate {

    @Injected private var lifecycleEventProvider: LifecycleEventConfiguratorProtocol

    private var window: UIWindow?
    private var splashWindow: UIWindow?

    func application(
        _ application: UIApplication,
        willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        window = AppWindow()
         return true
    }

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        start()

        return true
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        lifecycleEventProvider.set(isActive: true)
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        lifecycleEventProvider.set(isActive: false)
    }

    func applicationWillResignActive(_ application: UIApplication) {
        lifecycleEventProvider.set(isActive: false)
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        lifecycleEventProvider.set(isActive: true)
    }
}

private extension LifecycleHandler {

    func start() {
        let splashVC = UIStoryboard(name: "LaunchScreen", bundle: .main).instantiateInitialViewController()
        splashWindow = UIWindow(frame: UIScreen.main.bounds)
        splashWindow?.rootViewController = splashVC
        splashWindow?.windowLevel = .statusBar + 1
        splashWindow?.makeKeyAndVisible()

        window.map {
            AuthCoordinator().strongRouter.setRoot(for: $0)
//            TabCoordinator().strongRouter.setRoot(for: $0)
        }

        UIView.animate(withDuration: 0.3) {
            self.splashWindow?.alpha = 0
        } completion: { _ in
            self.splashWindow = nil
        }
    }
}
