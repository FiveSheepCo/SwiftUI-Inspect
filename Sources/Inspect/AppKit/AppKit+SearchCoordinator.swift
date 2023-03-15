#if canImport(AppKit)
import AppKit

class SearchCoordinator<T: NSView> {
    
    let correctFrame: CGRect
    let windowView: NSView
    let additionalCheck: ((T) -> Bool)?
    let options: [InspectionOption]
    
    init(correctFrame: CGRect, windowView: NSView, additionalCheck: ((T) -> Bool)?, options: [InspectionOption]) {
        self.correctFrame = correctFrame
        self.windowView = windowView
        self.additionalCheck = additionalCheck
        self.options = options
    }
    
    func findViewWithinSuperviews(of initialView: NSView) -> T? {
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
        of initialView: NSView,
        except alreadyTestedView: NSView?
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
    
    private func test(view: NSView) -> T? {
        
        if let t = view as? T {
            var globalOrigin = t.convert(CGPoint.zero, to: windowView)
            var size = t.frame.size
            
            if options.contains(.removeAlignmentRect) {
                let r = t.alignmentRectInsets
                
                globalOrigin.x += r.left
                globalOrigin.y += r.top
                size.width -= r.left + r.right
                size.height -= r.top + r.bottom
            }
            
            let globalFrame = CGRect(origin: globalOrigin, size: size)
            let isSubFrame = options.contains(.subFrame)
            let isSuperFrame = options.contains(.superFrame)
            if isSubFrame && isSuperFrame {
                if correctFrame.intersects(globalFrame) {
                    return t
                }
            } else if isSubFrame {
                if correctFrame.contains(globalFrame) && (additionalCheck?(t) ?? true) {
                    return t
                }
            } else if isSuperFrame {
                if globalFrame.contains(correctFrame) && (additionalCheck?(t) ?? true) {
                    return t
                }
            } else if
                correctFrame.size.width ≈≈ size.width &&
                    correctFrame.size.height ≈≈ size.height &&
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
