import Foundation
import Nimble
import Quick
import CombinePlus

@testable import FinanceMonitor

class TransactionsContainerSpecs: QuickSpec {

    typealias TransactionsCategory = TransactionEntity.TransactionCategory

    override func spec() {

        describe("TransactionsContainerSpecs") {
            
            var getTransactionsUseCase: GetTransactionsUseCaseProtocol!

            context("Context description") {

                let mockNetworking = TransactionsNetworkServiceProtocolMock()
                var cancellable: AnyCancellable?

                beforeEach {
                    getTransactionsUseCase = GetTransactionsUseCase(networkService: mockNetworking)
                }
                
                // MARK: - Test Empty Transactions Model

                it("Test Empty Transactions Model") {
                    mockNetworking.getTransactionsReturnValue = .createJust(value: [])
                    var expectedTransactionModel: TransactionModel?
                    
                    expect {
                        cancellable = getTransactionsUseCase
                            .transactionsPublisher
                            .sink { transactionModel in
                                expectedTransactionModel = transactionModel
                            }

                        getTransactionsUseCase.fetchTransactions()

                        return expectedTransactionModel?.items
                    }.to(equal([]))

                    cancellable?.cancel()
                }

                // MARK: - Test Transaction Model Aggregated Value

                it("Test Transaction Model Aggregated Value") {

                    mockNetworking.getTransactionsReturnValue = .createJust(value: [
                        .testDefault(category: TransactionsCategory.clothing, sum: 10.0),
                        .testDefault(category: TransactionsCategory.clothing, sum: 21.0),
                        .testDefault(category: TransactionsCategory.clothing, sum: 12.0),
                        .testDefault(category: TransactionsCategory.food, sum: 15.0),
                        .testDefault(category: TransactionsCategory.food, sum: 18.0),
                        .testDefault(category: TransactionsCategory.housing, sum: 12.0),
                        .testDefault(category: TransactionsCategory.housing, sum: 32.0),
                        .testDefault(category: TransactionsCategory.housing, sum: 19.0),
                    ])
                    var expectedAggregated: [String: Double]?

                    expect {
                        cancellable = getTransactionsUseCase
                            .transactionsPublisher
                            .sink { transactionModel in
                                expectedAggregated = transactionModel.aggregatedAverage
                            }

                        getTransactionsUseCase.fetchTransactions()

                        return expectedAggregated
                    }.to(equal([
                        TransactionsCategory.clothing.rawValue: 43.0,
                        TransactionsCategory.food.rawValue: 33.0,
                        TransactionsCategory.housing.rawValue: 63.0
                    ]))

                    cancellable?.cancel()
                }

                // MARK: - Test Adding Filters

                it("Test Adding Filters") {

                    mockNetworking.getTransactionsReturnValue = .createJust(value: [
                        .testDefault(category: TransactionsCategory.clothing, sum: 10.0),
                        .testDefault(category: TransactionsCategory.clothing, sum: 21.0),
                        .testDefault(category: TransactionsCategory.clothing, sum: 12.0),
                        .testDefault(category: TransactionsCategory.food, sum: 15.0),
                        .testDefault(category: TransactionsCategory.food, sum: 18.0),
                        .testDefault(category: TransactionsCategory.housing, sum: 12.0),
                        .testDefault(category: TransactionsCategory.housing, sum: 32.0),
                        .testDefault(category: TransactionsCategory.housing, sum: 19.0),
                    ])
                    var expectedTransactionModel: TransactionModel?

                    expect {
                        cancellable = getTransactionsUseCase
                            .transactionsPublisher
                            .sink { transactionModel in
                                expectedTransactionModel = transactionModel
                            }

                        getTransactionsUseCase.fetchTransactions()
                        getTransactionsUseCase.toggleFilter(.food)
                        return expectedTransactionModel?.items.count
                    }.to(equal(2))

                    cancellable?.cancel()
                }

                // MARK: - Test Adding/Removing Filters

                it("Test Adding/Removing Filters") {

                    mockNetworking.getTransactionsReturnValue = .createJust(value: [
                        .testDefault(category: TransactionsCategory.clothing, sum: 10.0),
                        .testDefault(category: TransactionsCategory.clothing, sum: 21.0),
                        .testDefault(category: TransactionsCategory.clothing, sum: 12.0),
                        .testDefault(category: TransactionsCategory.food, sum: 15.0),
                        .testDefault(category: TransactionsCategory.food, sum: 18.0),
                        .testDefault(category: TransactionsCategory.housing, sum: 12.0),
                        .testDefault(category: TransactionsCategory.housing, sum: 32.0),
                        .testDefault(category: TransactionsCategory.housing, sum: 19.0),
                    ])
                    var expectedTransactionModel: TransactionModel?

                    expect {
                        cancellable = getTransactionsUseCase
                            .transactionsPublisher
                            .sink { transactionModel in
                                expectedTransactionModel = transactionModel
                            }

                        getTransactionsUseCase.fetchTransactions()
                        getTransactionsUseCase.toggleFilter(.food)
                        getTransactionsUseCase.toggleFilter(.food)
                        return expectedTransactionModel?.items.count
                    }.to(equal(8))

                    cancellable?.cancel()
                }

                // MARK: - Test Adding/Removing/Adding New Filters

                it("Test Adding/Removing/Adding New Filters") {

                    mockNetworking.getTransactionsReturnValue = .createJust(value: [
                        .testDefault(category: TransactionsCategory.clothing, sum: 10.0),
                        .testDefault(category: TransactionsCategory.clothing, sum: 21.0),
                        .testDefault(category: TransactionsCategory.clothing, sum: 12.0),
                        .testDefault(category: TransactionsCategory.food, sum: 15.0),
                        .testDefault(category: TransactionsCategory.food, sum: 18.0),
                        .testDefault(category: TransactionsCategory.housing, sum: 12.0),
                        .testDefault(category: TransactionsCategory.housing, sum: 32.0),
                        .testDefault(category: TransactionsCategory.housing, sum: 19.0),
                    ])
                    var expectedTransactionModel: TransactionModel?

                    expect {
                        cancellable = getTransactionsUseCase
                            .transactionsPublisher
                            .sink { transactionModel in
                                expectedTransactionModel = transactionModel
                            }

                        getTransactionsUseCase.fetchTransactions()
                        getTransactionsUseCase.toggleFilter(.food)
                        getTransactionsUseCase.toggleFilter(.food)
                        getTransactionsUseCase.toggleFilter(.housing)
                        return expectedTransactionModel?.items.count
                    }.to(equal(3))

                    cancellable?.cancel()
                }
            }
        }
    }
}

private extension TransactionEntity {

    static func testDefault(
        id: String = "1",
        summary: String = "TestSummary",
        category: TransactionCategory = .unknown,
        sum: Double = 100.0,
        currency: String = "HUF",
        paid: Date = Date.now
    ) -> TransactionEntity {
        .init(id: id, summary: summary, category: category, sum: sum, currency: currency, paid: paid)
    }
}

