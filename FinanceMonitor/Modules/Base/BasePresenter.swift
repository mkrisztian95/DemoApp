import CombinePlus
import Depin
import Foundation
import XCoordinator

protocol BasePresenterProtocol {}

class BasePresenter<V: BaseViewProtocol, R: Router, VS: BaseViewStateFactory> {

    @Injected var factory: VS
    @Injected private var shakeProvider: ShakeProviderProtocol
    @Injected private var lifecycleEventsProvider: LifecycleEventListenerProtocol

    unowned let view: V
    let router: R
    var bag = CancelBag()

    var hidePricePublisher: AnyPublisher<Bool, Never> {
        $isPriceHidden.eraseToAnyPublisher()
    }

    @Published private var isPriceHidden = false

    init(view: V, router: R) {
        self.view = view
        self.router = router

        bindShakePublisher()
        bindLifecycleEvents()
    }

    func bindShakePublisher() {
        shakeProvider
            .didShakeDevicePublisher
            .sink { [weak self] in
                guard let self else { return }
                isPriceHidden.toggle()
            }
            .store(in: &bag)
    }

    func bindLifecycleEvents() {
        lifecycleEventsProvider
            .didBecomeActivePublisher
            .sink { [weak self] in
                self?.view.removeBlur()
            }
            .store(in: &bag)

        lifecycleEventsProvider
            .didBecomeInActivePublisher
            .sink { [weak self] in
                self?.view.blurBackground()
            }
            .store(in: &bag)
    }

}

extension BasePresenter: BasePresenterProtocol {}
