//
//  PlatformUtils.swift
//  MovieRating
//
//  Created by Ephraim Kunz on 6/22/16.
//  Copyright © 2016 Ephraim Kunz. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

struct Platform {
    static let isSimulator: Bool = {
        var isSim = false
        #if arch(i386) || arch(x86_64)
            isSim = true
        #endif
        return isSim
    }()
    
    static func getColorForRating(rating: Double) -> UIColor{
        if rating < NSUserDefaults().doubleForKey("badMovieThreshold"){
            return UIColor.flatRedColor()
        }
        else if rating < NSUserDefaults().doubleForKey("okMovieThreshold"){
            return UIColor.flatYellowColor()
        }
        else{
            return UIColor.flatGreenColor()
        }

    }
    
    static func systemVersion() -> String{
        return UIDevice.currentDevice().systemVersion
    }
    
    static func systemName() -> String{
        return UIDevice.currentDevice().systemName
    }
    
    static func appName() -> String{
        let bundleDisplayName = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleDisplayName")
        if(bundleDisplayName != nil){
            return bundleDisplayName as! String
        }
        return NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleName") as! String
    }
    
    static func appVersion() -> String{
        return NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleShortVersionString") as! String
    }
    
    static func appBuild() -> String{
        return NSBundle.mainBundle().objectForInfoDictionaryKey(kCFBundleVersionKey as String) as!String
    }
    
    static func hasTorch() -> Bool{
        return AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo).hasTorch
    }
    
    static func toggleTorch() -> Bool{
        let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        if (device.hasTorch) {
            do {
                try device.lockForConfiguration()
                if (device.torchMode == .On) {
                    device.torchMode = .Off
                }
                else {
                    do {
                        try device.setTorchModeOnWithLevel(1.0)
                    }
                    catch {
                        print(error)
                    }
                }
                device.unlockForConfiguration()
                return true
            } catch {
                print(error)
                return false
            }
        }
        return false
    }
}
