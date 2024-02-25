import CombinePlus
import Depin
import UIKitPlus

class BaseViewController: UIViewController {

    // MARK: - Private properties

    var bag = CancelBag()
    private var blurViewConfigured = false

    // MARK: - Public properties

    var isLoading = false
    var presenter: BasePresenterProtocol!

    // MARK: - Life cycle subjects

    private let viewDidLoadSubject = PassthroughSubject<Void, Never>()
    private let viewIsAppearingSubject = PassthroughSubject<Void, Never>()
    private let viewWillAppearSubject = PassthroughSubject<Void, Never>()
    private let viewDidAppearSubject = PassthroughSubject<Void, Never>()
    private let viewWillDisappearSubject = PassthroughSubject<Void, Never>()
    private let viewDidDisappearSubject = PassthroughSubject<Void, Never>()
    private let viewDidLayoutSubviewsSubject = PassthroughSubject<Void, Never>()

    private lazy var blurView: UIVisualEffectView = {
        UIVisualEffectView(effect: UIBlurEffect(style: .regular)).preparedForAutoLayout()
    }()

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .background
        viewDidLoadSubject.send()
        viewDidLoadSubject.send(completion: .finished)
    }

    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        viewIsAppearingSubject.send()
        configureBlurView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewWillAppearSubject.send()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewDidAppearSubject.send()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewWillDisappearSubject.send()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewDidDisappearSubject.send()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        viewDidLayoutSubviewsSubject.send()
    }

    // MARK: - Private Methods

    private func configureBlurView() {
        guard !blurViewConfigured else { return }
        blurViewConfigured = true

        view.addSubview(blurView)
        blurView.isHidden = true

        NSLayoutConstraint.activate {
            blurView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            blurView.centerYAnchor.constraint(equalTo: view.centerYAnchor)

            blurView.heightAnchor.constraint(equalTo: view.heightAnchor)
            blurView.widthAnchor.constraint(equalTo: view.widthAnchor)
        }
    }
}

// MARK: - BaseViewProtocol

extension BaseViewController: BaseViewProtocol {
    var viewWillAppearPublisher: AnyPublisher<Void, Never> {
        viewWillAppearSubject.eraseToAnyPublisher()
    }

    var viewDidAppearPublisher: AnyPublisher<Void, Never> {
        viewDidAppearSubject.eraseToAnyPublisher()
    }

    var viewDidLoadPublisher: AnyPublisher<Void, Never> {
        viewDidLoadSubject.eraseToAnyPublisher()
    }

    var viewIsAppearingPublisher: AnyPublisher<Void, Never> {
        viewIsAppearingSubject.eraseToAnyPublisher()
    }

    var viewWillDisappearPublisher: AnyPublisher<Void, Never> {
        viewWillDisappearSubject.eraseToAnyPublisher()
    }

    var viewDidDisappearPublisher: AnyPublisher<Void, Never> {
        viewDidDisappearSubject.eraseToAnyPublisher()
    }

    var viewDidLayoutSubviewsPublisher: AnyPublisher<Void, Never> {
        viewDidLayoutSubviewsSubject.eraseToAnyPublisher()
    }

    func blurBackground() {
        view.bringSubviewToFront(blurView)
        blurView.setHidden(false)
    }

    func removeBlur() {
        blurView.setHidden(true)
    }
}
