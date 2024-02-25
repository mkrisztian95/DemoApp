import AVFoundationPlus
import Depin

class ViewStateAssembly: Assembly {

    func assemble(container: Swinject.Container) {

        container.register(TransactionsListViewStateFactory.self) {
            TransactionsListViewStateFactory()
        }

        container.register(AuthViewStateFactory.self) {
            AuthViewStateFactory()
        }
    }
}
