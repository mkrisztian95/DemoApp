import CombinePlus
import LocalAuthentication

enum AuthResult {
    case success(message: String)
    case error(message: String)
}

protocol AuthenticationProviderProtocol {

    var biometricsEnabledPublisher: AnyPublisher<Bool, NSError> { get }
    var authEvaluationPublisher: AnyPublisher<AuthResult, Error> { get }
}

final class AuthenticationProvider {

    private let context = LAContext()
}

extension AuthenticationProvider: AuthenticationProviderProtocol {

    var biometricsEnabledPublisher: AnyPublisher<Bool, NSError> {
        Future<Bool, NSError> { [weak self] promise in
            var error: NSError?
            guard let self else { return promise(.failure(NSError(domain: "No_Self", code: 1))) }

            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                promise(.success(true))
            } else {
                if let error {
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }

    var authEvaluationPublisher: AnyPublisher<AuthResult, Error> {
        Future<AuthResult, Error> { [weak self] promise in
            guard let self else { return promise(.failure(NSError(domain: "No_Self", code: 1))) }
            let reason = "Authenticate to access your account"
            context.evaluatePolicy(
                .deviceOwnerAuthenticationWithBiometrics,
                localizedReason: reason
            ) { success, authenticationError in
                if success {
                    promise(.success(.success(message: "Success")))
                } else {
                    if let error = authenticationError {
                        promise(.failure(error))
                    }
                }
            }
        }.eraseToAnyPublisher()
    }
}
