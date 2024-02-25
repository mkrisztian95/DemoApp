import UIKitPlus

protocol NumPadButtonDelegate: AnyObject {
    func didSelect(button: NumPadButton, with value: Int)
}

final class NumPadButton: UIButton {

    // MARK: - Num pad Button type

    enum NumPadButtonType {
        case number(value: Int)
        case delete(image: UIImage)
    }

    // MARK: - Private properties

    private var value: Int = 0

    // MARK: - public properties

    weak var delegate: NumPadButtonDelegate?

    // MARK: - Public methods

    func configure(
        with type: NumPadButtonType,
        and size: CGSize = .init(width: 64.0, height: 64.0)
    ) {
        fixedSize(size)

        switch type {

        case .number(let value):
            setTitle(String(value))
            titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .bold)
            self.value = value

        case .delete(let image):
            setImage(image)
        }

        setTitleColor(.black950)
        tintColor = .black950

        backgroundColor = .backgroundSecondary
        layer.cornerRadius = size.height / 2
        addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }

    // MARK: - Private methods

    @objc private func didTapButton() {
        delegate?.didSelect(button: self, with: value)
    }
}
