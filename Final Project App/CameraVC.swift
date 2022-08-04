
//
//  CameraVC.swift
//  Final Project App
//
//  Created by Pablo Segovia on 7/25/22.
//

import UIKit
import MobileCoreServices
import UniformTypeIdentifiers
import AVKit

class CameraVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var walkButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    
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
            
            Checking.videoRecorded = true
            
            self.present(videoPicker, animated: true, completion: nil)

        } else {
            
            print("camera NOT available")
            
        }
    }
    
    @IBAction func donePressed(_ sender: UIButton) {
        Checking.goHome = true
        Checking.videoRecorded = false

//starts
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
            
            let action2 = UIAlertAction(title: "Cancel", style: .cancel)
            
            alert.addTextField { alertTextField in
                alertTextField.placeholder = "ex. Nathan's House"
                alertTextField.autocapitalizationType = .sentences
                textField = alertTextField
            }
            
            alert.addAction(action2)
            
            alert.addAction(action)
            
            self.present(alert, animated: true, completion: nil)

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
            
            let action2 = UIAlertAction(title: "Cancel", style: .cancel)
            
            alert.addTextField { alertTextField in
                alertTextField.placeholder = "ex. Nathan's House"
                alertTextField.autocapitalizationType = .sentences
                textField = alertTextField
            }
            
            alert.addAction(action2)
            
            alert.addAction(action)
            
            self.present(alert, animated: true, completion: nil)

        }

        alert.addAction(actionYes)

        alert.addAction(actionNo)

        present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func walkPressed(_ sender: UIButton) {
        Checking.videoRecorded = false
        self.dismiss(animated: true)
    }
}

//MARK: - Camera Funcs

func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {  // Check for the media type
    let mediaType = info[UIImagePickerController.InfoKey.mediaType] as! CFString
    switch mediaType {
    case kUTTypeMovie:
        // Handle video selection result
        print("Selected media is video")
        let videoUrl = info[UIImagePickerController.InfoKey.mediaURL] as! URL
        print(videoUrl)
        
    default:
        print("Mismatched type: \(mediaType)")
    }
    
    picker.dismiss(animated: true, completion: nil)
}

func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    print("canceling")
    picker.dismiss(animated: true, completion: nil)
}


