//
//  ViewController.swift
//  RecipEasy
//
//  Created by Anupam Chugh on 18/09/19.
//  Editted by Owen Smith on 2020-02-02.
//  Copyright © 2020 Owen Smith. All rights reserved.

import UIKit
import Vision
import VisionKit

class ScanViewController: UIViewController, VNDocumentCameraViewControllerDelegate, RecipeManagerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    
    var recipeManager = RecipeManager()
    var recipes: [RecipeData]?
    
    var textRecognitionRequest = VNRecognizeTextRequest(completionHandler: nil)
    private let textRecognitionWorkQueue = DispatchQueue(label: "MyVisionScannerQueue", qos: .userInitiated, attributes: [], autoreleaseFrequency: .workItem)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recipeManager.delegate = self
        setupVision()
    }
    
    @IBAction func btnSearch(_ sender: Any) {
        self.performSegue(withIdentifier: "goToResults", sender: self)
    }
    
    @IBAction func btnTakePicture(_ sender: Any) {
        
        let scannerViewController = VNDocumentCameraViewController()
        scannerViewController.delegate = self
        present(scannerViewController, animated: true)
    }
    
    private func setupVision() {
        textRecognitionRequest = VNRecognizeTextRequest { (request, error) in
            guard let observations = request.results as? [VNRecognizedTextObservation] else { return }
            
            var detectedText = ""
            for observation in observations {
                guard let topCandidate = observation.topCandidates(1).first else { return }
                print("text \(topCandidate.string) has confidence \(topCandidate.confidence)")
    
                detectedText += topCandidate.string
                detectedText += "\n"
                
            
            }
            
            DispatchQueue.main.async {
                //self.textView.text = detectedText
                //self.textView.flashScrollIndicators()
                
                //if let ingredients = detectedText{
                self.recipeManager.fetchIngredient(ingreds: detectedText)
                    //print(self.textView.text!)
                //}
                
                //self.performSegue(withIdentifier: "goToResults", sender: self)

            }
        }

        textRecognitionRequest.recognitionLevel = .accurate
    }
    
    private func processImage(_ image: UIImage) {
        imageView.image = image
        recognizeTextInImage(image)
    }
    
    private func recognizeTextInImage(_ image: UIImage) {
        guard let cgImage = image.cgImage else { return }
        
        //textView.text = ""
        textRecognitionWorkQueue.async {
            let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            do {
                try requestHandler.perform([self.textRecognitionRequest])
            } catch {
                print(error)
            }
        }
    }
    
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        guard scan.pageCount >= 1 else {
            controller.dismiss(animated: true)
            return
        }
        
        let originalImage = scan.imageOfPage(at: 0)
        let newImage = compressedImage(originalImage)
        controller.dismiss(animated: true)
        
        processImage(newImage)
    }
    
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
        print(error)
        controller.dismiss(animated: true)
    }
    
    func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
        controller.dismiss(animated: true)
    }

    func compressedImage(_ originalImage: UIImage) -> UIImage {
        guard let imageData = originalImage.jpegData(compressionQuality: 1),
            let reloadedImage = UIImage(data: imageData) else {
                return originalImage
        }
        return reloadedImage
    }
    
    func didUpdateRecipes(recipes: [RecipeData]) {
        self.recipes = recipes
        //print("EXECUTED")
        //print(recipes)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToResults"{
            let navVC = segue.destination as! UINavigationController
            let tableVC = navVC.viewControllers.first as! ResultViewController
            tableVC.recipes = recipes
        }
    }
}

