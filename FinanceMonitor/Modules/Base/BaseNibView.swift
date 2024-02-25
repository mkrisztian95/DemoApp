import UIKitPlus

class BaseNibView: UIView {

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    // MARK: - Common Initialization

    private func commonInit() {
        let nibName = String(describing: type(of: self))
        let nib = UINib(nibName: nibName, bundle: nil)
        if let contentView = nib.instantiate(withOwner: self, options: nil).first as? UIView {
            addSubview(contentView)
            contentView.translatesAutoresizingMaskIntoConstraints = false
            contentView.topAnchor.constraint(equalTo: topAnchor).isActive = true
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        }
    }
}
