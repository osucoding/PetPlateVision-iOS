//
//  MLService.swift
//  PetPlateVision
//
//  Created by John Choi on 4/14/23.
//

import UIKit
import CoreML
import Vision

class MLService {

    static let instance: MLService = MLService()

    private init() {}

    func detect(image: CIImage) -> String? {
        let config = MLModelConfiguration()
        guard let model = try? VNCoreMLModel(for: Inceptionv3(configuration: config).model) else {
            fatalError("Loading CoreML Model failed")
        }

        var detectedObject: String? = nil

        let request = VNCoreMLRequest(model: model) { request, error in
            guard let results = request.results as? [VNClassificationObservation] else {
                fatalError("Classification failed")
            }
            print(results.first.debugDescription)

            if let firstResult = results.first {
                print(firstResult.identifier)
                detectedObject = firstResult.identifier
            }
        }

        let handler = VNImageRequestHandler(ciImage: image)

        do {
            try handler.perform([request])
        } catch {
            print(error)
        }
        return detectedObject
    }
}
