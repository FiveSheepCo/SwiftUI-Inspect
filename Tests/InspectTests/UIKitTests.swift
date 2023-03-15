#if canImport(UIKit)

import XCTest
import SwiftUI
@testable import Inspect

struct InspectTestView<U: View>: View {
    @ViewBuilder let view: () -> U
    
    var body: some View {
        VStack {
            view()
        }
    }
}

final class UIKitTests: XCTestCase {
    enum Constants {
        static let testString1 = "x"
        static let testString2 = "y"
        
        static let failString1 = "a"
        static let failString2 = "b"
    }
    
    func present<T: View>(view: T) {
        let hostingController = UIHostingController(rootView: view)
                
        let application = UIApplication.shared
        application.windows.forEach { window in
            if let presentedViewController = window.rootViewController?.presentedViewController {
                presentedViewController.dismiss(animated: false, completion: nil)
            }
            window.isHidden = true
        }
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.layer.speed = 10
        
        hostingController.beginAppearanceTransition(true, animated: false)
        window.rootViewController = hostingController
        window.makeKeyAndVisible()
        window.layoutIfNeeded()
        hostingController.endAppearanceTransition()
    }
    
    func testTextField() throws {
        let expectation = XCTestExpectation()
        
        present(
            view: InspectTestView {
                TextField(Constants.failString1, text: .constant(Constants.failString2))
                TextField(Constants.testString1, text: .constant(Constants.testString2))
                    .inspect { textField in
                        XCTAssertEqual(textField.placeholder, Constants.testString1)
                        XCTAssertEqual(textField.text, Constants.testString2)
                        expectation.fulfill()
                    }
                TextField(Constants.failString1, text: .constant(Constants.failString2))
            }
        )
        
        wait(for: [expectation], timeout: 1)
    }
    
    @available(iOS 14.0, *)
    @available(tvOS, unavailable)
    func testTextEditor() throws {
        let expectation = XCTestExpectation()
        
        present(
            view: InspectTestView {
                TextEditor(text: .constant(Constants.failString2))
                TextEditor(text: .constant(Constants.testString1))
                    .inspect { textView in
                        XCTAssertEqual(textView.text, Constants.testString1)
                        expectation.fulfill()
                    }
                TextEditor(text: .constant(Constants.failString2))
            }
        )
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testScrollView() throws {
        let expectation = XCTestExpectation()
        let expectation2 = XCTestExpectation()
        
        present(
            view: InspectTestView {
                ScrollView(showsIndicators: false) { }
                ScrollView(showsIndicators: true) { }
                .inspect { scrollView in
                    XCTAssertTrue(scrollView.showsVerticalScrollIndicator)
                    expectation.fulfill()
                }
                ScrollView(showsIndicators: false) { }
            }
        )
        
        present(
            view: InspectTestView {
                ScrollView(showsIndicators: false) { }
                    .inspect { scrollView in
                        XCTAssertFalse(scrollView.showsVerticalScrollIndicator)
                        expectation2.fulfill()
                    }
                ScrollView(showsIndicators: true) { }
                ScrollView(showsIndicators: false) { }
            }
        )
        
        wait(for: [expectation, expectation2], timeout: 1)
    }
    
    func testTableView() throws {
        let expectation = XCTestExpectation()
        let expectation2 = XCTestExpectation()
        
        present(
            view: InspectTestView {
                List { }
                .inspect { viewOption in
                    expectation.fulfill()
                }
            }
        )
        
        present(
            view: InspectTestView {
                Form { }
                    .inspect { viewOption in
                        expectation2.fulfill()
                    }
            }
        )
        
        wait(for: [expectation, expectation2], timeout: 1)
    }
    
    @available(iOS 16.0, *)
    func testTableViewCell() throws {
        let expectation = XCTestExpectation()
        let expectation2 = XCTestExpectation()
        
        present(
            view: InspectTestView {
                List {
                    Text(Constants.failString1)
                    TextField(Constants.testString1, text: .constant(""))
                        .inspectListOrFormCell { cellOption in
                            if case .collectionView(let cell) = cellOption {
                                let textField = cell.contentView.subviews[0].subviews.first(where: { $0.subviews.contains(where: { $0 is UITextField }) })?.subviews.first(where: { $0 is UITextField }) as? UITextField
                                
                                XCTAssertEqual(textField?.placeholder, Constants.testString1)
                            }
                            
                            expectation.fulfill()
                        }
                    TextField(Constants.testString2, text: .constant(""))
                        .inspectListOrFormCell { cellOption in
                            if case .collectionView(let cell) = cellOption {
                                let textField = cell.contentView.subviews[0].subviews.first(where: { $0.subviews.contains(where: { $0 is UITextField }) })?.subviews.first(where: { $0 is UITextField }) as? UITextField
                                
                                XCTAssertEqual(textField?.placeholder, Constants.testString2)
                            }
                            
                            expectation2.fulfill()
                        }
                    Text(Constants.failString2)
                }
                .inspect { viewOption in
                    expectation.fulfill()
                }
            }
        )
        
        wait(for: [expectation, expectation2], timeout: 1)
    }
    
    @available(tvOS, unavailable)
    func testSwitch() throws {
        let expectation = XCTestExpectation()
        
        present(
            view: InspectTestView {
                Toggle(Constants.failString1, isOn: .constant(false))
                Toggle(Constants.testString1, isOn: .constant(true))
                    .inspect { s in
                        XCTAssertTrue(s.isOn)
                        expectation.fulfill()
                    }
                Toggle(Constants.failString2, isOn: .constant(false))
            }
        )
        
        wait(for: [expectation], timeout: 1)
    }
    
    @available(tvOS, unavailable)
    func testSlider() throws {
        let expectation = XCTestExpectation()
        
        present(
            view: InspectTestView {
                Slider(value: .constant(0.5))
                    .inspect { slider in
                        XCTAssertEqual(slider.value, 0.5)
                        expectation.fulfill()
                    }
            }
        )
        
        wait(for: [expectation], timeout: 1)
    }
    
    @available(tvOS, unavailable)
    func testStepper() throws {
        let expectation = XCTestExpectation()
        
        present(
            view: InspectTestView {
                Stepper(Constants.testString1, value: .constant(0))
                    .inspect { s in
                        XCTAssertEqual(s.value, 0)
                        expectation.fulfill()
                    }
            }
        )
        
        wait(for: [expectation], timeout: 1)
    }
    
    @available(tvOS, unavailable)
    func testDatePicker() throws {
        let expectation = XCTestExpectation()
        
        present(
            view: InspectTestView {
                DatePicker(Constants.testString1, selection: .constant(.init(timeIntervalSince1970: 0)))
                    .inspect { picker in
                        XCTAssertEqual(picker.date.timeIntervalSince1970, 0)
                        expectation.fulfill()
                    }
            }
        )
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testSegmentedControl() throws {
        let expectation = XCTestExpectation()
        
        present(
            view: InspectTestView {
                Picker(Constants.testString1, selection: .constant(true), content: {})
                    .inspectSegmentedControl { segmentedControl in
                        expectation.fulfill()
                    }
                    .pickerStyle(.segmented)
            }
        )
        
        wait(for: [expectation], timeout: 1)
    }
    
    @available(iOS 14.0, *)
    @available(tvOS, unavailable)
    func testColorWell() throws {
        let expectation = XCTestExpectation()
        
        present(
            view: InspectTestView {
                ColorPicker(Constants.testString1, selection: .constant(.black))
                    .inspect { picker in
                        XCTAssertEqual(picker.selectedColor, .init(red: 0, green: 0, blue: 0, alpha: 1))
                        expectation.fulfill()
                    }
            }
        )
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testNavigationController() throws {
        let expectation = XCTestExpectation()
        let expectation2 = XCTestExpectation()
        let barExpectation = XCTestExpectation()
        
        present(
            view: InspectTestView {
                NavigationView {
                    Text("")
                        .navigationBarTitle(Text(Constants.testString1))
                }
                .inspect { controller in
                    expectation.fulfill()
                }
            }
        )
        
        present(
            view: InspectTestView {
                TabView {
                    NavigationView {
                        Text("")
                            .navigationBarTitle(Text(Constants.testString1))
                    }
                    .inspect { controller in
                        expectation2.fulfill()
                    }
                }
            }
        )
        
        present(
            view: InspectTestView {
                NavigationView {
                    Text("")
                        .navigationBarTitle(Text(Constants.testString1))
                }
                .inspectNavigationBar { bar in
                    barExpectation.fulfill()
                }
            }
        )
        
        wait(for: [expectation], timeout: 1)
        wait(for: [expectation2], timeout: 1)
        wait(for: [barExpectation], timeout: 1)
    }
    
    @available(iOS 16.0, *)
    func testNavigationStack() throws {
        let expectation = XCTestExpectation()
        let expectation2 = XCTestExpectation()
        let barExpectation = XCTestExpectation()
        
        present(
            view: InspectTestView {
                NavigationStack {
                    Text("")
                        .navigationBarTitle(Text(Constants.testString1))
                }
                .inspect { controller in
                    expectation.fulfill()
                }
            }
        )
        
        present(
            view: InspectTestView {
                TabView {
                    NavigationStack {
                        Text("")
                            .navigationBarTitle(Text(Constants.testString1))
                    }
                    .inspect { controller in
                        expectation2.fulfill()
                    }
                }
            }
        )
        
        present(
            view: InspectTestView {
                NavigationStack {
                    Text("")
                        .navigationBarTitle(Text(Constants.testString1))
                }
                .inspectNavigationBar { bar in
                    barExpectation.fulfill()
                }
            }
        )
        
        wait(for: [expectation], timeout: 1)
        wait(for: [expectation2], timeout: 1)
        wait(for: [barExpectation], timeout: 1)
    }
    
    func testSplitViewController() throws {
        let expectation = XCTestExpectation()
        let expectation2 = XCTestExpectation()
        
        present(
            view: InspectTestView {
                NavigationView {
                    Text("")
                        .navigationBarTitle(Text(Constants.testString1))
                }
                .inspectSplitViewController { controller in
                    expectation.fulfill()
                }
            }
        )
        
        present(
            view: InspectTestView {
                TabView {
                    NavigationView {
                        Text("")
                            .navigationBarTitle(Text(Constants.testString1))
                    }
                    .inspectSplitViewController { controller in
                        expectation2.fulfill()
                    }
                }
            }
        )
        
        wait(for: [expectation, expectation2], timeout: 1)
    }
    
    func testTabBarController() throws {
        let expectation = XCTestExpectation()
        let expectation2 = XCTestExpectation()
        let barExpectation = XCTestExpectation()
        
        present(
            view: InspectTestView {
                TabView {
                    Text("1")
                        .tabItem {
                            Image(systemName: "circle")
                            Text(Constants.testString1)
                        }
                    Text("2")
                        .tabItem {
                            Image(systemName: "circle")
                            Text(Constants.testString2)
                        }
                }
                .inspect { controller in
                    XCTAssertEqual(controller.tabBar.items?.first?.title, Constants.testString1)
                    XCTAssertEqual(controller.tabBar.items?.last?.title, Constants.testString2)
                    expectation.fulfill()
                }
            }
        )
        
        present(
            view: InspectTestView {
                TabView {
                    NavigationView {
                        Text("1")
                    }
                    .tabItem {
                        Image(systemName: "circle")
                        Text(Constants.testString1)
                    }
                    NavigationView {
                        Text("2")
                    }
                    .tabItem {
                        Image(systemName: "circle")
                        Text(Constants.testString2)
                    }
                }
                .inspect { controller in
                    XCTAssertEqual(controller.tabBar.items?.first?.title, Constants.testString1)
                    XCTAssertEqual(controller.tabBar.items?.last?.title, Constants.testString2)
                    expectation2.fulfill()
                }
            }
        )
        
        present(
            view: InspectTestView {
                TabView {
                    Text("1")
                        .tabItem {
                            Image(systemName: "circle")
                            Text(Constants.testString1)
                        }
                    Text("2")
                        .tabItem {
                            Image(systemName: "circle")
                            Text(Constants.testString2)
                        }
                }
                .inspectTabBar { tabBar in
                    XCTAssertEqual(tabBar.items?.first?.title, Constants.testString1)
                    XCTAssertEqual(tabBar.items?.last?.title, Constants.testString2)
                    barExpectation.fulfill()
                }
            }
        )
        
        wait(for: [expectation, expectation2, barExpectation], timeout: 1)
    }
}
#endif
