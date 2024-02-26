import CombinePlus
import Foundation

protocol GetTransactionsUseCaseProtocol {
    var transactionsPublisher: AnyPublisher<TransactionModel, Never> { get }

    func fetchTransactions()
    func toggleFilter(_ filter: TransactionEntity.TransactionCategory)
}

final class GetTransactionsUseCase {

    private let networkService: TransactionsNetworkServiceProtocol

    private var bag = CancelBag()

    @Published private var selectedFilters: [TransactionEntity.TransactionCategory] = []
    @Published private var transactions: TransactionModel?

    init(networkService: TransactionsNetworkServiceProtocol) {
        self.networkService = networkService
    }
}

extension GetTransactionsUseCase: GetTransactionsUseCaseProtocol {
    func toggleFilter(_ filter: TransactionEntity.TransactionCategory) {
        if let idx = selectedFilters.firstIndex(of: filter) {
            selectedFilters.remove(at: idx)
        } else {
            selectedFilters.append(filter)
        }
    }

    var transactionsPublisher: AnyPublisher<TransactionModel, Never> {
        Publishers.CombineLatest($transactions, $selectedFilters)
            .map { model, filters -> TransactionModel? in
                guard let model else { return nil }
                return filters.isEmpty ? model : TransactionModel(
                    items: model.items.filter {
                        filters.contains($0.category)
                    },
                    aggregatedAverage: model.aggregatedAverage
                )
            }
            .compactMap { $0 }
            .eraseToAnyPublisher()
    }

    func fetchTransactions() {
        networkService
            .getTransactions()
            .ignoreFailure()
            .map { TransactionModel(from: $0) }
            .assignNoRetain(to: \.transactions, on: self)
            .store(in: &bag)
    }
}
