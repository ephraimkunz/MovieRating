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
        previewLayer?.bounds = self.view.bounds
        previewLayer?.position = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds))
        self.view.layer.addSublayer(previewLayer!)
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
                addPreviewLayer()
            }
            catch _{
                print("Cannot find the capture device. You may be running this in the simulator");
            }
            
            
            /* Check for metadata */
            let output = AVCaptureMetadataOutput()
            session.addOutput(output)
            output.metadataObjectTypes = [
                AVMetadataObjectTypeEAN8Code,
                AVMetadataObjectTypeUPCECode,
                AVMetadataObjectTypeEAN13Code]
          
            output.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        if(!Platform.isSimulator){
            updateCameraFeed() 
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBar.barTintColor = UIColor.flatMintColor()

        processingNetworkRequest = false
        session.startRunning()
        
        UIDevice.currentDevice().beginGeneratingDeviceOrientationNotifications()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.updateCameraFeed), name: UIDeviceOrientationDidChangeNotification, object: UIDevice.currentDevice())
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

