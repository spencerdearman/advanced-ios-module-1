//
//  ParentalGateErrors.swift
//  Storybook
//
//  Custom ErrorType for parental gate validation failures.
//

import Foundation

enum ParentalGateError: Error {
    case patternIncomplete(hitCount: Int, requiredCount: Int)
    case patternOutOfOrder
    case noDrawingDetected
    case validationFailed(reason: String)
}
