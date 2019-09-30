//
//  ViewController.swift
//  iOS8-PhotoFilter
//
//  Created by Paul Solt on 9/30/19.
//  Copyright © 2019 Lambda, Inc. All rights reserved.
//

import UIKit
import CoreImage
import Photos

class ViewController: UIViewController {

	private let context = CIContext(options: nil)
	private let filter = CIFilter(name: "CIColorControls")!
	
	private var originalImage: UIImage? {
		didSet {

			guard let image = originalImage else { return }
			
			var maxSize = imageView.bounds.size
			let scale = UIScreen.main.scale
			
			maxSize = CGSize(width: maxSize.width * scale,
								height: maxSize.height * scale)

			scaledImage = image.imageByScaling(toSize: maxSize)
		}
	}
	
	private var scaledImage: UIImage? {
		didSet {
			updateImage()
		}
	}
	
	@IBOutlet var brightnessSlider: UISlider!
	@IBOutlet var contrastSlider: UISlider!
	@IBOutlet var saturationSlider: UISlider!
	@IBOutlet var imageView: UIImageView!
	
	override func viewDidLoad() {
		super.viewDidLoad()

		print("Screen: \(UIScreen.main.bounds) scale: \(UIScreen.main.scale)")
		print("imageView: \(imageView.bounds)")
		
		
		
		originalImage = imageView.image // TEMP: store original until picker setup
	}

	private func updateImage() {
		if let image = originalImage {
			imageView.image = filterImage(image)
		} else {
			// TODO: set to nil? clear it?
		}
	}
	// TODO: Extract to helper file
	
	func filterImage(_ image: UIImage) -> UIImage {
		guard let cgImage = image.cgImage else { fatalError("No image available for filtering")}
		
		let ciImage = CIImage(cgImage: cgImage)
		filter.setValue(ciImage, forKey: kCIInputImageKey)
		filter.setValue(brightnessSlider.value, forKey: kCIInputBrightnessKey)
		filter.setValue(contrastSlider.value, forKey: kCIInputContrastKey)
		filter.setValue(saturationSlider.value, forKey: kCIInputSaturationKey)
		
		guard let outputCIImage = filter.outputImage else { return image } // default to do nothing if this is not setup ... may want to fatalError() to catch a bug early with filter setup
		
		guard let outputCGImage = context.createCGImage(outputCIImage, from: CGRect(origin: .zero, size: image.size)) else { return image } // TODO fatalError?
		
		return UIImage(cgImage: outputCGImage)
	}
	
	// MARK: Actions
	
	@IBAction func choosePhotoButtonPressed(_ sender: Any) {
		// TODO: show the photo picker so we can choose on-device photos
		// UIImagePickerController + Delegate
	}
	
	@IBAction func savePhotoButtonPressed(_ sender: UIButton) {
		saveFilteredPhoto()
	}
	
	func saveFilteredPhoto() {
		guard let originalImage = originalImage else { return }
		
		let filteredImage = filterImage(originalImage)
		print("Filtered: \(filteredImage.size)")
		
		PHPhotoLibrary.requestAuthorization { (status) in
			guard status == .authorized else { fatalError("Handle unauthorized user")}
			
			PHPhotoLibrary.shared().performChanges({
				
				PHAssetCreationRequest.creationRequestForAsset(from: filteredImage
				)
				
			}) { (success, error) in
				if let error = error {
					print("Error saving photo: \(error)")
				}
				
				// TODO: present alert if applicable
				print("Saved photo")
			}
		}
	}
	
	
	// MARK: Slider events
	
	@IBAction func brightnessChanged(_ sender: UISlider) {
		updateImage()
	}
	
	@IBAction func contrastChanged(_ sender: Any) {
		updateImage()
	}
	
	@IBAction func saturationChanged(_ sender: Any) {
		updateImage()
	}
}

