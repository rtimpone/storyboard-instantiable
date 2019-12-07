//
//  StoryboardInstantiable.swift
//  AutoRegistering
//
//  Created by Rob Timpone on 2/15/19.
//  Copyright © 2019 Rob Timpone. All rights reserved.
//

import UIKit

protocol StoryboardBased {
    
    static var storyboardName: String { get }
}

extension StoryboardBased {
    
    static var storyboardName: String {
        return String(describing: self)
    }
}

public enum DeviceType {
    
    case iPhone
    case iPad
    case unsupported
}

public protocol Device {
    
    var type: DeviceType { get }
}

extension UIDevice: Device {
    
    public var type: DeviceType {
        switch userInterfaceIdiom {
        case .phone:
            return .iPhone
        case .pad:
            return .iPad
        default:
            return .unsupported
        }
    }
}

enum StoryboardInstantiationError: Error, Equatable {
    
    /// The specified device type is not supported for instantiating from a storyboard
    case unsupportedDeviceType
    
    /// Unable to locate a storyboard for the storyboard name
    case storyboardMissing(String, String)
    
    /// There was no initial view controller to instantiate in the storyboard
    case initialViewControllerMissing(String)
    
    /// The initial view controller was of the incorrect type
    case wrongTypeForInitialViewController(String, String)
}

extension StoryboardInstantiationError: CustomStringConvertible {
    
    var description: String {
        switch self {
        case .unsupportedDeviceType:
            return "Unable to determine a storyboard name because the device type is unsupported"
        case .storyboardMissing(let universalStoryboardName, let deviceSpecificStoryboardName):
            return "Unable to locate a storyboard named '\(universalStoryboardName)' or '\(deviceSpecificStoryboardName)'"
        case .initialViewControllerMissing(let storyboardName):
            return "Unable to locate a storyboard named '\(storyboardName)"
        case .wrongTypeForInitialViewController(let storyboardName, let expectedTypeName):
            return "The initial view controller in storybard named '\(storyboardName)' is not of type '\(expectedTypeName)'"
        }
    }
}

public protocol StoryboardInstantiable: class where Self: StoryboardBased {
    
    static func instantiateFromStoryboard(forDevice device: Device) throws -> Self
}
