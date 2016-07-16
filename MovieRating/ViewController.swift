//
//  ViewController.swift
//  MovieRating
//
//  Created by Ephraim Kunz on 6/11/16.
//  Copyright © 2016 Ephraim Kunz. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    let session = AVCaptureSession()
    var previewLayer : AVCaptureVideoPreviewLayer?
    var processingNetworkRequest = false
    
    func addPreviewLayer() {
        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        //previewLayer?.bounds = self.view.bounds
        previewLayer?.position = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds))
        self.view.layer.addSublayer(previewLayer!)
        updateBracketSubview()
    }
    
    func updateBracketSubview(){
        if (self.view.subviews.last!.isKindOfClass(UIImageView)){ //Remove old bracket subview, if it exists
            self.view.subviews.last!.removeFromSuperview()
        }
        
        let bracket = UIImageView(image: UIImage(named: "overlayBracket"))
        bracket.backgroundColor = UIColor.clearColor()
        bracket.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height)
        self.view.addSubview(bracket)
    }
    
    func updateCameraFeed(){
        let previewLayerConnection = previewLayer?.connection;
        
        if (previewLayerConnection!.supportsVideoOrientation){
            previewLayerConnection?.videoOrientation = AVCaptureVideoOrientation.init(rawValue: UIApplication.sharedApplication().statusBarOrientation.rawValue)!
            previewLayer?.frame = self.view.bounds
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(!Platform.isSimulator){
            let captureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
            do{
                let inputDevice = try AVCaptureDeviceInput(device: captureDevice)
                
                session.addInput(inputDevice)
            }
            catch _{
                print("Cannot find the capture device. You may be running this in the simulator");
            }
            
            let output = AVCaptureMetadataOutput()
            session.addOutput(output)
            output.metadataObjectTypes = [
                AVMetadataObjectTypeEAN8Code,
                AVMetadataObjectTypeUPCECode,
                AVMetadataObjectTypeEAN13Code]
          
            output.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        }
    }
    
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBar.barTintColor = UIColor.flatMintColor()
        let firstTime = NSUserDefaults().boolForKey("firstTime")
        if(firstTime){
            NSUserDefaults().setBool(false, forKey: "firstTime")
            
            let historyVC = self.storyboard?.instantiateViewControllerWithIdentifier("historyController")
            let historyNavCtrl = self.storyboard?.instantiateViewControllerWithIdentifier("historyNavController") as! UINavigationController
            historyNavCtrl.viewControllers = [historyVC!]
            self.presentViewController(historyNavCtrl, animated: false, completion: nil)
        }


        processingNetworkRequest = false
        if(!Platform.isSimulator){
            addPreviewLayer()
        }
        session.startRunning()
        updateCameraFeed()
        UIDevice.currentDevice().beginGeneratingDeviceOrientationNotifications()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.updateCameraFeed), name: UIDeviceOrientationDidChangeNotification, object: UIDevice.currentDevice())
         NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.updateBracketSubview), name: UIDeviceOrientationDidChangeNotification, object: UIDevice.currentDevice())
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(animated: Bool) {
        session.stopRunning()
    }

    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        if(self.processingNetworkRequest){
            return
        }
        
        for data in metadataObjects {
            let barcode = data as! AVMetadataMachineReadableCodeObject
 
            NetworkManager.getItemForUPC(barcode.stringValue){movieInfo in
                let detailView = self.storyboard?.instantiateViewControllerWithIdentifier("detailViewController") as! DetailViewController
                detailView.movieInfo = movieInfo
                self.navigationController?.pushViewController(detailView, animated: true)
            }
            processingNetworkRequest = true
            break //Only send the first valid code
        }
    }
}

