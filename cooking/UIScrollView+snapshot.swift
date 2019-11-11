import UIKit

extension UIScrollView {
    struct DefaultProperty {
        let contentOffset: CGPoint
        let contentSize: CGSize
        let contentInset: UIEdgeInsets
        let zoomScale: CGFloat
    }

    func snapshot(scale: CGFloat = 0.0, completionBlock: @escaping (UIImage?) -> Void) {
        let frame = self.frame
        let defaultProperty = DefaultProperty(contentOffset: contentOffset,
                                              contentSize: contentSize,
                                              contentInset: contentInset,
                                              zoomScale: zoomScale)

        let contentInsetAdjustmentBehavior: Any?
        if #available(iOS 11.0, *) {
            contentInsetAdjustmentBehavior = self.contentInsetAdjustmentBehavior
        } else {
            contentInsetAdjustmentBehavior = nil
        }
        
        let completion: () -> () = {
            self.zoomScale = defaultProperty.zoomScale
            self.contentInset = defaultProperty.contentInset
            self.contentSize = defaultProperty.contentSize
            self.contentOffset = defaultProperty.contentOffset
            if #available(iOS 11.0, *), let contentInsetAdjustmentBehavior = contentInsetAdjustmentBehavior as? UIScrollView.ContentInsetAdjustmentBehavior {
                self.contentInsetAdjustmentBehavior = contentInsetAdjustmentBehavior
            }
            completionBlock(UIGraphicsGetImageFromCurrentImageContext())
            UIGraphicsEndImageContext()
        }
        if #available(iOS 11.0, *) {
            self.contentInsetAdjustmentBehavior = .never
        }
        self.contentInset = .zero
        self.setContentOffset(.zero, animated: false)
        self.zoomScale = 1.0

        let contentSize = contentSize
        UIGraphicsBeginImageContextWithOptions(contentSize, false, scale)
        let duration = 0.3
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            let cols = ceil(contentSize.width / frame.size.width)
            let rows = ceil(contentSize.height / frame.size.height)
            guard let context = UIGraphicsGetCurrentContext() else {
                completion()
                return
            }
            var numberOfLoops = 0
            for c in stride(from: 0.0, to: cols, by: 1.0) {
                for r in stride(from: 0.0, to: rows, by: 1.0) {
                    let offset = CGPoint(x: c * frame.size.width, y: r * frame.size.height)
                    self.setContentOffset(offset, animated: false)
                    RunLoop.main.run(until: Date(timeIntervalSinceNow: duration))
                    context.move(to: offset)
                    self.drawHierarchy(in: self.bounds, afterScreenUpdates: true)
                    numberOfLoops += 1
                }
            }

            completion()
        }
    }
}