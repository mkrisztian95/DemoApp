import UIKitPlus

@IBDesignable
final class TransactionsHeaderView: BaseNibView {

    // MARK: - ViewState

    struct ViewState {
        let balance: String
        let creditBalance: String
        let ownBalance: String
        let isPriceHidden: Bool
    }

    // MARK: - IBOutlets

    @IBOutlet private var heightConstraint: NSLayoutConstraint!

    @IBOutlet private var priceLabelCenterConstraint: NSLayoutConstraint! {
        didSet {
            priceLabelCenterConstraint.isActive = false
        }
    }

    @IBOutlet private var overallBalanceLeadingConstraint: NSLayoutConstraint! {
        didSet {
            overallBalanceLeadingConstraint.isActive = true
        }
    }

    @IBOutlet private var overallBalanceLabel: PriceLabel! {
        didSet {
            overallBalanceLabel.textColor = .black950
        }
    }

    @IBOutlet private var creditBalanceLabel: PriceLabel! {
        didSet {
            creditBalanceLabel.textColor = .black950
        }
    }

    @IBOutlet private var ownBalanceLabel: PriceLabel! {
        didSet {
            ownBalanceLabel.textColor = .black950
        }
    }

    // MARK: - Public Methods

    func apply(_ viewState: ViewState) {
        overallBalanceLabel.set(with: viewState.balance, and: viewState.isPriceHidden)
        creditBalanceLabel.set(with: viewState.creditBalance, and: viewState.isPriceHidden)
        ownBalanceLabel.set(with: viewState.ownBalance, and: viewState.isPriceHidden)
        heightConstraint.constant = maxHeight
    }
}

// MARK: - ScrollLayoutChangeResponder

extension TransactionsHeaderView: ScrollLayoutChangeResponder {

    var currentHeight: CGFloat {
        heightConstraint.constant
    }

    func updateLayout(_ normalised: Float) {
        if normalised == 0 {
            priceLabelCenterConstraint.isActive = true
            overallBalanceLeadingConstraint.isActive = false
        } else {
            overallBalanceLeadingConstraint.isActive = true
            priceLabelCenterConstraint.isActive = false
        }

        UIView.animate(withDuration: 0.3) {
            self.creditBalanceLabel.layer.opacity = normalised
            self.ownBalanceLabel.layer.opacity = normalised
            self.layoutIfNeeded()
        }
    }

    func setHeight(_ height: CGFloat) {
        heightConstraint.constant = height
    }
}
