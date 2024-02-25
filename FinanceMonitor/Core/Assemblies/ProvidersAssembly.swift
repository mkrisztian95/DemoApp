import AVFoundationPlus
import Depin

class ProvidersAssembly: Assembly {

    func assemble(container: Swinject.Container) {

        container.register(ShakeProviderProtocol.self) {
            ShakeProvider()
        }
        .inObjectScope(.container)

        container.register(AuthenticationProviderProtocol.self) {
            AuthenticationProvider()
        }

        container.register(LifecycleEventProvider.self) {
            LifecycleEventProvider()
        }
        .inObjectScope(.container)
        .implements(LifecycleEventListenerProtocol.self, LifecycleEventConfiguratorProtocol.self)
    }
}
