//
//  ParentalGateErrors.swift
//  Storybook
//
//  Created by Spencer Dearman.
//

import Foundation

enum ParentalGateError: Error {
    case patternIncomplete(hitCount: Int, requiredCount: Int)
    case patternOutOfOrder
    case noDrawingDetected
    case validationFailed(reason: String)
}
