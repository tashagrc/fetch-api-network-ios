//
//  CoinAPIError.swift
//  ios-networking
//
//  Created by Natasha Radika on 15/11/25.
//

import Foundation

enum CoinAPIError: Error {
    case invalidData
    case jsonParsingFailure
    case requestFailed(description: String)
    case invalidStatusCode(statusCode: Int)
    case unknownError(error: Error)
    
    var customDescription: String {
        switch self {
        case .invalidData:
            return "Invalid data"
        case .jsonParsingFailure:
            return "Failed to parse json"
        case .requestFailed(description: let description):
            return "Request failed \(description)"
        case .invalidStatusCode(statusCode: let statusCode):
            return "Invalid status code: \(statusCode)"
        case .unknownError(error: let error):
            return "Something went wrong \(error.localizedDescription)"
        }
    }
}
