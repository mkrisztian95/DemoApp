import UIKit

final class AuthViewStateFactory: BaseViewStateFactory {

    typealias ViewState = AuthViewController.ViewState

    func make(
        currentPasscode: [Int],
        incorrectPassword: Bool
    ) -> ViewState {
        ViewState(
            currentPassword: getStringPasscode(from: currentPasscode),
            showError: incorrectPassword
        )
    }

    private func getStringPasscode(from passCode: [Int]) -> [String] {
        var array: [String] = Array(repeating: "", count: 4)
        for i in 0..<passCode.count {
            array[i] = String(passCode[i])
        }

        return array
    }
}
