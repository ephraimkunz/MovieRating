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
        previewLayer?.position = CGPoint(x: self.view.bounds.midX, y: self.view.bounds.midY)
        self.view.layer.addSublayer(previewLayer!)
        updateBracketSubview()
    }
    
    func updateBracketSubview(){
        if (self.view.subviews.last!.isKind(of: UIImageView.self)){ //Remove old bracket subview, if it exists
            self.view.subviews.last!.removeFromSuperview()
        }
        
        let bracket = UIImageView(image: UIImage(named: "overlayBracket"))
        bracket.backgroundColor = UIColor.clear
        bracket.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        self.view.addSubview(bracket)
    }
    
    func updateCameraFeed(){
        let previewLayerConnection = previewLayer?.connection;
        
        if (previewLayerConnection!.isVideoOrientationSupported){
            previewLayerConnection?.videoOrientation = AVCaptureVideoOrientation.init(rawValue: UIApplication.shared.statusBarOrientation.rawValue)!
            previewLayer?.frame = self.view.bounds
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(!Platform.isSimulator){
            let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
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
          
            output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        }
        
        let firstTime = UserDefaults().bool(forKey: "firstTime")
        if(firstTime){
            UserDefaults().set(false, forKey: "firstTime")
            
            let historyVC = self.storyboard?.instantiateViewController(withIdentifier: "historyController")
            let historyNavCtrl = self.storyboard?.instantiateViewController(withIdentifier: "historyNavController") as! UINavigationController
            historyNavCtrl.viewControllers = [historyVC!]
            self.present(historyNavCtrl, animated: false, completion: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.barTintColor = UIColor.flatMint()

        processingNetworkRequest = false
        if(!Platform.isSimulator){
            addPreviewLayer()
        }
        session.startRunning()
        updateCameraFeed()
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.updateCameraFeed), name: NSNotification.Name.UIDeviceOrientationDidChange, object: UIDevice.current)
         NotificationCenter.default.addObserver(self, selector: #selector(ViewController.updateBracketSubview), name: NSNotification.Name.UIDeviceOrientationDidChange, object: UIDevice.current)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        session.stopRunning()
    }

    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        if(self.processingNetworkRequest){
            return
        }
        
        for data in metadataObjects {
            let barcode = data as! AVMetadataMachineReadableCodeObject
 
            NetworkManager.getItemForUPC(barcode.stringValue){movieInfo in
                let detailView = self.storyboard?.instantiateViewController(withIdentifier: "detailViewController") as! DetailViewController
                detailView.movieInfo = movieInfo
                self.navigationController?.pushViewController(detailView, animated: true)
            }
            processingNetworkRequest = true
            break //Only send the first valid code
        }
    }
}

