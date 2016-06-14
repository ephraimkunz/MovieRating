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
    var  identifiedBorder : DiscoveredBarCodeView?
    var timer : NSTimer?
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
            
            identifiedBorder = DiscoveredBarCodeView(frame: self.view.bounds)
            identifiedBorder?.backgroundColor = UIColor.clearColor()
            identifiedBorder?.hidden = true;
            self.view.addSubview(identifiedBorder!)

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
        processingNetworkRequest = false
        session.startRunning()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(animated: Bool) {
        session.stopRunning()
    }
    
    func translatePoints(points : [AnyObject], fromView : UIView, toView: UIView)-> [CGPoint] {
        var translatedPoints : [CGPoint] = []
        for point in points {
            let dict = point as! NSDictionary
            let x = CGFloat((dict.objectForKey("X") as! NSNumber).floatValue)
            let y = CGFloat((dict.objectForKey("Y") as! NSNumber).floatValue)
            let curr = CGPointMake(x, y)
            let currFinal = fromView.convertPoint(curr, toView: toView)
            translatedPoints.append(currFinal)
        }
        return translatedPoints
    }
    
    func startTimer() {
        if timer?.valid != true {
            timer = NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: #selector(ViewController.removeBorder), userInfo: nil, repeats: false)
        } else {
            timer?.invalidate()
        }
    }
    
    func removeBorder() {
        /* Remove the identified border */
        self.identifiedBorder?.hidden = true
    }
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        if(self.processingNetworkRequest){
            return
        }
        
        for data in metadataObjects {
            let barcode = data as! AVMetadataMachineReadableCodeObject
            identifiedBorder?.frame = barcode.bounds
            identifiedBorder?.hidden = false
            let identifiedCorners = self.translatePoints(barcode.corners, fromView: self.view, toView: self.identifiedBorder!)
            identifiedBorder?.drawBorder(identifiedCorners)
            self.identifiedBorder?.hidden = false
            self.startTimer()
 
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

