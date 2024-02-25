import CombinePlus
import Lottie
import UIKitPlus

protocol TransactionsListViewProtocol: BaseViewProtocol {
    var filterPublisher: AnyPublisher<TransactionEntity.TransactionCategory, Never> { get }

    func apply(_ viewState: TransactionsListViewController.ViewState)
}

final class TransactionsListViewController: BaseViewController {

    // MARK: - ViewState

    struct ViewState {
        let transactionsViewState: [TransactionItemView.ViewState]?
        let availableCategories: [TransactionEntity.TransactionCategory]?
        let activeCategories: [TransactionEntity.TransactionCategory]?
        let balanceHeaderViewSate: TransactionsHeaderView.ViewState?
        let cardViewState: CardHeaderView.ViewState?
    }

    // MARK: - IBOutlets

    @IBOutlet private var cardHeaderView: CardHeaderView!
    @IBOutlet private var balanceHeaderView: TransactionsHeaderView!
    @IBOutlet private var headerStackView: UIStackView!
    @IBOutlet private var categoriesWrapper: UIView!
    @IBOutlet private var stackView: UIStackView!

    @IBOutlet private var loadingIndicator: LottieAnimationView! {
        didSet {
            loadingIndicator.animation = .named("loading")
            loadingIndicator.loopMode = .autoReverse
            loadingIndicator.play()
            loadingIndicator.rotate(byAngle: 270)
        }
    }

    @IBOutlet private var headerScrollView: UIScrollView! {
        didSet {
            headerScrollView.delegate = self
        }
    }

    @IBOutlet private var listScrollView: UIScrollView! {
        didSet {
            listScrollView.delegate = contentScrollDelegate
        }
    }

    // MARK: - Private properties

    private lazy var categoriesView = CategoriesView<TransactionEntity.TransactionCategory>()
    private var initialLoadCompleted = false

    private lazy var contentScrollDelegate = ContentScrollDelegate()

    // MARK: - Public properties

    override var isLoading: Bool {
        didSet {
            loadingIndicator.isHidden = !isLoading
        }
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)

        contentScrollDelegate.layoutResponders = [balanceHeaderView, cardHeaderView]
    }

    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        categoriesView.preparedForAutoLayout()
        categoriesWrapper.addSubview(categoriesView)
        NSLayoutConstraint.activate {
            categoriesView.topAnchor.constraint(equalTo: categoriesWrapper.topAnchor)
            categoriesView.leadingAnchor.constraint(equalTo: categoriesWrapper.leadingAnchor)
            categoriesView.trailingAnchor.constraint(equalTo: categoriesWrapper.trailingAnchor)
            categoriesView.bottomAnchor.constraint(equalTo: categoriesWrapper.bottomAnchor)
        }
    }
}

// MARK: - InitialViewProtocol

extension TransactionsListViewController: TransactionsListViewProtocol {

    var filterPublisher: AnyPublisher<TransactionEntity.TransactionCategory, Never> {
        categoriesView.categorySelectedPublisher
    }

    func apply(_ viewState: ViewState) {
        loadingIndicator.isHidden = true

        stackView.applyIfPresent(viewState.transactionsViewState) { viewState in
            let views = viewState.map { viewState in
                TransactionItemView().apply(viewState)
            }
            stackView.removeAllArrangedSubviews()
            if initialLoadCompleted {
                stackView.addArrangedSubviews(views)
            } else {
                stackView.addArrangedSubviewsWithAnimation(
                    views,
                    animationHandler: OpacityAnimationHandler(duration: 0.3, delay: 0)
                )
            }
        }

        if !initialLoadCompleted {
            UIView.animate(withDuration: 0.5) {
                self.view.setNeedsLayout()
                self.view.layoutIfNeeded()
            }
        }

        balanceHeaderView.applyIfPresent(viewState.balanceHeaderViewSate) { viewState in
            balanceHeaderView.apply(viewState)
        }

        categoriesWrapper.applyIfPresent(viewState.availableCategories) { categoriesViewState in
            categoriesView.configure(
                with: categoriesViewState,
                and: viewState.activeCategories ?? []
            )
        }

        cardHeaderView.applyIfPresent(viewState.cardViewState) { viewState in
            cardHeaderView.apply(viewState)
        }

        initialLoadCompleted = true
    }
}

extension TransactionsListViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.width
        let pageIndex = scrollView.contentOffset.x / pageWidth
        cardHeaderView.updateCardLeading(with: pageIndex)
    }
}
