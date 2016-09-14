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
    
    static func getColorForRating(_ rating: Double) -> UIColor{
        if rating < UserDefaults().double(forKey: "badMovieThreshold"){
            return UIColor.flatRed()
        }
        else if rating < UserDefaults().double(forKey: "okMovieThreshold"){
            return UIColor.flatYellow()
        }
        else{
            return UIColor.flatGreen()
        }

    }
    
    static func systemVersion() -> String{
        return UIDevice.current.systemVersion
    }
    
    static func systemName() -> String{
        return UIDevice.current.systemName
    }
    
    static func appName() -> String{
        let bundleDisplayName = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName")
        if(bundleDisplayName != nil){
            return bundleDisplayName as! String
        }
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as! String
    }
    
    static func appVersion() -> String{
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    }
    
    static func appBuild() -> String{
        return Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as!String
    }
    
    static func hasTorch() -> Bool{
        return AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo).hasTorch
    }
    
    static func toggleTorch() -> Bool{ // Returns new value of torch
        let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        var newTorchState = false
        
        if (device?.hasTorch)! {
            do {
                try device?.lockForConfiguration()
                if (device?.torchMode == .on) {
                    device?.torchMode = .off
                }
                else {
                    do {
                        try device?.setTorchModeOnWithLevel(1.0)
                        newTorchState = true
                    }
                    catch {
                        print(error)
                    }
                }
                device?.unlockForConfiguration()
            } catch {
                print(error)
            }
        }
        return newTorchState
    }
}
