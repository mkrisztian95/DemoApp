import UIKitPlus

class ContentScrollDelegate: NSObject {

    var layoutResponders: [ScrollLayoutChangeResponder]?
    var currentLayoutResponder: ScrollLayoutChangeResponder?

    private var activeResponder: ScrollLayoutChangeResponder? {
        currentLayoutResponder ?? layoutResponders?.first
    }

    private func adjustScrollEnd(with deltaY: CGFloat, in scrollView: UIScrollView) {
        guard let layoutResponders, let activeResponder else { return }
        let predictedHeaderHeight = activeResponder.currentHeight - deltaY

        if predictedHeaderHeight < activeResponder.maxHeight - 13 {
            layoutResponders.forEach {
                $0.setHeight($0.minHeight)
                $0.updateLayout(0)
            }
        } else if predictedHeaderHeight > activeResponder.maxHeight - 13 {
            layoutResponders.forEach {
                $0.setHeight($0.maxHeight)
                $0.updateLayout(1)
            }
        }

        UIView.animate(withDuration: 0.2) {
            scrollView.superview?.layoutIfNeeded()
        }
    }
}

extension ContentScrollDelegate: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let layoutResponders, let activeResponder else { return }
        let predictedHeaderHeight = activeResponder.currentHeight - scrollView.contentOffset.y

        if predictedHeaderHeight <= activeResponder.minHeight {
            layoutResponders.forEach {
                $0.setHeight($0.minHeight)
                $0.updateLayout(0)
            }
        } else if predictedHeaderHeight > activeResponder.minHeight {
            scrollView.contentOffset = .zero
            layoutResponders.forEach { $0.setHeight(predictedHeaderHeight) }

            let normalisedValue = Float(
                (predictedHeaderHeight - activeResponder.minHeight) /
                (activeResponder.maxHeight - activeResponder.minHeight)
            )
            layoutResponders.forEach { $0.updateLayout(normalisedValue) }
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        adjustScrollEnd(with: scrollView.contentOffset.y, in: scrollView)
    }

    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        adjustScrollEnd(with: scrollView.contentOffset.y, in: scrollView)
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        adjustScrollEnd(with: scrollView.contentOffset.y, in: scrollView)
    }
}
