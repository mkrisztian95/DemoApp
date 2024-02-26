import Combine

@testable import FinanceMonitor

// MARK: - TransactionsNetworkServiceProtocolMock -

final class TransactionsNetworkServiceProtocolMock: TransactionsNetworkServiceProtocol {

   // MARK: - getTransactions

    var getTransactionsCallsCount = 0
    var getTransactionsCalled: Bool {
        getTransactionsCallsCount > 0
    }
    var getTransactionsReturnValue: AnyPublisher<[TransactionEntity], APIError>!
    var getTransactionsClosure: (() -> AnyPublisher<[TransactionEntity], APIError>)?

    func getTransactions() -> AnyPublisher<[TransactionEntity], APIError> {
        getTransactionsCallsCount += 1
        return getTransactionsClosure.map({ $0() }) ?? getTransactionsReturnValue
    }
}
