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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let captureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        do{
            let inputDevice = try AVCaptureDeviceInput(device: captureDevice)
            
            session.addInput(inputDevice)
            addPreviewLayer()
        }
        catch _{
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
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBar.barTintColor = UIColor.flatGreenColor()

        processingNetworkRequest = false
        session.startRunning()
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
 
            NetworkManager.getItemForUPC(barcode.stringValue){data in
                let detailView = self.storyboard?.instantiateViewControllerWithIdentifier("detailViewController") as! DetailViewController
                detailView.movieTitle = data
                self.navigationController?.pushViewController(detailView, animated: true)
            }
            processingNetworkRequest = true
            break //Only send the first valid code
        }
    }
}

