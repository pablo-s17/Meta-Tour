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

//link to the view controller that will allow user to record
class CameraVCNew: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var walkButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    
    //set up tools to record data
    let manager = CMMotionManager()
    var dataMatrix = [[Double]]()
    var dataTimer : Timer?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        //enabling / disablign buttons depending on current stage in process
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
        
        //check if camera is available on selected device (i.e a simulator would not have a camera)
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            print("camera available")
            
            //access UIImagePickerController (the camera) 
            let videoPicker = UIImagePickerController()
            
            //customize the camera's capabilities
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
            
            //begin data collection while recording
            startGettingData()
            
            // open the camera
            self.present(videoPicker, animated: true, completion: nil)
            
        } else {
            
            print("camera NOT available")
            
        }
    }
    
    @IBAction func walkPressed(_ sender: UIButton) {
        Checking.videoRecorded = false
        //go back to walking
        self.dismiss(animated: true)
        
    }
    
    @IBAction func donePressed(_ sender: UIButton) {
        Checking.goHome = true
        Checking.videoRecorded = false
        
        // ask user if they ended the tour where they started and save the variable
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
    //opened after video is recorded
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        stopGettingData()
        
        // Check for the media type
        let mediaType = info[UIImagePickerController.InfoKey.mediaType] as! CFString
        switch mediaType {
        case kUTTypeMovie:
            print("Selected media is video")
            // get the video as a URL
            let videoUrl = info[UIImagePickerController.InfoKey.mediaURL] as! URL
//            let path = videoUrl.path
            print(videoUrl)
            print("-----SPACE-----")
            // convert video url (which is MOV) to MP4
            print(encodeVideo(videoURL: videoUrl))
            print("------END------")
//            UISaveVideoAtPathToSavedPhotosAlbum(path, nil, nil, nil)
            
        default:
            //error
            print("Mismatched type: \(mediaType)")
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    //if camera is cancelled
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        Checking.videoRecorded = false
        picker.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Data Collection
    
    //start collecting data
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
        //repeat timer every 20 milliseconds
        dataTimer = Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true) { _ in
            //get all the odometry information
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
                
                //save data as a variable and save it to constants
                let compiledData = [t, xA, yA, zA, xG, yG, zG, xH, yH, zH]
                self.dataMatrix.append(compiledData)
                range += 1
            }
        }
    }
    
    func stopTimer () {
        // stops the timer and thus the data collection
        dataTimer?.invalidate()
        dataTimer = nil
    }
    
    func stopGettingData() {
        //stop all readings
        stopTimer()
        manager.stopAccelerometerUpdates()
        manager.stopGyroUpdates()
        manager.stopDeviceMotionUpdates()
        
        //upload the data to constants
        BRUH.BRUH.append(dataMatrix)
    }
    
}
