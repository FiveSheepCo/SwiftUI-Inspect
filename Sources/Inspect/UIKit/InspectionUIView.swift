#if canImport(UIKit)
import SwiftUI
import UIKit

struct InspectionUIView<T: UIView>: UIViewRepresentable {
    let frame: CGRect
    let safeAreaInsets: EdgeInsets
    let options: [InspectionOption]
    let additionalCheck: ((T) -> Bool)?
    let customize: (T) -> Void
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        RunLoop.main.perform {
            guard let coordinateSpace = uiView.window?.screen.coordinateSpace else { return }
            
            let subframeFloatLeeway: CGFloat = options.contains(.subFrame) ? 2 : 0
            let finalFrame = CGRect(
                x: frame.origin.x - subframeFloatLeeway - (options.contains(.containingSafeArea) ? safeAreaInsets.leading : 0),
                y: frame.origin.y - subframeFloatLeeway - (options.contains(.containingSafeArea) ? safeAreaInsets.top : 0),
                width: frame.size.width + safeAreaInsets.leading + safeAreaInsets.trailing + subframeFloatLeeway * 2,
                height: frame.size.height + safeAreaInsets.top + safeAreaInsets.bottom + subframeFloatLeeway * 2
            )
            
            let foundView = SearchCoordinator<T>(
                correctFrame: finalFrame,
                coordinateSpace: coordinateSpace,
                additionalCheck: additionalCheck,
                options: options
            ).findViewWithinSuperviews(of: uiView)
            
            if let foundView {
                customize(foundView)
            }
        }
    }
}
#endif
