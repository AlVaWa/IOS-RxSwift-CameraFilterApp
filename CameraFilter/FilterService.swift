//
//  FilterService.swift
//  CameraFilter
//
//  Created by Aleksander Waage on 02/07/2020.
//  Copyright © 2020 Waageweb. All rights reserved.
//

import Foundation
import UIKit
import CoreImage
import RxSwift

class FilterService {
    
    private var context: CIContext
    
    init() {
        self.context = CIContext()
    }
    
    func applyFilter(to inputImage: UIImage) -> Observable<UIImage> {
        
        return Observable<UIImage>.create { observer in
            self.applyFilter(to: inputImage) { filteredImage in
                
                observer.onNext(filteredImage)
                
            }
            return Disposables.create()
        }
        
    }
    
    private func applyFilter(to inputImage: UIImage, completion: @escaping ((UIImage) -> ())) {
        
        if let filter = CIFilter(name: "CICMYKHalftone"){
            filter.setValue(5.0, forKey: kCIInputWidthKey)
            
            if let sourceImage = CIImage(image: inputImage) {

                filter.setValue(sourceImage, forKey: kCIInputImageKey)
                
                if let cgimage = self.context.createCGImage(filter.outputImage!, from: filter.outputImage!.extent) {
                    let processedImage = UIImage(cgImage: cgimage, scale: inputImage.scale, orientation: inputImage.imageOrientation)
                    completion(processedImage)
                }
            }
        }
        
    }
}
