import CombinePlus

protocol TransactionsNetworkServiceProtocol {

    func getTransactions() -> AnyPublisher<[TransactionEntity], APIError>
}

class TransactionsNetworkService: NetworkService<TransactionsEndpoint>, TransactionsNetworkServiceProtocol {

    func getTransactions() -> AnyPublisher<[TransactionEntity], APIError> {
        request(TransactionsEndpoint.transactions)
    }
}
