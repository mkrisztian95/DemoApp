import CombinePlus

class TransactionsNetworkService: NetworkService<TransactionsEndpoint> {

    func getTransactions() -> AnyPublisher<[TransactionEntity], APIError> {
        request(TransactionsEndpoint.transactions)
    }
}
