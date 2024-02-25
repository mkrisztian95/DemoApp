import AVFoundationPlus
import Depin

class UseCasesAssembly: Assembly {

    func assemble(container: Swinject.Container) {

        container.register(GetTransactionsUseCaseProtocol.self) { r in
            GetTransactionsUseCase(
                networkService: r ~> TransactionsNetworkService.self
            )
        }
    }
}
