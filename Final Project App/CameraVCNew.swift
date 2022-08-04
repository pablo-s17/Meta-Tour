//
//  CameraVCNew.swift
//  Final Project App
//
//  Created by Pablo Segovia on 8/2/22.
//

import UIKit
import MobileCoreServices
import UniformTypeIdentifiers
import AVKit
import CoreMotion

class CameraVCNew: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var walkButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    
    let manager = CMMotionManager()
    var dataMatrix = [[Double]]()
    var dataTimer : Timer?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        walkButton.isEnabled = Checking.videoRecorded
        
        if Checking.videoRecorded {
            recordButton.isEnabled = false
        } else {
            recordButton.isEnabled = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func recordPressed(_ sender: UIButton) {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            print("camera available")
            
            let videoPicker = UIImagePickerController()
            videoPicker.delegate = self
            videoPicker.sourceType = .camera
            videoPicker.mediaTypes = [kUTTypeMovie as String]
            //            videoPicker.mediaTypes = [UTType.movie.identifier as String]
            videoPicker.allowsEditing = false
            videoPicker.cameraDevice = .rear
            //            videoPicker.cameraOverlayView
            videoPicker.videoQuality = .typeMedium
            //            videoPicker.videoMaximumDuration = 10
            
            //MARK: - HERE
            Checking.videoRecorded = true
            
            startGettingData()
            
            self.present(videoPicker, animated: true, completion: nil)
            
        } else {
            
            print("camera NOT available")
            
        }
    }
    
    @IBAction func walkPressed(_ sender: UIButton) {
        Checking.videoRecorded = false
        self.dismiss(animated: true)
        
    }
    
    @IBAction func donePressed(_ sender: UIButton) {
        Checking.goHome = true
        Checking.videoRecorded = false
        
        let alert = UIAlertController(title: "Did you end the tour where you started?", message: "", preferredStyle: .alert)
        
        let actionNo = UIAlertAction(title: "No", style: .default) { action in
            
            Checking.startIsEnd = false
            var textField = UITextField()
            
            let alert = UIAlertController(title: "Title your tour!", message: "", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Confirm", style: .default) { action in
                
                BRUH.title = textField.text!
                print(BRUH.title)
                self.dismiss(animated: true)
                
            }
            
            alert.addTextField { alertTextField in
                alertTextField.placeholder = "ex. Nathan's House"
                alertTextField.autocapitalizationType = .sentences
                textField = alertTextField
            }
            
            alert.addAction(action)
            
            self.present(alert, animated: true, completion: nil)
            //            self.dismiss(animated: true)
        }
        
        let actionYes = UIAlertAction(title: "Yes", style: .default) { action in
            
            Checking.startIsEnd = true
            
            var textField = UITextField()
            
            let alert = UIAlertController(title: "Title your tour!", message: "", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Confirm", style: .default) { action in
                
                BRUH.title = textField.text!
                print(BRUH.title)
                self.dismiss(animated: true)
                
            }
            
            alert.addTextField { alertTextField in
                alertTextField.placeholder = "ex. Nathan's House"
                alertTextField.autocapitalizationType = .sentences
                textField = alertTextField
            }
            
            alert.addAction(action)
            
            self.present(alert, animated: true, completion: nil)
            //            self.dismiss(animated: true)
            
        }
        
        alert.addAction(actionYes)
        
        alert.addAction(actionNo)
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Camera Functions
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        stopGettingData()
        
        // Check for the media type
        let mediaType = info[UIImagePickerController.InfoKey.mediaType] as! CFString
        switch mediaType {
        case kUTTypeMovie:
            // Handle video selection result
            print("Selected media is video")
            let videoUrl = info[UIImagePickerController.InfoKey.mediaURL] as! URL
            print(videoUrl)
            print("-----SPACE-----")
            print(encodeVideo(videoURL: videoUrl))
            print("------END------")
            
        default:
            print("Mismatched type: \(mediaType)")
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        Checking.videoRecorded = false
        picker.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Data Collection
    
    func startGettingData() {
        manager.startAccelerometerUpdates()
        manager.startGyroUpdates()
        manager.startDeviceMotionUpdates()
        Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { _ in
            self.startTimer()
        }
    }
    
    //Getting Data helpers
    func startTimer () {
        var range = 0
        dataTimer = Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true) { _ in
            if let accel = self.manager.accelerometerData, let gyro = self.manager.gyroData, let devMotion = self.manager.deviceMotion {
                let t = Double(20 * range)
                let xA = accel.acceleration.x
                let yA = accel.acceleration.y
                let zA = accel.acceleration.z
                let xG = gyro.rotationRate.x
                let yG = gyro.rotationRate.y
                let zG = gyro.rotationRate.z
                let xH = devMotion.attitude.pitch // =X
                let yH = devMotion.attitude.roll // =Y
                let zH = devMotion.attitude.yaw // =Z
//                print("here ", range)
                let compiledData = [t, xA, yA, zA, xG, yG, zG, xH, yH, zH]
                self.dataMatrix.append(compiledData)
                range += 1
            }
        }
    }
    
    func stopTimer () {
        dataTimer?.invalidate()
        dataTimer = nil
    }
    
    func stopGettingData() {
        stopTimer()
        manager.stopAccelerometerUpdates()
        manager.stopGyroUpdates()
        manager.stopDeviceMotionUpdates()
        BRUH.BRUH.append(dataMatrix)
    }
    
//    func uploadImage(videoData: Data, testString: String, title: String, description: String) {
//        let request = MultipartFormDataRequest(url: URL(string: "http://localhost:5002/upload-data")!)
//        request.addTextField(named: "readings", value: testString)
//        request.addTextField(named: "title", value: title)
//        request.addTextField(named: "description", value: description)
//        request.addDataField(named: "videos", data: videoData, mimeType: "video/mp4")
//
//        //video/mp4
//        URLSession.shared.dataTask(with: request) { data, _, error  in
//            guard let data = data, error == nil else {
//                return
//            }
//
//            do {
//                print("Success: \(data)")
//            }
//        }.resume()
//    }


}
