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
    
    var lookupMode: Bool = false
    
    // in foreign language
    var huntWord: String = ""
    // in english
    var englishWord: String = ""

    private var _imageCaptureSession: AVCaptureSession!
    private var _captureLayer: AVCaptureVideoPreviewLayer!
    private var _backCameraInput: AVCaptureDeviceInput!
    private var _stillImageOutput: AVCaptureStillImageOutput!
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var guidancePretextLabel: UILabel!
    @IBOutlet weak var mainLabel: UILabel!
    
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var captureButton: ActionGlowButton!
    
    convenience init(scavengerWord: String, wordInEnglish: String) {
        self.init(nibName: "ScavengerCaptureViewController", bundle: nil)
        lookupMode = false
        huntWord = scavengerWord
        englishWord = wordInEnglish
    }
    
    convenience init() {
        self.init(nibName: "ScavengerCaptureViewController", bundle: nil)
        lookupMode = true
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if lookupMode == false {
            guidancePretextLabel.text = "Looking for"
            mainLabel.text = huntWord
        } else {
            guidancePretextLabel.text = ""
            mainLabel.text = "Lookup"
        }
        
        captureButton.setupButtonWithTitle("Capture")
        
        // Image Capture Preview
        _imageCaptureSession = AVCaptureSession()
        _imageCaptureSession.sessionPreset = AVCaptureSessionPreset640x480
        
        let devices = AVCaptureDevice.devicesWithMediaType(AVMediaTypeVideo)
        var backCameraOrNil: AVCaptureDevice?
        for device in devices as! [AVCaptureDevice] {
            if device.position == AVCaptureDevicePosition.Back {
                backCameraOrNil = device
            }
        }
        
        guard let backCamera = backCameraOrNil else {
            print("no back camera")
            return
        }
        
        _backCameraInput = try! AVCaptureDeviceInput(device: backCamera)
        
        if _imageCaptureSession.canAddInput(_backCameraInput) {
            _imageCaptureSession.addInput(_backCameraInput)
        }
        
        _captureLayer = AVCaptureVideoPreviewLayer(session: _imageCaptureSession)
        _captureLayer.frame = cameraView.bounds
        _captureLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        cameraView.layer.addSublayer(_captureLayer)
        cameraView.layer.cornerRadius = 10
        cameraView.layer.masksToBounds = true
        
        // Configure output
        _stillImageOutput = AVCaptureStillImageOutput()
        _stillImageOutput.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
        guard _imageCaptureSession.canAddOutput(_stillImageOutput) else {
            print("Session cannot add still image output")
            return
        }
        
        _imageCaptureSession.addOutput(_stillImageOutput)
        
        // Start Running session
        _imageCaptureSession.startRunning()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(scavengerCompleted), name: SignalConstants.SignalScavengerCompletedNotification, object: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        _captureLayer.frame = cameraView.bounds
        
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    
    ///data is photoImage NSData
    private func verifyWithServer(data: NSData) {
        
        let request = NetworkRequests()
        
        if lookupMode == false {
            request.verify(data, itemName: englishWord) { (success, resultCorrect, associations) in
                
                guard success else {
                    print("Error: verify not successful")
                    return
                }
                
                NSOperationQueue.mainQueue().addOperationWithBlock({
                    let imageOrNil = UIImage(data: data)
                    
                    guard let image = imageOrNil else {
                        print("no captured image")
                        return
                    }
                    
                    let completionViewController = ScavengerCompletionViewController(capturedImage: image, guessCorrectness: resultCorrect, associations: associations, itemName: self.huntWord)
                    self.presentViewController(completionViewController, animated: true, completion: nil)
                })
            }
            
        } else { // look up mode
            
            request.lookup(data, completionBlock: { (success, associations) in
                guard success else {
                    print("error")
                    return
                }
                
                NSOperationQueue.mainQueue().addOperationWithBlock({
                    let imageOrNil = UIImage(data: data)
                    
                    guard let image = imageOrNil else {
                        print("no captured image")
                        return
                    }
                    
                    let firstAssociation = associations.first as AssociationItem!
                    
                    let itemName = firstAssociation.translation
                    let restOfAssociations = Array(associations[1..<associations.count])
                    
                    let completionVC = ScavengerCompletionViewController(capturedImage: image, associations: restOfAssociations, itemName: itemName)
                    self.presentViewController(completionVC, animated: true, completion: nil)
                })
                
            })
        }
        
    }
    
    // MARK - NSNotification
    func scavengerCompleted() {
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    
    // MARK - Callbacks

    @IBAction func backButtonPressed(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func captureButtonTapped(sender: AnyObject) {
        
        var videoConnection: AVCaptureConnection!;
        for connection in _stillImageOutput.connections {
            for ports in connection.inputPorts {
                if ports.mediaType == AVMediaTypeVideo {
                    videoConnection = connection as! AVCaptureConnection
                }
            }
        }
        
        _stillImageOutput.captureStillImageAsynchronouslyFromConnection(videoConnection) { (buffer, error) in
            guard error == nil else {
                print(error)
                return
            }
            
            let jpgData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(buffer)
            self.verifyWithServer(jpgData)

        }
    }

    
}
