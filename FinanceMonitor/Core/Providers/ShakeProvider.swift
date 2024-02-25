import CombinePlus

protocol ShakeProviderProtocol {
    func didShakeDevice()

    var didShakeDevicePublisher: AnyPublisher<Void, Never> { get }
}

final class ShakeProvider {

    private let didShakeSubject = PassthroughSubject<Void, Never>()
}

extension ShakeProvider: ShakeProviderProtocol {

    var didShakeDevicePublisher: AnyPublisher<Void, Never> {
        didShakeSubject.eraseToAnyPublisher()
    }

    func didShakeDevice() {
        didShakeSubject.send()
    }
}
