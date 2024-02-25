import CombinePlus
import UIKitPlus

final class CardHeaderView: BaseNibView, ScrollLayoutChangeResponder {

    // MARK: - Constants

    enum Constant {
        static let minPadding: CGFloat = 24.0
        static let minCardWidth: CGFloat = 100.0
        static let maxFont: UIFont = .systemFont(ofSize: 28, weight: .bold)
        static let minFont: UIFont = .systemFont(ofSize: 16, weight: .semibold)
    }

    // MARK: - ViewState

    struct ViewState {
        let cardNumber: String
        let cardHolder: String
        let cardExpiration: String
        let cardCVV: String
    }

    // MARK: - Private Properties

    private var bag = CancelBag()
    private var flippable = true
    private var isFront = true {
        didSet {
            numberLabel.setHidden(!isFront, withDuration: 0.3)
            expirationLabel.setHidden(!isFront, withDuration: 0.3)
            holderLabel.setHidden(!isFront, withDuration: 0.3)
            cardBackView.setHidden(isFront, withDuration: 0.3, delay: isFront ? .zero : 0.2)
        }
    }

    // MARK: - Public Properties

    var currentHeight: CGFloat {
        heightConstraint.constant
    }

    // MARK: - IBOutlets

    @IBOutlet private var cardBackLeadingConstraint: NSLayoutConstraint!
    @IBOutlet private var cardLeadingConstraint: NSLayoutConstraint!
    @IBOutlet private var heightConstraint: NSLayoutConstraint!
    @IBOutlet private var trailingConstraint: NSLayoutConstraint!
    @IBOutlet private var numberCenterConstraint: NSLayoutConstraint!
    @IBOutlet private var cardBackView: UIView!

    @IBOutlet private var expirationLabel: UILabel! {
        didSet {
            expirationLabel.textColor = .black600
        }
    }

    @IBOutlet private var holderLabel: UILabel! {
        didSet {
            holderLabel.textColor = .black600
        }
    }

    @IBOutlet private var cvvLabel: UILabel! {
        didSet {
            cvvLabel.textColor = .constantWhite
        }
    }

    @IBOutlet private var numberLabel: UILabel! {
        didSet {
            numberLabel.textColor = .black600
            numberLabel.font = Constant.maxFont
        }
    }

    @IBOutlet private var numberTrailingConstraint: NSLayoutConstraint! {
        didSet {
            numberTrailingConstraint.isActive = false
        }
    }

    @IBOutlet private var cardFrontView: UIView! {
        didSet {
            cardFrontView.backgroundColor = .card
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        bind()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        bind()
    }

    // MARK: - Private Methods

    private func bind() {
        view.tapGesturePublisher(with: 2)
            .void()
            .filter { [unowned self] in flippable }
            .sink { [unowned self] in
                cardFrontView.flip()
                isFront.toggle()
            }
            .store(in: &bag)
    }

    // MARK: - Public Methods

    func updateLayout(_ normalised: Float) {
        let width = cardFrontView.bounds.width
        let multiplier = 1 - normalised
        let predictedTrailing = width * CGFloat(multiplier)
        var opacity: Float = normalised - 0.5

        if predictedTrailing <= Constant.minPadding {
            trailingConstraint.constant = Constant.minPadding
            numberCenterConstraint.isActive = true
            numberTrailingConstraint.isActive = false
            numberLabel.font = Constant.maxFont
            numberLabel.textColor = .black600
            numberLabel.textAlignment = .center
            flippable = true
            opacity = 1.0
        } else if predictedTrailing >= bounds.width - 2 * Constant.minPadding - Constant.minCardWidth {
            trailingConstraint.constant = bounds.width - Constant.minPadding - Constant.minCardWidth
            numberCenterConstraint.isActive = false
            numberTrailingConstraint.isActive = true
            numberLabel.font = Constant.minFont
            numberLabel.textColor = .constantWhite
            numberLabel.textAlignment = .right
            flippable = false
            opacity = 0.0
        }

        UIView.animate(withDuration: 0.3) {
            self.holderLabel.layer.opacity = opacity
            self.expirationLabel.layer.opacity = opacity
            self.layoutIfNeeded()
        }
    }

    func setHeight(_ height: CGFloat) {
        heightConstraint.constant = height
    }

    func apply(_ viewState: ViewState) {
        numberLabel.text = viewState.cardNumber
        holderLabel.text = viewState.cardHolder
        expirationLabel.text = viewState.cardExpiration
        cvvLabel.text = viewState.cardCVV
    }

    func updateCardLeading(with normalised: CGFloat) {
        cardLeadingConstraint.constant = -Constant.minPadding + (Constant.minPadding * 2) * normalised
        cardBackLeadingConstraint.constant = -Constant.minPadding + (Constant.minPadding * 2) * normalised
    }
}
