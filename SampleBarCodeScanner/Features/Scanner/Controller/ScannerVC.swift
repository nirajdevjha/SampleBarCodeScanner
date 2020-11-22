//
//  ScannerVC.swift
//  SampleBarCodeScanner
//
//  Created by Niraj Kumar Jha on 22/11/20.
//  Copyright © 2020 Niraj Kumar Jha. All rights reserved.
//

import UIKit
import AVFoundation
import Vision

class ScannerVC: UIViewController {
    
    // MARK:- Outlets
    @IBOutlet private weak var startBtn: UIButton!
    @IBOutlet private weak var cartBtn: UIButton!
    @IBOutlet private weak var cartItemCountLbl: UILabel!
    @IBOutlet private weak var acessView: UIView!
    @IBOutlet private weak var accessLbl: UILabel!
    @IBOutlet private weak var grantAccessBtn: UIButton!
    
    // MARK:- Props
    private var captureSession: AVCaptureSession!
    private var backCamera: AVCaptureDevice?
    private var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
    private var captureOutput: AVCapturePhotoOutput?
    
    private var productCatalog = ProductList()
    
    private var viewModel: ScannerViewModel!
    
    lazy private var detectBarcodeRequest: VNDetectBarcodesRequest = {
        return VNDetectBarcodesRequest(completionHandler: { request, error in
            if let error = error {
                UIAlertController.showAlert(
                    from: self,
                    title: "Barcode Errore", msg: error.localizedDescription)
                return
            }
            self.processClassification(for: request)
        })
    }()
    
    // MARK:- life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = ScannerViewModel()
        viewModelEvents()
        setupViews()
        checkPermissions()
        setupCameraLiveView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        checkPermissions()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    // MARK:- Private
    private func setupViews() {
        startBtn.cornerRadius = startBtn.frame.height / 2
        cartItemCountLbl.cornerRadius = cartItemCountLbl.frame.height / 2
        acessView.isHidden = true
        cartBtn.isHidden = true
        cartItemCountLbl.isHidden = true
    }
    
    private func checkPermissions() {
        let mediaType = AVMediaType.video
        let status = AVCaptureDevice.authorizationStatus(for: mediaType)
        
        switch status {
        case .denied, .restricted:
            break
        case.notDetermined:
            AVCaptureDevice.requestAccess(for: mediaType) { granted in
                guard granted != true else { return }
                DispatchQueue.main.async {
                    
                }
            }
            
        default: break
        }
    }
    
    private func viewModelEvents() {
        viewModel.updateCartCount = { [weak self] count in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                guard count > 0 else {
                    self.cartBtn.isHidden = true
                    self.cartItemCountLbl.isHidden = true
                    return
                }
                self.cartBtn.isHidden = false
                self.cartItemCountLbl.isHidden = false
                self.cartItemCountLbl.text = "\(count)"
            }
        }
    }
    
    private func setupCameraLiveView() {
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = .hd1280x720
        
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .back)
        
        let devices = deviceDiscoverySession.devices
        for device in devices {
            if device.position == AVCaptureDevice.Position.back {
                backCamera = device
            }
        }
        
        guard let backCamera = backCamera else {
            UIAlertController.showAlert(
                from: self,
                title: "Camera error", msg: "There seems to be no camera on your device")
            return
        }
        // Set up the input and output stream.
        do {
            let captureDeviceInput = try AVCaptureDeviceInput(device: backCamera)
            captureSession.addInput(captureDeviceInput)
        } catch {
            UIAlertController.showAlert(
                from: self,
                title: "Camera error", msg: "Your camera can't be used as an input device")
            return
        }
        
        captureOutput = AVCapturePhotoOutput()
        captureOutput!.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])], completionHandler: nil)
        captureSession.addOutput(captureOutput!)
        
        // Add a preview layer.
        cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        cameraPreviewLayer?.videoGravity = .resizeAspectFill
        cameraPreviewLayer?.connection?.videoOrientation = .portrait
        cameraPreviewLayer?.frame = view.frame
        if let cameraPreviewLayer = cameraPreviewLayer {
            view.layer.insertSublayer(cameraPreviewLayer, at: 0)
        }
        captureSession.startRunning()
    }
    
    private func processScannedInfo(for payload: String) {
        if let product = productCatalog.product(forKey: payload) {
            debugPrint(payload)
            UIAlertController.showAlert(
            from: self,
            title: product.productName ?? "No product name provided", msg: payload)
            //add product to cart
            viewModel.addProductToCart(product)
            
        } else {
            UIAlertController.showAlert(
            from: self,
            title: "No item found for this payload", msg: "")
        }
    }
    
    private func nonAutherizedUI() {
        acessView.isHidden = false
        accessLbl.text = "Please grant access to the camera for scanning barcodes"
    }
    
    func processClassification(for request: VNRequest) {
        DispatchQueue.main.async {
            if let bestResult = request.results?.first as? VNBarcodeObservation,
                let payload = bestResult.payloadStringValue {
                self.processScannedInfo(for: payload)
            } else {
                UIAlertController.showAlert(
                    from: self,
                    title: "Unable to extract results", msg: "Cannot extract barcode information")
            }
        }
    }
    
    @IBAction
    private func didTapStart(_ sender: UIButton) {
        let settings = AVCapturePhotoSettings()
        captureOutput?.capturePhoto(with: settings, delegate: self)
    }
    
    @IBAction
    private func didTapCartButton(_ sender: UIButton) {
        let cartVM = CartListViewModel(addedProductList: viewModel.addedProductsToCart)
        let cartVC = CartListVC(viewModel: cartVM)
        let navController = UINavigationController(rootViewController: cartVC)
        present(navController, animated: true)
    }
    
    @IBAction
    private func didTapGrantAccess(_ sender: UIButton) {
        let settingsURL = URL(string: UIApplication.openSettingsURLString)!
        UIApplication.shared.open(settingsURL) { _ in
            self.checkPermissions()
        }
    }
}

// MARK: - AVCapturePhotoCaptureDelegate
extension ScannerVC: AVCapturePhotoCaptureDelegate {
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let imageData = photo.fileDataRepresentation(),
            let image = UIImage(data: imageData) {
            
            guard let ciImage = CIImage(image: image) else {
                fatalError("Unable to create \(CIImage.self) from \(image).")
            }
            
            DispatchQueue.global(qos: .userInitiated).async {
                let handler = VNImageRequestHandler(ciImage: ciImage, orientation: .up, options: [:])
                do {
                    try handler.perform([self.detectBarcodeRequest])
                } catch {
                    UIAlertController.showAlert(
                        from: self,
                        title: "Error Decoding Barcode", msg: error.localizedDescription)
                }
            }
        }
    }
}
