import UIKit
import XCoordinator

extension XCoordinator.Transition {

    static func presentOnRoot(
        _ presentable: Presentable,
        modalPresentationStyle: UIModalPresentationStyle? = nil,
        modalTransitionStyle: UIModalTransitionStyle? = nil,
        animation: Animation? = nil
    ) -> Self {
        if let modalPresentationStyle {
            presentable.viewController?.modalPresentationStyle = modalPresentationStyle
        }
        if let modalTransitionStyle {
            presentable.viewController?.modalTransitionStyle = modalTransitionStyle
        }
        return .presentOnRoot(presentable, animation: animation)
    }

    static func present(
        _ presentable: Presentable,
        modalPresentationStyle: UIModalPresentationStyle? = nil,
        modalTransitionStyle: UIModalTransitionStyle? = nil,
        animation: Animation? = nil
    ) -> Self {
        if let modalPresentationStyle {
            presentable.viewController?.modalPresentationStyle = modalPresentationStyle
        }
        if let modalTransitionStyle {
            presentable.viewController?.modalTransitionStyle = modalTransitionStyle
        }
        return .present(presentable, animation: animation)
    }

    static func none(_ presentable: Presentable) -> Transition {
        .none()
    }
}
