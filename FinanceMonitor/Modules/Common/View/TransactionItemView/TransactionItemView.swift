import UIKitPlus

final class TransactionItemView: BaseNibView {

    // MARK: - ViewState

    struct ViewState {
        let category: String
        let price: String
        let date: String
        let summary: String
        let icon: UIImage
        let isHiddenPrice: Bool
    }

    // MARK: - IBOutlet

    @IBOutlet private var iconImageView: UIImageView! {
        didSet {
            iconImageView.tintColor = .black950
        }
    }

    @IBOutlet private var categoryLabel: UILabel! {
        didSet {
            categoryLabel.textColor = .black950
        }
    }

    @IBOutlet private var priceLabel: PriceLabel! {
        didSet {
            priceLabel.textColor = .black950
        }
    }

    @IBOutlet private var dateLabel: UILabel! {
        didSet {
            dateLabel.textColor = .black950
        }
    }

    @IBOutlet private var summaryLabel: UILabel! {
        didSet {
            summaryLabel.textColor = .black950
            summaryLabel.numberOfLines = 0
        }
    }

    // MARK: - Public Methods

    @discardableResult
    func apply(_ viewState: ViewState) -> Self {
        iconImageView.image = viewState.icon
            .withRenderingMode(.alwaysTemplate)

        categoryLabel.text = viewState.category
        dateLabel.text = viewState.date
        summaryLabel.text = viewState.summary
        priceLabel.set(with: viewState.price, and: viewState.isHiddenPrice)
        return self
    }
}
