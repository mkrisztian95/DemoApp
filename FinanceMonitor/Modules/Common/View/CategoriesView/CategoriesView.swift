import CombinePlus
import UIKitPlus

final class CategoriesView<Category: CustomStringConvertible>: BaseView {

    // MARK: - Private properties

    private var activeFilters: [Category] = []

    private lazy var gridStackView: UIStackView = {
        let gridStackView = UIStackView().preparedForAutoLayout()
        gridStackView.backgroundColor = .clear
        gridStackView.axis = .horizontal
        gridStackView.distribution = .fill
        gridStackView.spacing = 8.0
        return gridStackView
    }()

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView().preparedForAutoLayout()
        scrollView.backgroundColor = .clear
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.contentInset = .init(top: 0, left: 24, bottom: 0, right: 0)
        return scrollView
    }()

    private var bag = CancelBag()
    private var selectedCategorySubject: PassthroughSubject<Category, Never> = .init()

    // MARK: - Public properties

    var categorySelectedPublisher: AnyPublisher<Category, Never> {
        selectedCategorySubject.eraseToAnyPublisher()
    }

    // MARK: - Overrides

    override func setup() {
        super.setup()
        addSubview(scrollView)
        scrollView.addSubview(gridStackView)

        NSLayoutConstraint.activate {
            scrollView.topAnchor.constraint(equalTo: topAnchor)
            scrollView.leftAnchor.constraint(equalTo: leftAnchor)
            scrollView.rightAnchor.constraint(equalTo: rightAnchor)
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor)

            gridStackView.topAnchor.constraint(equalTo: scrollView.topAnchor)
            gridStackView.leftAnchor.constraint(equalTo: scrollView.leftAnchor)
            gridStackView.rightAnchor.constraint(equalTo: scrollView.rightAnchor)
            gridStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)

            scrollView.heightAnchor.constraint(equalTo: gridStackView.heightAnchor, multiplier: 1.0)
        }
    }

    // MARK: - Public methods

    func configure(with categories: [Category], and activeFilters: [Category]) {
        self.activeFilters = activeFilters

        gridStackView.removeAllArrangedSubviews()
        gridStackView.addArrangedSubviews(categories.map { createItemView(with: $0) })
    }

    // MARK: - Private methods

    private func createItemView(with category: Category) -> UIView {
        let isInactive = !activeFilters.contains { $0.description == category.description }

        var configuration = UIButton.Configuration.filled()
        configuration.title = category.description.localizedCapitalized
        configuration.buttonSize = .small
        configuration.cornerStyle = .small

        let button = UIButton(configuration: configuration)

        button.titleLabel?.font = .bodyBold
        button.setTitleColor(.constantWhite)
        button.backgroundColor = .backgroundSecondary
        button.layer.cornerRadius = 15
        button.tintColor = .backgroundSecondary

        button.sizeToFit()

        button.tapPublisher
            .sink { [unowned self] in
                selectedCategorySubject.send(category)
            }
            .store(in: &bag)

        button.alpha = isInactive ? 0.5 : 1.0

        button.fixedSize(.init(
            width: button.frame.width,
            height: button.frame.height
        ))
        return button
    }
}
