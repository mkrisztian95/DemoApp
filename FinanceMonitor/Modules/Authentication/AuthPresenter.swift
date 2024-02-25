import CombinePlus
import Depin
import LocalAuthentication
import XCoordinator

protocol AuthPresenterProtocol {

    func appendNumber(value: Int)
    func deleteNumber()
}

final class AuthPresenter<
    View: AuthViewProtocol,
    Route: StrongRouter<AuthRoute>,
    ViewStateFactory: AuthViewStateFactory>: BasePresenter<View, Route, ViewStateFactory> {

    // MARK: - Injected properties

    @Injected var authenticationProvider: AuthenticationProviderProtocol

    // MARK: - Private properties

    private var currentPassword: [Int] = [] {
        didSet {
            view.apply(factory.make(
                currentPasscode: currentPassword,
                incorrectPassword: invalidPassCode
            ))
        }
    }

    private var invalidPassCode: Bool {
        currentPassword.count == 4 && currentPassword != [1, 2, 3, 4]
    }

    init(
        router: Route,
        view: View
    ) {
        super.init(view: view, router: router)

        bind()
    }

    // MARK: - Private methods

    private func bind() {
        view.viewDidAppearPublisher
            .sink { [unowned self] in
                performAuthentication()
            }
            .store(in: &bag)

        view.viewIsAppearingPublisher
            .map { [unowned self] in
                factory.make(
                    currentPasscode: currentPassword,
                    incorrectPassword: false
                )
            }
            .sink { [unowned self] in
                view.apply($0)
            }
            .store(in: &bag)
    }

    private func performAuthentication(again isRetry: Bool = false) {
        authenticationProvider
            .biometricsEnabledPublisher
            .ignoreFailure()
            .filter { !$0 }
            .void()
            .compactMap { [weak self] in
                self?.factory.make(
                    currentPasscode: self?.currentPassword ?? [],
                    incorrectPassword: false
                )
            }
            .sink { [unowned self] in
                view.apply($0)
            }
            .store(in: &bag)

        authenticationProvider
            .biometricsEnabledPublisher
            .ignoreFailure()
            .filter { $0 }
            .void()
            .flatMap { [unowned self] in
                authenticationProvider.authEvaluationPublisher
            }
            .onMain()
            .sink(
                receiveCompletion: { [weak self] completion in
                    guard let self else { return }
                    switch completion {
                    case .finished:
                        break
                    case .failure:
                        view.apply(factory.make(
                            currentPasscode: currentPassword,
                            incorrectPassword: false
                        ))
                    }
                },
                receiveValue: { [weak self] value in
                    guard let self else { return }
                    switch value {
                    case .error:
                        if isRetry {
                            view.apply(factory.make(
                                currentPasscode: currentPassword,
                                incorrectPassword: false
                            ))
                        } else {
                            performAuthentication(again: true)
                        }
                    case .success:
                        router.trigger(.main)
                    }
                }
            )
            .store(in: &bag)
    }

    private func validatePassword() {
        if currentPassword.count == 4 {
            if currentPassword == [1, 2, 3, 4] {
                router.trigger(.main)
            } else {
                view.apply(factory.make(
                    currentPasscode: currentPassword,
                    incorrectPassword: true
                ))
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                    guard let self else { return }
                    currentPassword = []
                    view.apply(factory.make(
                        currentPasscode: currentPassword,
                        incorrectPassword: false
                    ))
                }
            }
        }
    }
}

// MARK: - AuthPresenterProtocol

extension AuthPresenter: AuthPresenterProtocol {

    func appendNumber(value: Int) {
        if currentPassword.count < 4 {
            currentPassword.append(value)
            validatePassword()
        }
    }

    func deleteNumber() {
        if !currentPassword.isEmpty {
            currentPassword.removeLast()
            validatePassword()
        }
    }
}
