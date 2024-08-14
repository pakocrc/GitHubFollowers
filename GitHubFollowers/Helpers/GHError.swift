//
//  GHError.swift
//  GitHubFollowers
//
//  Created by Francisco Cordoba on 13/8/24.
//

import Foundation

enum GHError: String, Error {
    case invalidUsername = "This username is an invalid username. Please use a valid username and try again."
    case unableToComplete = "Unexpected error while requesting information. Please check your internet connection and try again."
    case unsuccessfulResponse = "Unsuccessful response from the server. Please try again."
    case invalidData = "Invalid data received from server. Please try again."
    case decodingError = "Invalid data decoding. Please try again."
}
