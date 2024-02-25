import UIKitPlus

protocol ScrollLayoutChangeResponder {
    var minHeight: CGFloat { get }
    var maxHeight: CGFloat { get }
    var currentHeight: CGFloat { get }

    func setHeight(_ height: CGFloat)
    func updateLayout(_ normalised: Float)
}

extension ScrollLayoutChangeResponder {

    var minHeight: CGFloat { 100.0 }
    var maxHeight: CGFloat { 250.0 }
}
