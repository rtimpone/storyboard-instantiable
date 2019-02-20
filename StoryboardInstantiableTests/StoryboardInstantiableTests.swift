//
//  StoryboardInstantiableTests.swift
//  StoryboardInstantiableTests
//
//  Created by Rob Timpone on 2/19/19.
//  Copyright © 2019 Rob Timpone. All rights reserved.
//

import XCTest
@testable import StoryboardInstantiable

struct MockDevice: Device {
    var type: DeviceType
}

class StoryboardInstantiableTests: XCTestCase {

    // Testing Success Cases
    
    func testUniversalStoryboardForIPhone() {
        let device = MockDevice(type: .iPhone)
        let vc = try? UniversalViewController.instantiateFromStoryboard(forDevice: device)
        XCTAssertNotNil(vc, "Expected the view controller to not be nil because a universal storyboard exists for this view controller type")
    }
    
    func testUniversalStoryboardForIPad() {
        let device = MockDevice(type: .iPad)
        let vc = try? UniversalViewController.instantiateFromStoryboard(forDevice: device)
        XCTAssertNotNil(vc, "Expected the view controller to not be nil because a universal storyboard exists for this view controller type")
    }
    
    func testIPhoneStoryboard() {
        let device = MockDevice(type: .iPhone)
        let vc = try? IPhoneViewController.instantiateFromStoryboard(forDevice: device)
        XCTAssertNotNil(vc, "Expected the view controller to not be nil because an iPhone-specific storyboard exists for this view controller type")
    }
    
    func testIPadStoryboard() {
        let device = MockDevice(type: .iPad)
        let vc = try? IPadViewController.instantiateFromStoryboard(forDevice: device)
        XCTAssertNotNil(vc, "Expected the view controller to not be nil because an iPad-specific storyboard exists for this view controller type")
    }
    
    func testIPhoneStoryboardOverridesUniversalStoryboard() {
        let device = MockDevice(type: .iPhone)
        let vc = try? OverrideViewController.instantiateFromStoryboard(forDevice: device)
        XCTAssertNotNil(vc, "Expected the view controller to not be nil because an iPhone-specific storyboard exists for this view controller type")
        
        vc?.loadViews()
        let labelText = vc?.label.text
        XCTAssertEqual(labelText, "iPhone", "Expected the label's text to reflect the text present on the iPhone-specific storyboard, since when a device specific storyboard and a universal storyboard are both available, the device-specific one overrides the universal one")
    }
    
    func testIPadStoryboardOverridesUniversalStoryboard() {
        let device = MockDevice(type: .iPad)
        let vc = try? OverrideViewController.instantiateFromStoryboard(forDevice: device)
        XCTAssertNotNil(vc, "Expected the view controller to not be nil because an iPad-specific storyboard exists for this view controller type")
        
        vc?.loadViews()
        let labelText = vc?.label.text
        XCTAssertEqual(labelText, "iPad", "Expected the label's text to reflect the text present on the iPad-specific storyboard, since when a device specific storyboard and a universal storyboard are both available, the device-specific one overrides the universal one")
    }
}

extension UIViewController {
    
    func loadViews() {
        let _ = view
    }
}
