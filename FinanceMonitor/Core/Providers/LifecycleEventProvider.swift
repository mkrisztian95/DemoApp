import CombinePlus

protocol LifecycleEventListenerProtocol {

    var didBecomeActivePublisher: AnyPublisher<Void, Never> { get }
    var didBecomeInActivePublisher: AnyPublisher<Void, Never> { get }
}

protocol LifecycleEventConfiguratorProtocol {

    func set(isActive: Bool)
}

final class LifecycleEventProvider {

    private let isActiveSubject = PassthroughSubject<Bool, Never>()
}

extension LifecycleEventProvider: LifecycleEventConfiguratorProtocol {

    func set(isActive: Bool) {
        isActiveSubject.send(isActive)
    }
}

extension LifecycleEventProvider: LifecycleEventListenerProtocol {

    var didBecomeActivePublisher: AnyPublisher<Void, Never> {
        isActiveSubject
            .filter {
                $0
            }
            .void()
            .eraseToAnyPublisher()
    }

    var didBecomeInActivePublisher: AnyPublisher<Void, Never> {
        isActiveSubject
            .filter {
                !$0
            }
            .void()
            .eraseToAnyPublisher()
    }
}
