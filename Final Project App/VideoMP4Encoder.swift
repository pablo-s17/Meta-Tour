//
//  VideoMP4Encoder.swift
//  Final Project App
//
//  Created by Pablo Segovia on 8/2/22.
//

import Foundation
import AVFoundation

func encodeVideo(videoURL: URL){
    let avAsset = AVURLAsset(url: videoURL)
    let startDate = Date()
    let exportSession = AVAssetExportSession(asset: avAsset, presetName: AVAssetExportPresetPassthrough)
    
    let docDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    let myDocPath = NSURL(fileURLWithPath: docDir).appendingPathComponent("temp.mp4")?.absoluteString
    
    let docDir2 = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0] as NSURL
    
    let filePath = docDir2.appendingPathComponent("rendered-Video.mp4")
    deleteFile(filePath!)
    
    if FileManager.default.fileExists(atPath: myDocPath!){
        do{
            try FileManager.default.removeItem(atPath: myDocPath!)
        }catch let error{
            print(error, " 1")
        }
    }
    
    exportSession?.outputURL = filePath
    exportSession?.outputFileType = AVFileType.mp4
    exportSession?.shouldOptimizeForNetworkUse = true
    
    let start = CMTimeMakeWithSeconds(0.0, preferredTimescale: 0)
    let range = CMTimeRange(start: start, duration: avAsset.duration)
    exportSession?.timeRange = range
    
    exportSession!.exportAsynchronously{() -> Void in
        switch exportSession!.status{
        case .failed:
            print("\(exportSession!.error!)")
        case .cancelled:
            print("Export cancelled")
        case .completed:
            let endDate = Date()
            let time = endDate.timeIntervalSince(startDate)
            print(time)
            print("Successful")
            print(exportSession?.outputFileType ?? "")
            var url = exportSession?.outputURL
            print(exportSession?.outputURL?.path ?? "")
            do {
                let data = try Data(contentsOf: url!)
                BRUH.videos.append(data)
                print(data)
            } catch {
                print(error)
            }

        default:
            break
        }
        
    }
}

func deleteFile(_ filePath:URL) {
    guard FileManager.default.fileExists(atPath: filePath.path) else{
        return
    }
    do {
        try FileManager.default.removeItem(atPath: filePath.path)
    }catch{
        fatalError("Unable to delete file: \(error) : \(#function).")
    }
}
