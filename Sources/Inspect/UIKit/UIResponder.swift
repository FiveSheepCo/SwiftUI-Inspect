#if canImport(UIKit)
import UIKit

extension UIResponder {
    func findControllerInResponderChain<T: UIViewController>(ofType type: T.Type) -> T? {
        var current = self
        
        while let next = current.next, next != current {
            if let t = next as? T {
                return t
            }
            current = next
        }
        
        return nil
    }
}
#endif
