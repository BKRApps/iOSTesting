//
//  ArticlesViewModel.swift
//  iOSTesting-Techniques
//
//  Created by kumar reddy on 02/10/19.
//  Copyright © 2019 kumar reddy. All rights reserved.
//

import Foundation

final class ArticlesViewModel {
    let session: URLSession
    let urlEndPoint = "https://jsoneditoronline.org/?id=1bb4efa559f245d582d2342c9dcad821"
    
    init(session: URLSession) {
        self.session = session
    }
    
    func getArticles(completionHandler: @escaping (NetworkResult) -> Void) {
        self.session.dataTask(with: URL(string: urlEndPoint)!) { (data, response, error) in
            if let statusCode = (response as? HTTPURLResponse)?.statusCode,
                let httpStatusCode = HTTPStatusCodes(rawValue: statusCode) {
                switch httpStatusCode {
                case HTTPStatusCodes.success:
                    if let d = data,
                        let obj = try? JSONSerialization.jsonObject(with: d, options: JSONSerialization.ReadingOptions.allowFragments),
                        let object = obj as? [String: Any] {
                        completionHandler(NetworkResult.success(object))
                    }
                case HTTPStatusCodes.tooManyRequests:
                    completionHandler(NetworkResult.failure(statusCode: HTTPStatusCodes.tooManyRequests, title: "429", subTitle: "Too many requests"))
                case HTTPStatusCodes.notFound:
                    completionHandler(NetworkResult.failure(statusCode: HTTPStatusCodes.notFound, title: "404", subTitle: "Not Found"))
                case HTTPStatusCodes.unAvailable:
                    completionHandler(NetworkResult.failure(statusCode: HTTPStatusCodes.unAvailable, title: "503", subTitle: "Un Available"))
                }
            }
        }.resume()
    }
}
