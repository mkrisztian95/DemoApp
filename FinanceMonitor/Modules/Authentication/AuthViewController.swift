import UIKitPlus

protocol AuthViewProtocol: BaseViewProtocol {

    func apply(_ viewState: AuthViewController.ViewState)
}

final class AuthViewController: BaseViewController {

    // MARK: - ViewState

    struct ViewState {
        let currentPassword: [String]
        let showError: Bool
    }

    // MARK: - Private properties

    private var authPresenter: AuthPresenterProtocol? {
        presenter as? AuthPresenterProtocol
    }

    // MARK: - IBOutlets

    @IBOutlet private var passCodeTextFields: [UITextField]!
    @IBOutlet private var secureTextEntryView: UIView!
    @IBOutlet private var numPadView: UIView!
    @IBOutlet private var deleteButton: NumPadButton! {
        didSet {
            deleteButton.configure(with: .delete(image: UIImage(resource: .icClose)))
            deleteButton.delegate = self
        }
    }

    @IBOutlet private var numPadButtons: [NumPadButton]! {
        didSet {
            numPadButtons.enumerated().forEach { offset, button in
                button.delegate = self
                button.configure(with: .number(value: offset))
            }
        }
    }

    // MARK: - Lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
}

// MARK: - AuthViewProtocol

extension AuthViewController: AuthViewProtocol {

    func apply(_ viewState: ViewState) {
        passCodeTextFields.enumerated().forEach { index, textField in
            textField.layer.borderColor = viewState.showError ? UIColor.red.cgColor : UIColor.black950.cgColor
            textField.layer.borderWidth = 2.0
            textField.layer.cornerRadius = 8.0
            textField.text = viewState.currentPassword[index]
            textField.isSecureTextEntry = true
        }
    }
}

// MARK: - NumPadButtonDelegate

extension AuthViewController: NumPadButtonDelegate {
    func didSelect(button: NumPadButton, with value: Int) {
        if button == deleteButton {
            authPresenter?.deleteNumber()
        } else {
            authPresenter?.appendNumber(value: value)
        }
    }
}
