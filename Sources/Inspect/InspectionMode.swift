import Foundation

enum InspectionOption {
    /// Same as the normal inspection option, but the frame is matched with origin and size updated with the safeAreaInsets.
    case containingSafeArea
    /// The superframe inspection option, where the original frame is contained anywhere within the searched view.
    case superFrame
    /// The subframe inspection option, where the searched view is contained anywhere within the original frame.
    case subFrame
    
    #if canImport(AppKit)
    /// The frame is matched with neither the origin nor the size updated with the safeAreaInsets.
    case excludingSafeArea
    /// The frame has the safeAreaInsets added to its size.
    case addingSafeAreaToSize
    /// The frame has the alignmentRect (of the searched view) removed.
    case removeAlignmentRect
    #endif
}
