import UIKit

extension UIView {

    func flip(with duration: TimeInterval = 0.3) {
        UIView.transition(
            with: self,
            duration: duration,
            options: .transitionFlipFromBottom,
            animations: nil,
            completion: nil
        )
    }

    func rotate(byAngle angle: CGFloat) {
        let radians = angle / 180.0 * CGFloat.pi
        self.transform = self.transform.rotated(by: radians)
    }
}
