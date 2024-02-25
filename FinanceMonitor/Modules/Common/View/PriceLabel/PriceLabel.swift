import UIKitPlus

final class PriceLabel: UILabel {

    func set(with text: String, and isHiddenPrice: Bool) {
        self.text = isHiddenPrice ? "😎💸🖕💸😎" : text
    }
}
