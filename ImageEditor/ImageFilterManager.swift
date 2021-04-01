//
//  File.swift
//  ImageEditor
//
//  Created by Panchami Rao on 31/03/21.
//

import Foundation
import Photos
import UIKit
import CoreImage

class ImageFilterManager: NSObject {
    
    private lazy var filterApplyingQueue = DispatchQueue(label: "ImageFilterQueue")
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

    func applyFilter(filterType: IEFilterType, intensity: Float, radius: Float, onImage inputImage: UIImage, completion: @escaping (_ image: UIImage?)->Void)  {
        filterApplyingQueue.async { [weak self] in
            var filteredImage: UIImage?
            guard let `self` = self else { return }
            switch filterType {
            case .color(let colorSubFilter):
                switch colorSubFilter {
                case .sepeia:
                    filteredImage = self.applyFilter(filterType: .color(subfilter: .sepeia(intensity: intensity)), onImage: inputImage)
                case .transfer:
                    filteredImage = self.applyFilter(filterType: .color(subfilter: .transfer), onImage: inputImage)
                }
            case .style(let styleSubFilter):
                switch styleSubFilter {
                case .bloom:
                    filteredImage = self.applyFilter(filterType: .style(subfilter: .bloom(intensity: intensity, radius: radius)), onImage: inputImage)
                case .gloom:
                    filteredImage = self.applyFilter(filterType: .style(subfilter: .bloom(intensity: intensity, radius: radius)), onImage: inputImage)
                }
            case .blur(let blurSubFilter):
                switch blurSubFilter {
                case .disc:
                    filteredImage = self.applyFilter(filterType: .blur(subfilter: .disc(radius: radius)), onImage: inputImage)
                case .rectangular:
                    filteredImage = self.applyFilter(filterType: .blur(subfilter: .rectangular(radius: radius)), onImage: inputImage)
                }
                
            case IEFilterType.none:
                break
            }
            DispatchQueue.main.async {
                completion(filteredImage)
            }
        }
    }

    private func applyFilter(filterType: IEFilterType, onImage inputImage: UIImage)-> UIImage? {
        var outputImage: UIImage?
        switch filterType {
        case .color(let colorSubFilter):
            switch colorSubFilter {
            case .sepeia(let intensity):
                outputImage = sepiaFilter(inputImage, intensity: intensity)
            case .transfer:
                outputImage = transferEffectFilter(inputImage)
            }
        case .style(let styleSubFilter):
            switch styleSubFilter {
            case .bloom(let intensity, let radius):
                outputImage = bloomFilter(inputImage, intensity: intensity, radius: radius)
            case .gloom(let intensity, let radius):
                outputImage = gloomFilter(inputImage, intensity: intensity, radius: radius)
            }
        case .blur(let blurSubFilter):
            switch blurSubFilter {
            case .disc(let radius):
                outputImage = discBlurFilter(inputImage, radius: radius)
            case .rectangular(let radius):
                outputImage = rectangularBlurFilter(inputImage, radius: radius)
            }

        case .none:
            break
        }
        return outputImage
    }
//MARK: -
//MARK: - Applying Filter Methods
//MARK: -
    private func sepiaFilter(_ inputImage: UIImage, intensity: Float = 3.0) -> UIImage? {
        var outputImage: UIImage?
        let sepiaFilter = CIFilter(name:"CISepiaTone")
        if let input = convertToCIImage(inputImage: inputImage) {
            sepiaFilter?.setValue(input, forKey: kCIInputImageKey)
        }
        sepiaFilter?.setValue(intensity, forKey: kCIInputIntensityKey)
        if let filteredImage = sepiaFilter?.outputImage {
            let displayImage = UIImage(ciImage: filteredImage, scale: inputImage.scale, orientation: inputImage.imageOrientation)
            outputImage = displayImage
        }
        return outputImage
        
    }

    private func transferEffectFilter(_ inputImage:UIImage) -> UIImage? {
        var outputImage: UIImage?
        let transferFilter = CIFilter(name:"CIPhotoEffectTransfer")
        if let input = convertToCIImage(inputImage: inputImage) {
            transferFilter?.setValue(input, forKey: kCIInputImageKey)
        }
        if let filteredImage = transferFilter?.outputImage {
            let displayImage = UIImage(ciImage: filteredImage, scale: inputImage.scale, orientation: inputImage.imageOrientation)
            outputImage = displayImage
        }
        return outputImage
    }
        
    private func bloomFilter(_ inputImage: UIImage,intensity: Float, radius: Float) -> UIImage? {
        var outputImage: UIImage?
        let bloomFilter = CIFilter(name:"CIBloom")
        if let input = convertToCIImage(inputImage: inputImage) {
            bloomFilter?.setValue(input, forKey: kCIInputImageKey)
        }
        bloomFilter?.setValue(intensity, forKey: kCIInputIntensityKey)
        bloomFilter?.setValue(radius, forKey: kCIInputRadiusKey)
        if let filteredImage = bloomFilter?.outputImage {
            let displayImage = UIImage(ciImage: filteredImage, scale: inputImage.scale, orientation: inputImage.imageOrientation)
            outputImage = displayImage
        }
        return outputImage
    }

    private func gloomFilter(_ inputImage: UIImage, intensity: Float, radius: Float) -> UIImage? {
        var outputImage: UIImage?
        let gloomFilter = CIFilter(name:"CIGloom")
        if let input = convertToCIImage(inputImage: inputImage) {
            gloomFilter?.setValue(input, forKey: kCIInputImageKey)
        }
        gloomFilter?.setValue(intensity, forKey: kCIInputIntensityKey)
        gloomFilter?.setValue(radius, forKey: kCIInputRadiusKey)
        if let filteredImage = gloomFilter?.outputImage {
            let displayImage = UIImage(ciImage: filteredImage, scale: inputImage.scale, orientation: inputImage.imageOrientation)
            outputImage = displayImage
        }
        return outputImage
    }

    private func rectangularBlurFilter(_ inputImage: UIImage, radius: Float = 5.0) -> UIImage? {
        var outputImage: UIImage?
        let blurFilter = CIFilter(name:"CIBoxBlur")
        if let input = convertToCIImage(inputImage: inputImage) {
            blurFilter?.setValue(input, forKey: kCIInputImageKey)
        }
        blurFilter?.setValue(radius, forKey: kCIInputRadiusKey)
        if let filteredImage = blurFilter?.outputImage {
            let displayImage = UIImage(ciImage: filteredImage, scale: inputImage.scale, orientation: inputImage.imageOrientation)
            outputImage = displayImage
        }
        return outputImage
    }

    private func discBlurFilter(_ inputImage: UIImage, radius: Float = 5.0) -> UIImage? {
        var outputImage: UIImage?
        let discFilter = CIFilter(name:"CIDiscBlur")
        if let input = convertToCIImage(inputImage: inputImage) {
            discFilter?.setValue(input, forKey: kCIInputImageKey)
        }
        discFilter?.setValue(5, forKey: kCIInputRadiusKey)
        if let filteredImage = discFilter?.outputImage {
            let displayImage = UIImage(ciImage: filteredImage, scale: inputImage.scale, orientation: inputImage.imageOrientation)
            outputImage = displayImage
        }
        return outputImage
    }
}
