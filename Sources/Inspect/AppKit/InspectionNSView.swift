#if canImport(AppKit)

import SwiftUI
import AppKit

struct InspectionNSView<T: NSView>: NSViewRepresentable {
    let frame: CGRect
    let safeAreaInsets: EdgeInsets
    let options: [InspectionOption]
    let additionalCheck: ((T) -> Bool)?
    let customize: (T) -> Void
    
    func makeNSView(context: Context) -> NSView {
        let view = NSView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    
    func updateNSView(_ nsView: NSView, context: Context) {
        RunLoop.main.perform {
            guard let windowView = nsView.window?.contentView else { return }
            
            let subframeFloatLeeway: CGFloat = (options.contains(.subFrame)) ? 5 : 0
            let finalFrame = CGRect(
                x: frame.origin.x - subframeFloatLeeway - (options.contains(.containingSafeArea) ? safeAreaInsets.leading : 0),
                y: frame.origin.y - subframeFloatLeeway - (options.contains(.containingSafeArea) ? safeAreaInsets.top : 0),
                width: frame.size.width + (options.contains(.excludingSafeArea) ? 0 : safeAreaInsets.leading + safeAreaInsets.trailing) + subframeFloatLeeway * 2,
                height: frame.size.height + (options.contains(.excludingSafeArea) ? 0 : safeAreaInsets.top + safeAreaInsets.bottom) + subframeFloatLeeway * 2
            )
            
            let foundView = SearchCoordinator<T>(
                correctFrame: finalFrame,
                windowView: windowView,
                additionalCheck: additionalCheck,
                options: options
            ).findViewWithinSuperviews(of: nsView)
            
            if let foundView {
                customize(foundView)
            }
        }
    }
}

#endif
