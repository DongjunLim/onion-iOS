//
//  CameraViewController.swift
//  onion-dev
//
//  Created by 임동준 on 2020/04/30.
//  Copyright © 2020 lacuna. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    let captureSession = AVCaptureSession()
    var videoDeviceInput: AVCaptureDeviceInput!
    let photoOutput = AVCapturePhotoOutput()
    var selectedImageView = UIImageView()
    let picker = UIImagePickerController()
    @IBOutlet weak var imgView: UIImageView!
    
    
    let sessionQueue = DispatchQueue(label: "session queue")
    
    let videoDeviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInDualCamera, .builtInWideAngleCamera, .builtInTrueDepthCamera], mediaType: .video, position: .unspecified)
    
    
    @IBOutlet weak var captureButton: UIButton!
    @IBOutlet weak var previewView: PreviewView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.picker.sourceType = .photoLibrary // 방식 선택. 앨범에서 가져오는걸로 선택.
        self.picker.allowsEditing = true // 수정가능하게 할지 선택. 하지만 false
        self.picker.delegate = self // picker delegate
        
        // TODO: 초기 설정 2
        previewView.session = captureSession
        sessionQueue.async {
            self.setupSession()
            self.startSession()
        }
        setupUI()
    }
    
    @IBAction func libraryButtonPressed(_ sender: UIButton) {
        present(picker, animated: false, completion: nil)
    }
    
    
    func setupUI() {
        captureButton.layer.cornerRadius = captureButton.bounds.height/2
        captureButton.layer.borderWidth = 5
        captureButton.layer.borderColor = UIColor.black.cgColor
        captureButton.layer.masksToBounds = true
    }
    
    
    @IBAction func capturePhoto(_ sender: UIButton) {
        // TODO: photoOutput의 capturePhoto 메소드
        // orientation
        // photooutput
        
        let videoPreviewLayerOrientation = self.previewView.videoPreviewLayer.connection?.videoOrientation
        sessionQueue.async {
            let connection = self.photoOutput.connection(with: .video)
            connection?.videoOrientation = videoPreviewLayerOrientation!
            let setting = AVCapturePhotoSettings()
            self.photoOutput.capturePhoto(with: setting, delegate: self)
        }
    }
    func savePhotoLibrary(image: UIImage) {
        // TODO: capture한 이미지 포토라이브러리에 저장
        PHPhotoLibrary.requestAuthorization { status in
            if status == .authorized {
                PHPhotoLibrary.shared().performChanges({
                    PHAssetChangeRequest.creationRequestForAsset(from: image)
                }, completionHandler: { (_, error) in
                    self.imgView.image = image
                    self.previewView.isHidden = true
                })
            } else {
                print(" error to save photo library")
            }
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var selectedImage: UIImage?
        if let editedImage = info[.editedImage] as? UIImage {
            selectedImage = editedImage
        } else if let originalImage = info[.originalImage] as? UIImage {
            selectedImage = originalImage
        }
        self.imgView.image = selectedImage!
        self.previewView.isHidden = true
        picker.dismiss(animated: true, completion: nil)

    }
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        let submitVC = self.storyboard?.instantiateViewController(withIdentifier: "SubmitViewController") as! SubmitViewController
        submitVC.feedImage = imgView.image
        
        self.navigationController?.pushViewController(submitVC, animated: true)
    }

}





extension CameraViewController {
    // MARK: - Setup session and preview
    func setupSession() {
        // TODO: captureSession 구성하기
        // - presetSetting 하기
        // - beginConfiguration
        // - Add Video Input
        // - Add Photo Output
        // - commitConfiguration
        captureSession.sessionPreset = .photo
        captureSession.beginConfiguration()
        
        // Add Video Input
        do {
            var defaultVideoDevice: AVCaptureDevice?
            if let dualCameraDevice = AVCaptureDevice.default(.builtInDualCamera, for: .video, position: .back) {
                defaultVideoDevice = dualCameraDevice
            } else if let backCameraDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) {
                defaultVideoDevice = backCameraDevice
            } else if let frontCameraDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) {
                defaultVideoDevice = frontCameraDevice
            }
            
            guard let camera = defaultVideoDevice else {
                captureSession.commitConfiguration()
                return
            }
            
            let videoDeviceInput = try AVCaptureDeviceInput(device: camera)
            
            if captureSession.canAddInput(videoDeviceInput) {
                captureSession.addInput(videoDeviceInput)
                self.videoDeviceInput = videoDeviceInput
            } else {
                captureSession.commitConfiguration()
                return
            }
        } catch {
            captureSession.commitConfiguration()
            return
        }
        
        // Add photo output
        photoOutput.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])], completionHandler: nil)
        if captureSession.canAddOutput(photoOutput) {
            captureSession.addOutput(photoOutput)
        } else {
            captureSession.commitConfiguration()
            return
        }
        captureSession.commitConfiguration()
    }
    
    
    
    func startSession() {
        // TODO: session Start
        if !captureSession.isRunning {
            sessionQueue.async {
                self.captureSession.startRunning()
            }
        }
    }
    
    func stopSession() {
        // TODO: session Stop
        if captureSession.isRunning {
            sessionQueue.async {
                self.captureSession.stopRunning()
            }
        }
    }
}

extension CameraViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        // TODO: capturePhoto delegate method 구현
        guard error == nil else { return }
        guard let imageData = photo.fileDataRepresentation() else { return }
        guard let image = UIImage(data: imageData) else { return }
        self.savePhotoLibrary(image: image)
    }
}
