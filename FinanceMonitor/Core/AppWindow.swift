import Depin
import UIKit

class AppWindow: UIWindow {

    @Injected private var shakeProvider: ShakeProviderProtocol

    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        super.motionEnded(motion, with: event)

        if motion == .motionShake {
            shakeProvider.didShakeDevice()
        }
    }
}
