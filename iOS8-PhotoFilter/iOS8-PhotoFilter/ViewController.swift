//
//  ViewController.swift
//  iOS8-PhotoFilter
//
//  Created by Paul Solt on 9/30/19.
//  Copyright © 2019 Lambda, Inc. All rights reserved.
//

import UIKit
import CoreImage

class ViewController: UIViewController {

	private let context = CIContext(options: nil)
	private let filter = CIFilter(name: "CIColorControls")!
	
	
	@IBOutlet var brightnessSlider: UISlider!
	@IBOutlet var contrastSlider: UISlider!
	@IBOutlet var saturationSlider: UISlider!
	
	
	override func viewDidLoad() {
		super.viewDidLoad()

	}


	// TODO: Extract to helper file
	
	func filterImage(_ image: UIImage) -> UIImage {
		
//		let ciImage = image.ciImage // NIL! not going to work
		
		guard let cgImage = image.cgImage else { fatalError("No image available for filtering")}
		
//		CIImage.init(cgImage: cgImage)
		let ciImage = CIImage(cgImage: cgImage)
		
//		filter.setValue(ciImage, forKey: "inputImage")
		filter.setValue(ciImage, forKey: kCIInputImageKey)
		
//		filter.setValue(brightnessSlider.value, forKey: "inputBrightness")
		filter.setValue(brightnessSlider.value, forKey: kCIInputBrightnessKey)
		filter.setValue(contrastSlider.value, forKey: kCIInputContrastKey)
		filter.setValue(saturationSlider.value, forKey: kCIInputSaturationKey)
		
		guard let outputCIImage = filter.outputImage else { return image } // default to do nothing if this is not setup ... may want to fatalError() to catch a bug early with filter setup
		
//		outputCIImage.cgImage // nil with a CIImage (just a recipe until rendered)

		// Render the image
		guard let outputCGImage = context.createCGImage(outputCIImage, from: CGRect(origin: .zero, size: image.size)) else { return image } // TODO fatalError?
		
		return UIImage(cgImage: outputCGImage)
	}
	
	// MARK: Actions
	
	@IBAction func choosePhotoButtonPressed(_ sender: Any) {
		
	}
	
	@IBAction func savePhotoButtonPressed(_ sender: UIButton) {
		
	}
	
	// MARK: Slider events
	
	@IBAction func brightnessChanged(_ sender: UISlider) {
	}
	
	@IBAction func contrastChanged(_ sender: Any) {
	
	}
	
	@IBAction func saturationChanged(_ sender: Any) {
	
	}
}

