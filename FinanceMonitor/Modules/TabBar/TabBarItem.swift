import Depin
import UIKit

protocol TabItemPresentable {
    var titleKey: I18n.StringKey { get }
    var icon: UIImage { get }
    var tag: Int { get }
    var imageInset: UIEdgeInsets { get }
}

class TabBarItem: UITabBarItem {

    @Injected private var i18n: I18n

    init(with tabItem: TabItemPresentable) {
        super.init()
        title = i18n.str(tabItem.titleKey)
        image = tabItem.icon.withRenderingMode(.alwaysTemplate)
        tag = tabItem.tag
        imageInsets = tabItem.imageInset
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
