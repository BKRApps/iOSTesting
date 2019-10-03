//
//  NetworkResult.swift
//  iOSTesting-Techniques
//
//  Created by kumar reddy on 02/10/19.
//  Copyright © 2019 kumar reddy. All rights reserved.
//

import Foundation

enum NetworkResult {
    case success([String: Any])
    case failure(statusCode: HTTPStatusCodes, title: String, subTitle: String)
}

enum HTTPStatusCodes: Int, Equatable {
    case success = 200
    case notFound = 404
    case tooManyRequests = 429
    case unAvailable = 503
}
