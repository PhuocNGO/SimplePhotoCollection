//
//  Client.swift
//  SimplePhotoCollection
//
//  Created by Tommy Ngo.
//  Copyright © 2020 Ngo. All rights reserved.
//

import Alamofire
import Alamofire_SwiftyJSON

class Client {
    enum APIResult<Value> {
        case success(Value)
        case failure(Error)
    }
    
    private static func performRequest<T: Decodable>(router: Router, completion: @escaping(APIResult<T>)->Void) {
        Alamofire.request(router).validate().responseSwiftyJSON { (response) in
            switch response.result {
            case .success(let jsonData):
                let decoder = JSONDecoder()
                do {
                    let decodeData = try decoder.decode(T.self, from: jsonData.rawData())
                    completion(.success(decodeData))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    static func requestListImages(page: Int, limit: Int, completionQueue: DispatchQueue = .main, completion: @escaping(APIResult<[ImageModel]>) -> Void) {
        performRequest(router: .listImages(page: page, limit: limit)) { (result) in
            completionQueue.async {
                completion(result)
            }
        }
    }
    
    static func requestImageDetail(id: String, competionQueue: DispatchQueue = .main, completion: @escaping(APIResult<ImageModel>)->Void) {
        performRequest(router: .imageDetail(id: id)) { (result) in
            competionQueue.async {
                completion(result)
            }
        }
    }
}
