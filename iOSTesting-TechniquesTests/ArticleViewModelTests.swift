//
//  ArticleViewModelTests.swift
//  iOSTesting-TechniquesTests
//
//  Created by kumar reddy on 02/10/19.
//  Copyright © 2019 kumar reddy. All rights reserved.
//

import XCTest
@testable import iOSTesting_Techniques

class ArticleViewModelTests: XCTestCase {
    var session: URLSession!
    var viewModel: ArticlesViewModel!
    
    override func setUp() {
        let confiiguration = URLSessionConfiguration.ephemeral
        confiiguration.protocolClasses = [MockURLProtocol.self]
        session = URLSession(configuration: confiiguration)
        viewModel = ArticlesViewModel(session: session)
    }

    override func tearDown() {
        
    }
    
    func testAPINotFound() {
        let expect = expectation(description: #function)
        MockURLProtocol.requestHandler = { request in
            let response = ""
            let mockData = response.data(using: .utf8)
            let mockResponse = HTTPURLResponse(url: request.url!,
                                               statusCode: HTTPStatusCodes.notFound.rawValue,
                                               httpVersion: nil,
                                               headerFields: nil)
            return (mockResponse!, mockData!)
        }
        viewModel.getArticles { (networkResult) in
            switch networkResult {
            case let .failure(statusCode, title, subTitle):
                XCTAssertTrue(statusCode == HTTPStatusCodes.notFound, "expected status code is 404")
                XCTAssertEqual(title, "404")
                XCTAssertEqual(subTitle, "Not Found")
                expect.fulfill()
            default:
                XCTFail("This is not expected, the API should throw failure")
            }
        }
        
        waitForExpectations(timeout: 10.0) { (error) in
            guard error == nil else {
                return XCTFail("Timeout")
            }
        }
    }
}
