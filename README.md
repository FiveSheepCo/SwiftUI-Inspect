# SwiftUI-Inspect

[![GithubCI_Status]][GithubCI_URL]
[![Quintschaf_Badge]](https://quintschaf.com)

Inspect is a new approach at accessing UIKit and AppKit components from within SwiftUI more safely and swifty. It is heavily inspired by [`SwiftUI-Introspect`](https://github.com/siteline/SwiftUI-Introspect), but does not use any of the old code.

## Coverage

| SwiftUI                         | UIKit                                                          | AppKit                          | Notes                                                                                                                                                                                        |
|---------------------------------|----------------------------------------------------------------|---------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| TextField                       | UITextField                                                    | NSTextField                     |                                                                                                                                                                                              |
| TextEditor                      | UITextEditor                                                   | NSTextView                      |                                                                                                                                                                                              |
| ScrollView                      | UIScrollView                                                   | NSScrollView                    |                                                                                                                                                                                              |
| List/Form                       | ListInspectionNativeView*                                      | NSTableView                     |                                                                                                                                                                                              |
| any View                        | ListCellInspectionNativeView*                                  | _not implemented yet_           | This can be called on any view that represents a `List` or `Form` Cell. The function is called `inspectListOrFormCell`.                                                                      |
| Button                          | _is no native control_                                         | NSButton                        |                                                                                                                                                                                              |
| Toggle                          | UISwitch                                                       | NSButton                        |                                                                                                                                                                                              |
| Slider                          | UISlider                                                       | NSSlider                        |                                                                                                                                                                                              |
| Stepper                         | UIStepper                                                      | NSStepper                       |                                                                                                                                                                                              |
| DatePicker                      | UIDatePicker                                                   | NSDatePicker                    |                                                                                                                                                                                              |
| Picker                          | UISegmentedControl                                             | NSSegmentedControl              | This currently only supports the `PickerStyle.segmentedControl` right now, which is why the method is called `inspectSegmentedControl`.                                                      |
| ColorPicker                     | UIColorWell                                                    | NSColorWell                     |                                                                                                                                                                                              |
| NavigationView / NavigationStack | UINavigationController / UISplitViewController / UINavigationBar | _is no relevant native control_ | The default function `inspect` returns a `UINavigationController`. `UISplitViewController` is available via `inspectSplitViewController` and `UINavigationBar` using `inspectNavigationBar`. |
| TabView                         | UITabBarController / UITabBar                                   | _is no relevant native control_ | The default function `inspect` returns a `UITabBarController`. `UITabBar` is available via `inspectTabBar`.                                                                                  |

*on iOS, depending on the environment and OS Version, `List` and `Form` can be both a `UITableView` and a `UICollectionView` and thus their subviews can be either `UITableViewCell` or `UICollectionViewCell`. `ListInspectionNativeView` and `ListCellInspectionNativeView` are enums, which contain the found view as an associated value (e.g. `ListInspectionNativeView.tableView(UITableView)`). In most instances you should propably support both cases.

## Why it is more safe and more swifty than Introspect

The biggest differences between Inspect and Introspect are:
1. Inspect does not assume a strict view hierarchy (for example for the searched view to be a child of the parent of the `InspectionView`), but instead goes through the levels of the view hierarchy until it has found the correct view. It does so by matching the `InspectionView` frame against the frame of any potential result candidate. 
2. By searching for the view with the correct frame, some problems we encountered with Introspect can be avoided, for example when adding multiple views of the same type to a VStack or HStack and inspecting one of them, Inspect will retrieve the right one, while Introspect often retrieved the first one.
3. Inspects public API heavily embraces Swifts strong type system. You can only call inspect on the SwiftUI type that corresponds to the searched-for UIKit or AppKit type. For example, on iOS, you call `inspect()` on a SwiftUI `TextField` and get a `UITextField`. You cannot call `inspect()` to retrieve a `UITextField` on any other SwiftUI type, not even on a modified `TextField`. _This does not apply to `UITableViewCell` resp. `UICollectionViewCell`, which do not have a corresponding SwiftUI type._

## How it works

Inspect works by adding a `InspectionView`, as a background view, to the view hierarchy. It then looks for a view that has the same global frame as the `InspectionView` and is of the type you are looking for. It is a little bit more complicated in some cases, where the looked-for frame differs from the `InspectionView`'s frame, but you can find all of that out by looking at the code.

**Please note that this introspection method might break in future SwiftUI releases.** Future implementations might not use UIKit elements that are being looked for. Though the library is unlikely to crash, the `.inspect()` method will not be called in those cases.

### Usage in production

`Inspect` can be used in production and follows some ground-rules to operate:
- Inspect will never use private APIs
- Inspect will never force-cast to the UIKit or AppKit counterparts

## Examples

### TextField

```swift
TextField("Placeholder", text: $textValue)
.inspect { field in
    field.layer.backgroundColor = UIColor.red.cgColor
}
```

## Install

### SwiftPM
```
https://github.com/quintschaf/SwiftUI-Inspect.git
```

## To-Do
- [ ] Efficiency Improvements
- [ ] Assert and support more views
- [ ] Add more examples to the readme
- [ ] Add more documentation
- [ ] Support tvOS
- [ ] Support more `Picker` styles other than `.segmentedControl`, propably with an enum return (like a List)

## Special Thanks

Special thanks to Siteline, Loïs Di Qual and all other contributors of [`SwiftUI-Introspect`](https://github.com/siteline/SwiftUI-Introspect) for a lot of inspiration.

<!-- References -->
[GithubCI_Status]: https://github.com/quintschaf/swiftui-inspect/actions/workflows/ci.yml/badge.svg?branch=main
[GithubCI_URL]: https://github.com/quintschaf/SwiftUI-Inspect/actions/workflows/ci.yml
[Quintschaf_Badge]: https://badgen.net/badge/Built%20and%20maintained%20by/Quintschaf/cyan?icon=https://quintschaf.com/assets/logo.svg
