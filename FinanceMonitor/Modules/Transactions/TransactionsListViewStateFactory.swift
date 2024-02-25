import UIKit

final class TransactionsListViewStateFactory: BaseViewStateFactory {

    typealias ViewState = TransactionsListViewController.ViewState

    func make(
        from transactionModel: TransactionModel,
        with categories: [TransactionEntity.TransactionCategory],
        and isHiddenPrice: Bool
    ) -> ViewState {
        ViewState(
            transactionsViewState: transactionModel.items.map {
                TransactionItemView.ViewState(
                    category: $0.category.rawValue,
                    price: formatCurrency(amount: $0.sum, code: $0.currency),
                    date: $0.paid.date(with: .short),
                    summary: $0.summary,
                    icon: UIImage(resource: getIcon(for: $0.category)),
                    isHiddenPrice: isHiddenPrice
                )
            },
            availableCategories: categories,
            activeCategories: Array(Set(transactionModel.items.map { $0.category })),
            balanceHeaderViewSate: .init(
                balance: formatCurrency(amount: 1200000, code: baseCurrency(from: transactionModel)),
                creditBalance: i18n.str(.creditBalance(formatCurrency(
                    amount: 200000,
                    code: baseCurrency(from: transactionModel)
                ))),
                ownBalance: i18n.str(.creditBalance(formatCurrency(
                    amount: 1000000,
                    code: baseCurrency(from: transactionModel)
                ))),
                isPriceHidden: isHiddenPrice
            ),
            cardViewState: .init(
                cardNumber: "1234 1234 1234 1234",
                cardHolder: "John Doe",
                cardExpiration: "12/12",
                cardCVV: "123"
            )
        )
    }

    private func getIcon(for category: TransactionEntity.TransactionCategory) -> ImageResource {
        switch category {
        case .housing:
                .icHousing
        case .travel:
                .icTravel
        case .food:
                .icFood
        case .clothing:
                .icClothing
        default:
                .icSpend
        }
    }

    private func baseCurrency(from transactionModel: TransactionModel) -> String {
        transactionModel.items.first?.currency ?? "HUF"
    }
}
