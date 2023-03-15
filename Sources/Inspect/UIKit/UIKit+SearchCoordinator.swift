#if canImport(UIKit)
import UIKit

class SearchCoordinator<T: UIView> {
    
    let correctFrame: CGRect
    let coordinateSpace: UICoordinateSpace
    let additionalCheck: ((T) -> Bool)?
    let options: [InspectionOption]
    
    init(correctFrame: CGRect, coordinateSpace: UICoordinateSpace, additionalCheck: ((T) -> Bool)?, options: [InspectionOption]) {
        self.correctFrame = correctFrame
        self.coordinateSpace = coordinateSpace
        self.additionalCheck = additionalCheck
        self.options = options
    }
    
    func findViewWithinSuperviews(of initialView: UIView) -> T? {
        var currentView = initialView
        
        while let superview = currentView.superview {
            if let view = findViewWithinSubviews(
                of: superview,
                except: currentView
            ) as T? {
                return view
            }
            currentView = superview
        }
        
        return nil
    }
    
    private func findViewWithinSubviews(
        of initialView: UIView,
        except alreadyTestedView: UIView?
    ) -> T? {
        
        if let t = test(view: initialView) {
            return t
        }
        
        for subview in initialView.subviews where subview != alreadyTestedView {
            if let t = test(view: subview) ?? findViewWithinSubviews(
                of: subview,
                except: nil
            ) {
                return t
            }
        }
        return nil
    }
    
    private func test(view: UIView) -> T? {
        
        if let t = view as? T {
            
            let globalOrigin = t.convert(CGPoint.zero, to: coordinateSpace)
            
            if options.contains(.subFrame) {
                let globalFrame = CGRect(origin: globalOrigin, size: t.frame.size)
                
                if correctFrame.contains(globalFrame) && (additionalCheck?(t) ?? true) {
                    return t
                }
            } else if options.contains(.superFrame) {
                let globalFrame = CGRect(origin: globalOrigin, size: t.frame.size)
                
                if globalFrame.contains(correctFrame) && (additionalCheck?(t) ?? true) {
                    return t
                }
            } else if
                correctFrame.size.width ≈≈ t.frame.size.width &&
                    correctFrame.size.height ≈≈ t.frame.size.height &&
                    correctFrame.origin.x ≈≈ globalOrigin.x &&
                    correctFrame.origin.y ≈≈ globalOrigin.y &&
                    (additionalCheck?(t) ?? true)
            {
                return t
            }
        }
        return nil
    }
}
#endif
