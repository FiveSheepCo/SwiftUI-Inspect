#if canImport(AppKit)

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

final class AppKitTests: XCTestCase {
    enum Constants {
        static let testString1 = "x"
        static let testString2 = "y"
        
        static let failString1 = "a"
        static let failString2 = "b"
    }
    
    func present<T: View>(view: T) {
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered, defer: false)
        window.center()
        window.setFrameAutosaveName("Main Window")
        window.contentView = NSHostingView(rootView: view)
        window.makeKeyAndOrderFront(nil)
        window.layoutIfNeeded()
    }
    
    func testTextField() throws {
        let expectation = XCTestExpectation()
        
        present(
            view: InspectTestView {
                TextField(Constants.failString1, text: .constant(Constants.failString2))
                TextField(Constants.testString1, text: .constant(Constants.testString2))
                    .inspect { textField in
                        XCTAssertEqual(textField.placeholderString, Constants.testString1)
                        XCTAssertEqual(textField.stringValue, Constants.testString2)
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
                        XCTAssertEqual(textView.string, Constants.testString1)
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
                    // TODO: XCTAssertTrue(scrollView.showsVerticalScrollIndicator)
                    expectation.fulfill()
                }
                ScrollView(showsIndicators: false) { }
            }
        )
        
        present(
            view: InspectTestView {
                ScrollView(showsIndicators: false) { }
                    .inspect { scrollView in
                        // TODO: XCTAssertFalse(scrollView.showsVerticalScrollIndicator)
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
        
        present(
            view: InspectTestView {
                List { }
                .inspect { tableView in
                    expectation.fulfill()
                }
            }
        )
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testButton() throws {
        let expectation = XCTestExpectation()
        
        present(
            view: InspectTestView {
                Spacer()
                Button(Constants.testString1, action: {})
                    .inspect { button in
                        expectation.fulfill()
                    }
                Spacer()
            }
        )
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testSwitch() throws {
        let expectation = XCTestExpectation()
        
        present(
            view: InspectTestView {
                Toggle(Constants.failString1, isOn: .constant(false))
                Toggle(Constants.testString1, isOn: .constant(true))
                    .inspect { s in
                        // TODO: XCTAssertTrue(s.isOn)
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
                        XCTAssertEqual(slider.doubleValue, 0.5)
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
                        XCTAssertEqual(s.intValue, 0)
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
                        XCTAssertEqual(picker.dateValue.timeIntervalSince1970, 0)
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
                ColorPicker(Constants.testString1, selection: .constant(Color.black))
                    .inspect { picker in
                        XCTAssertEqual(picker.color.redComponent, 0)
                        XCTAssertEqual(picker.color.greenComponent, 0)
                        XCTAssertEqual(picker.color.blueComponent, 0)
                        XCTAssertEqual(picker.color.alphaComponent, 1)
                        expectation.fulfill()
                    }
            }
        )
        
        wait(for: [expectation], timeout: 1)
    }
    
    /*func testNavigationController() throws {
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
    }*/
}
#endif
