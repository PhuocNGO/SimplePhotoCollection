//
//  Router.swift
//  SimplePhotoCollection
//
//  Created by Tommy Ngo.
//  Copyright © 2020 Ngo. All rights reserved.
//

import Foundation
import Alamofire

enum Router : URLRequestConvertible {
    
    case listImages(page: Int, limit: Int)
    case imageDetail(id: String)
    
    static public var apiURL: URL { return URL(string: "https://picsum.photos")! }
    
    var path: String {
        switch self {
            case .listImages:
                return "/v2/list"
            case .imageDetail(let id):
                return "/id/\(id)/info"
        }
    }
    
    var components: URLComponents? {
        switch self {
        case .listImages(let page, let limit):
            var urlComponents = URLComponents(string: Router.apiURL.absoluteString)!
            urlComponents.queryItems = [
                URLQueryItem(name: "page", value: "\(page)"),
                URLQueryItem(name: "limit", value: "\(limit)")
            ]
            return urlComponents
        default:
            return nil
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        var url: URL = Router.apiURL.appendingPathComponent(path)
        switch self {
            case .listImages(let page, let limit):
                var urlComponents = URLComponents(string: url.absoluteString)!
                urlComponents.queryItems = [
                    URLQueryItem(name: "page", value: "\(page)"),
                    URLQueryItem(name: "limit", value: "\(limit)")
                ]
                url = urlComponents.url!
            default:
                print("Nothing")
        }
        return URLRequest(url: url)
    }
}
