////
////  memo.swift
////  MinecraftLogin (iOS)
////
////  Created by 内間理亜奈 on 2021/04/02.
////
//
//import Foundation
//import UIKit
//
//class ViewController: UIViewController {
//    
//}
//
//extension ViewController: VNDocumentCameraViewControllerDelegate {
//
//    // DocumentCamera で画像の保存に成功したときに呼ばれる
//    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
//        controller.dismiss(animated: true)
//
//        // Dispatch queue to perform Vision requests.
//        let textRecognitionWorkQueue = DispatchQueue(label: "TextRecognitionQueue",
//                                                             qos: .userInitiated, attributes: [], autoreleaseFrequency: .workItem)
//        textRecognitionWorkQueue.async {
//            self.resultingText = ""
//            for pageIndex in 0 ..< scan.pageCount {
//                let image = scan.imageOfPage(at: pageIndex)
//                if let cgImage = image.cgImage {
//                    let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
//
//                    do {
//                        try requestHandler.perform(self.requests)
//                    } catch {
//                        print(error)
//                    }
//                }
//            }
//            DispatchQueue.main.async(execute: {
//                // textViewに表示する
//                self.textView.text = self.resultingText
//            })
//        }
//    }
//}
