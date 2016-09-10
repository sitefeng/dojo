//
//  ScavengerCaptureViewController.swift
//  Signal
//
//  Created by Si Te Feng on 9/10/16.
//  Copyright © 2016 Technochimera. All rights reserved.
//

import UIKit
import AVFoundation

final internal class ScavengerCaptureViewController: UIViewController {
    
    var huntWord: String = ""

    private let _imageCaptureSession = AVCaptureSession()
    private var _captureLayer: AVCaptureVideoPreviewLayer
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var guidancePretextLabel: UILabel!
    @IBOutlet weak var mainLabel: UILabel!
    
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var captureButton: ActionGlowButton!
    
    convenience init(scavengerWord: String) {
        self.init(nibName: "ScavengerCaptureViewController", bundle: nil)
        huntWord = scavengerWord
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        _captureLayer = AVCaptureVideoPreviewLayer(session: _imageCaptureSession)
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        _captureLayer = AVCaptureVideoPreviewLayer(session: _imageCaptureSession)
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _captureLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        cameraView.layer.addSublayer(_captureLayer)
        
        captureButton.setupButtonWithTitle("Capture")

    }

    @IBAction func backButtonPressed(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func captureButtonTapped(sender: AnyObject) {
        
        
    }

}
