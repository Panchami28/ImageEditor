//
//  File.swift
//  ImageEditor
//
//  Created by Panchami Rao on 31/03/21.
//

import Foundation
import Photos
import UIKit

class ImageFilterManager {
    
//MARK: -
//MARK: - Convert UIImage into CIImage
//MARK: -
    func convertToCIImage(inputImage: UIImage?)->CIImage? {
        if let imageToEdit = inputImage {
            let originalCIImage = CIImage(image: imageToEdit)
            return originalCIImage
        }
        return nil
    }
//MARK: -
//MARK: - Applying Filter Methods
//MARK: -
    func sepiaFilter(_ inputUIImage: UIImage, intensity: Double) -> CIImage? {
        let sepiaFilter = CIFilter(name:"CISepiaTone")
        if let input = convertToCIImage(inputImage: inputUIImage) {
            sepiaFilter?.setValue(input, forKey: kCIInputImageKey)
        }
        sepiaFilter?.setValue(intensity, forKey: kCIInputIntensityKey)
        return sepiaFilter?.outputImage
    }
        
    func photoEffectFilter(_ inputUIImage:UIImage) -> CIImage? {
        let photoFilter = CIFilter(name:"CIPhotoEffectTransfer")
        if let input = convertToCIImage(inputImage: inputUIImage) {
            photoFilter?.setValue(input, forKey: kCIInputImageKey)
        }
        return photoFilter?.outputImage
    }
        
    func bloomFilter(_ inputUIImage: UIImage,intensity: Double, radius: Double) -> CIImage? {
        let bloomFilter = CIFilter(name:"CIBloom")
        if let input = convertToCIImage(inputImage: inputUIImage) {
            bloomFilter?.setValue(input, forKey: kCIInputImageKey)
        }
        bloomFilter?.setValue(intensity, forKey: kCIInputIntensityKey)
        bloomFilter?.setValue(radius, forKey: kCIInputRadiusKey)
        return bloomFilter?.outputImage
    }
        
    func gloomFilter(_ inputUIImage: UIImage, intensity: Double, radius: Double) -> CIImage? {
        let gloomFilter = CIFilter(name:"CIGloom")
        if let input = convertToCIImage(inputImage: inputUIImage) {
            gloomFilter?.setValue(input, forKey: kCIInputImageKey)
        }
        gloomFilter?.setValue(intensity, forKey: kCIInputIntensityKey)
        gloomFilter?.setValue(radius, forKey: kCIInputRadiusKey)
        return gloomFilter?.outputImage
    }
        
    func rectangularBlurFilter(_ inputUIImage: UIImage) -> CIImage? {
        let blurFilter = CIFilter(name:"CIBoxBlur")
        if let input = convertToCIImage(inputImage: inputUIImage) {
            blurFilter?.setValue(input, forKey: kCIInputImageKey)
        }
        blurFilter?.setValue(5, forKey: kCIInputRadiusKey)
        return blurFilter?.outputImage!
    }
        
    func discBlurFilter(_ inputUIImage: UIImage) -> CIImage? {
        let discFilter = CIFilter(name:"CIDiscBlur")
        if let input = convertToCIImage(inputImage: inputUIImage) {
            discFilter?.setValue(input, forKey: kCIInputImageKey)
        }
        discFilter?.setValue(5, forKey: kCIInputRadiusKey)
        return discFilter?.outputImage!
    }
}
