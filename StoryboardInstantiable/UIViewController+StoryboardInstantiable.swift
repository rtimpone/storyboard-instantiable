//
//  UIViewController+StoryboardInstantiable.swift
//  AutoRegistering
//
//  Created by Rob Timpone on 2/15/19.
//  Copyright © 2019 Rob Timpone. All rights reserved.
//

import UIKit

extension UIViewController: StoryboardBased {
    
    // make all view controllers storyboard based by default
}

extension StoryboardInstantiable where Self: UIViewController {
    
    public static func instantiateFromStoryboard(forDevice device: Device = UIDevice.current) throws -> Self {
        
        let bundle = Bundle(for: self)
        let storyboardName = try self.storyboardName(forDevice: device, inBundle: bundle)
        let storyboard = UIStoryboard(name: storyboardName, bundle: bundle)
        
        guard let initialViewController = storyboard.instantiateInitialViewController() else {
            throw StoryboardInstantiationError.initialViewControllerMissing(storyboardName)
        }
        
        guard let instance = initialViewController as? Self else {
            let nameOfExpectedType = String(describing: self)
            throw StoryboardInstantiationError.wrongTypeForInitialViewController(storyboardName, nameOfExpectedType)
        }
        
        return instance
    }
    
    private static func storyboardName(forDevice device: Device, inBundle bundle: Bundle) throws -> String {
        
        let universalStoryboardName = storyboardName
        let universalStoryboardExists = storyboardExists(inBundle: bundle, withName: universalStoryboardName)
        
        let deviceSpecificStoryboardExtension = try storyboardExtension(forDevice: device)
        let deviceSpecificStoryboardName = storyboardName + deviceSpecificStoryboardExtension
        let deviceSpecificStoryboardExists = storyboardExists(inBundle: bundle, withName: deviceSpecificStoryboardName)
        
        if deviceSpecificStoryboardExists {
            return deviceSpecificStoryboardName
        }
        else if universalStoryboardExists {
            return universalStoryboardName
        }
        else {
            throw StoryboardInstantiationError.storyboardMissing(universalStoryboardName, deviceSpecificStoryboardName)
        }
    }
    
    private static func storyboardExtension(forDevice device: Device) throws -> String {
        switch device.type {
        case .iPhone:
            return "_iPhone"
        case .iPad:
            return "_iPad"
        case .unsupported:
            throw StoryboardInstantiationError.unsupportedDeviceType
        }
    }
    
    private static func storyboardExists(inBundle bundle: Bundle, withName name: String) -> Bool {
        
        let storyboardFileExtension = "storyboardc"
        return bundle.path(forResource: name, ofType: storyboardFileExtension) != nil
    }
}

extension UIViewController: StoryboardInstantiable {
    
    // make all view controllers instantiable from storyboards by default
}
