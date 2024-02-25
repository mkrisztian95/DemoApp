import CombinePlus
import Depin
import XCoordinator

protocol TransactionsListPresenterProtocol { }

final class TransactionsListPresenter<
    View: TransactionsListViewProtocol,
    Route: StrongRouter<TransactionsRoute>,
    ViewStateFactory: TransactionsListViewStateFactory>: BasePresenter<View, Route, ViewStateFactory> {

    // MARK: - Injected Properties

    @Injected private var useCase: GetTransactionsUseCaseProtocol

    // MARK: - Private Properties

    private var allCategories: [TransactionEntity.TransactionCategory] = []
    private var isCardViewHidden = false

    init(
        router: Route,
        view: View
    ) {
        super.init(view: view, router: router)
        bind()

    }

    deinit {
        print(" ☠️☠️☠️ DEINIT: \(String(describing: self))")
    }
}

// MARK: - TransactionsListPresenter

private extension TransactionsListPresenter {
    func bind() {
        view.viewDidLoadPublisher
            .sink { [unowned self] in
                bindOnLoad()
                view.isLoading = true
                useCase.fetchTransactions()
            }
            .store(in: &bag)
    }

    func bindOnLoad() {
        useCase.transactionsPublisher
            .assertNoFailure()
            .perform { [weak self] in
                guard let self else { return }
                if allCategories.isEmpty {
                    allCategories = Array(Set($0.items.map { $0.category }))
                }
            }
            .combineLatest(hidePricePublisher)
            .compactMap { [weak self] transactions, isPriceHidden -> TransactionsListViewController.ViewState? in
                guard let self else { return nil }
                return factory.make(
                    from: transactions,
                    with: allCategories,
                    and: isPriceHidden
                )
            }
            .onMain()
            .sink { [unowned self] viewState in
                view.apply(viewState)
                view.isLoading = false
            }
            .store(in: &bag)

        view.filterPublisher
            .sink { [unowned self] in
                useCase.toggleFilter($0)
            }
            .store(in: &bag)
    }
}

// MARK: - TransactionsListPresenterProtocol

extension TransactionsListPresenter: TransactionsListPresenterProtocol { }
