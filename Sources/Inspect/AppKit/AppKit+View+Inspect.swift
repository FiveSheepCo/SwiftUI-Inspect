#if canImport(AppKit)

import SwiftUI
import AppKit

extension View {
    func _inspect<T: NSView>(
        options: [InspectionOption] = [],
        additionalCheck: ((T) -> Bool)? = nil,
        customize: @escaping (T) -> Void
    ) -> some View {
        self
            .background(
                GeometryReader { proxy in
                    InspectionNSView(
                        frame: proxy.frame(in: .global),
                        safeAreaInsets: proxy.safeAreaInsets,
                        options: options,
                        additionalCheck: additionalCheck,
                        customize: customize
                    )
                }
            )
    }
}

public extension TextField {
    /// Finds a `NSTextField` from a `TextField`.
    func inspect(customize: @escaping (NSTextField) -> Void) -> some View {
        _inspect(customize: customize)
    }
}

@available(macOS 11.0, *)
public extension TextEditor {
    /// Finds a `NSTextView` from a `TextEditor`.
    func inspect(customize: @escaping (NSTextView) -> Void) -> some View {
        _inspect(options: [.subFrame], customize: customize)
    }
}

public extension ScrollView {
    /// Finds a `NSScrollView` from a `ScrollView`.
    func inspect(customize: @escaping (NSScrollView) -> Void) -> some View {
        _inspect(options: [.containingSafeArea], customize: customize)
    }
}

public extension List {
    /// Finds a `NSTableView` from a `List`.
    func inspect(customize: @escaping (NSTableView) -> Void) -> some View {
        _inspect(options: [.excludingSafeArea, .subFrame, .superFrame], customize: customize)
    }
}

public extension Button {
    /// Finds a `NSButton` from a `Button`.
    func inspect(customize: @escaping (NSButton) -> Void) -> some View {
        _inspect(options: [.removeAlignmentRect], customize: customize)
    }
}

public extension Toggle {
    /// Finds a `NSButton` from a `Toggle`.
    func inspect(customize: @escaping (NSButton) -> Void) -> some View {
        _inspect(options: [.subFrame], customize: customize)
    }
}

public extension Slider {
    /// Finds a `NSSlider` from a `Slider`.
    func inspect(customize: @escaping (NSSlider) -> Void) -> some View {
        _inspect(options: [.subFrame], customize: customize)
    }
}

public extension Stepper {
    /// Finds a `NSStepper` from a `Stepper`.
    func inspect(customize: @escaping (NSStepper) -> Void) -> some View {
        _inspect(options: [.subFrame], customize: customize)
    }
}

public extension DatePicker {
    /// Finds a `NSDatePicker` from a `DatePicker`.
    func inspect(customize: @escaping (NSDatePicker) -> Void) -> some View {
        _inspect(options: [.subFrame], customize: customize)
    }
}

public extension Picker {
    /// Finds a `NSSegmentedControl` from a `Picker`.
    func inspectSegmentedControl(customize: @escaping (NSSegmentedControl) -> Void) -> some View {
        _inspect(options: [.subFrame], customize: customize)
    }
}

@available(macOS 11.0, *)
public extension ColorPicker {
    /// Finds a `NSColorWell` from a `ColorPicker`.
    func inspect(customize: @escaping (NSColorWell) -> Void) -> some View {
        _inspect(options: [.subFrame], customize: customize)
    }
}

#endif
