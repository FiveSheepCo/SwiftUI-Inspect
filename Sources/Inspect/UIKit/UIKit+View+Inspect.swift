#if canImport(UIKit)
import SwiftUI
import UIKit

extension View {
    func _inspectListOrForm(customize: @escaping (ListInspectionNativeView) -> Void) -> some View {
        _inspect(
            additionalCheck: { $0 is UITableView || $0 is UICollectionView },
            customize: { view in
                if let tableView = view as? UITableView {
                    customize(.tableView(tableView))
                } else {
                    customize(.collectionView(view as! UICollectionView))
                }
            }
        )
    }
    
    func _inspectListOrFormCell(customize: @escaping (ListCellInspectionNativeView) -> Void) -> some View {
        _inspect(
            options: [.superFrame],
            additionalCheck: { $0 is UITableViewCell || $0 is UICollectionViewCell },
            customize: { view in
                if let tableView = view as? UITableViewCell {
                    customize(.tableView(tableView))
                } else {
                    customize(.collectionView(view as! UICollectionViewCell))
                }
            }
        )
    }
    
    func _inspect<T: UIView>(
        options: [InspectionOption] = [],
        additionalCheck: ((T) -> Bool)? = nil,
        customize: @escaping (T) -> Void
    ) -> some View {
        self
            .background(
                GeometryReader { proxy in
                    InspectionUIView(
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
    /// Finds a `UITextField` from a `TextField`.
    func inspect(customize: @escaping (UITextField) -> Void) -> some View {
        _inspect(customize: customize)
    }
}

@available(iOS 14.0, *)
@available(tvOS, unavailable)
public extension TextEditor {
    /// Finds a `UITextView` from a `TextEditor`.
    func inspect(customize: @escaping (UITextView) -> Void) -> some View {
        _inspect(customize: customize)
    }
}

public extension ScrollView {
    /// Finds a `UIScrollView` from a `ScrollView`.
    func inspect(customize: @escaping (UIScrollView) -> Void) -> some View {
        _inspect(customize: customize)
    }
}

/// A view that is either a `UITableView` or a `UICollectionView`.
///
/// - note: `List` and `Form` usually become `UITableView` in os versions below iOS 16 and `UICollectionView` in os versions from iOS 16.
public enum ListInspectionNativeView {
    case tableView(UITableView)
    case collectionView(UICollectionView)
}

public extension List {
    /// Finds a `ListInspectionNativeView` from a `List`.
    func inspect(customize: @escaping (ListInspectionNativeView) -> Void) -> some View {
        _inspectListOrForm(customize: customize)
    }
}

public extension Form {
    /// Finds a `ListInspectionNativeView` from a `Form`.
    func inspect(customize: @escaping (ListInspectionNativeView) -> Void) -> some View {
        _inspectListOrForm(customize: customize)
    }
}

/// A view that is either a `UITableViewCell` or a `UITableViewCell`.
///
/// - note: `List` and `Form` cells usually become `UITableViewCell` in os versions below iOS 16 and `UITableViewCellCell` in os versions from iOS 16.
public enum ListCellInspectionNativeView {
    case tableView(UITableViewCell)
    case collectionView(UICollectionViewCell)
}

public extension View {
    /// Finds a `ListCellInspectionNativeView` from any `View`.
    func inspectListOrFormCell(customize: @escaping (ListCellInspectionNativeView) -> Void) -> some View {
        _inspectListOrFormCell(customize: customize)
    }
}

@available(tvOS, unavailable)
public extension Toggle {
    /// Finds a `UISwitch` from a `Toggle`.
    func inspect(customize: @escaping (UISwitch) -> Void) -> some View {
        _inspect(options: [.subFrame], customize: customize)
    }
}

@available(tvOS, unavailable)
public extension Slider {
    /// Finds a `UISlider` from a `Slider`.
    func inspect(customize: @escaping (UISlider) -> Void) -> some View {
        _inspect(options: [.subFrame], customize: customize)
    }
}

@available(tvOS, unavailable)
public extension Stepper {
    /// Finds a `UIStepper` from a `Stepper`.
    func inspect(customize: @escaping (UIStepper) -> Void) -> some View {
        _inspect(options: [.subFrame], customize: customize)
    }
}

@available(tvOS, unavailable)
public extension DatePicker {
    /// Finds a `UIDatePicker` from a `DatePicker`.
    func inspect(customize: @escaping (UIDatePicker) -> Void) -> some View {
        _inspect(options: [.subFrame], customize: customize)
    }
}

public extension Picker {
    /// Finds a `UISegmentedControl` from a `Picker`.
    func inspectSegmentedControl(customize: @escaping (UISegmentedControl) -> Void) -> some View {
        _inspect(customize: customize)
    }
}

@available(iOS 14.0, *)
@available(tvOS, unavailable)
public extension ColorPicker {
    /// Finds a `UIColorWell` from a `ColorPicker`.
    func inspect(customize: @escaping (UIColorWell) -> Void) -> some View {
        _inspect(options: [.subFrame], customize: customize)
    }
}

public extension NavigationView {
    /// Finds a `UINavigationController` from a `NavigationView`.
    func inspect(customize: @escaping (UINavigationController) -> Void) -> some View {
        _inspect(
            options: [.containingSafeArea],
            additionalCheck: { $0.findControllerInResponderChain(ofType: UINavigationController.self) != nil }
        ) { (view: UIView) in
            if let controller = view.findControllerInResponderChain(ofType: UINavigationController.self) {
                customize(controller)
            }
        }
    }
    
    /// Finds a `UISplitViewController` from a `NavigationView`.
    func inspectSplitViewController(customize: @escaping (UISplitViewController) -> Void) -> some View {
        _inspect(
            options: [.containingSafeArea],
            additionalCheck: { $0.findControllerInResponderChain(ofType: UISplitViewController.self) != nil }
        ) { (view: UIView) in
            if let controller = view.findControllerInResponderChain(ofType: UISplitViewController.self) {
                customize(controller)
            }
        }
    }
    
    /// Finds a `UINavigationBar` from a `NavigationView`.
    func inspectNavigationBar(customize: @escaping (UINavigationBar) -> Void) -> some View {
        _inspect(options: [.subFrame], customize: customize)
    }
}

@available(iOS 16.0, *)
public extension NavigationStack {
    /// Finds a `UINavigationController` from a `NavigationStack`.
    func inspect(customize: @escaping (UINavigationController) -> Void) -> some View {
        _inspect(
            options: [.containingSafeArea],
            additionalCheck: { $0.findControllerInResponderChain(ofType: UINavigationController.self) != nil }
        ) { (view: UIView) in
            if let controller = view.findControllerInResponderChain(ofType: UINavigationController.self) {
                customize(controller)
            }
        }
    }
    
    /// Finds a `UISplitViewController` from a `NavigationStack`.
    func inspectSplitViewController(customize: @escaping (UISplitViewController) -> Void) -> some View {
        _inspect(
            options: [.containingSafeArea],
            additionalCheck: { $0.findControllerInResponderChain(ofType: UISplitViewController.self) != nil }
        ) { (view: UIView) in
            if let controller = view.findControllerInResponderChain(ofType: UISplitViewController.self) {
                customize(controller)
            }
        }
    }
    
    /// Finds a `UINavigationBar` from a `NavigationStack`.
    func inspectNavigationBar(customize: @escaping (UINavigationBar) -> Void) -> some View {
        _inspect(options: [.subFrame], customize: customize)
    }
}

public extension TabView {
    /// Finds a `UITabBarController` from a `TabView`.
    func inspect(customize: @escaping (UITabBarController) -> Void) -> some View {
        _inspect(
            options: [.containingSafeArea],
            additionalCheck: { $0.findControllerInResponderChain(ofType: UITabBarController.self) != nil }
        ) { (view: UIView) in
            if let controller = view.findControllerInResponderChain(ofType: UITabBarController.self) {
                customize(controller)
            }
        }
    }
    
    /// Finds a `UITabBar` from a `TabView`.
    func inspectTabBar(customize: @escaping (UITabBar) -> Void) -> some View {
        _inspect(options: [.subFrame], customize: customize)
    }
}
#endif
