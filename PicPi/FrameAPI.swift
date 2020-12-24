//
//  FrameAPI.swift
//  PicPi
//
//  Created by Mustafa T. Mohammed on 12/21/20.
//

import Foundation
import Moya
import Promises
func injectFrameAPI(host: URL) -> FrameAPI{return FrameAPIImpl()}
protocol FrameAPI {
  func upload(photoData: Data, filename: String) -> Promise<Void>
  func retrieveThumbnails() -> Promise<[URL]>
  func removePhoto(filename: String) -> Promise<Void>
}
class FrameAPIImpl: FrameAPI {
  struct Response : Decodable {
    var URLAsString : [String]
  }
  
  func removePhoto(filename: String) -> Promise<Void> {
    let promise = Promise<Void>.pending()
    self.photoProvider.request(.removePhoto(filename: filename)) { (result) in
      switch result {
        case .success(let reponse):
          print(reponse , "Success")
          promise.fulfill(())
        case .failure(let error):
          promise.reject(error)
      }
    }
    return promise
  }
  
  func retrieveThumbnails() -> Promise<[URL]> {
    let promise = Promise<[URL]>.pending()
    //    let promise = Promise<Void>.pending()
    
    photoProvider.request(.retrieveThumbnails) { (result) in
      switch result {
        case .success(let response):
          do {
            let resultDecoded = try JSONDecoder().decode(Response.self, from: response.data)
            let urls = resultDecoded.URLAsString.compactMap(URL.init)
            promise.fulfill(urls)
            
          } catch {
            print(error)
          }
        case .failure(let error):
          promise.reject(error)
      }
    }
    print(promise)
    return promise
  }
  private let photoProvider = MoyaProvider<PhotosUpload>()
  
  func upload(photoData: Data, filename: String) -> Promise<Void> {
    let promise = Promise<Void> {(resolve , reject) in
      self.photoProvider.request(.uploadPhoto(photoData: photoData, nameAndExtension: filename)) { (result) in
        switch result {
          case .success(let reponse):
            print(reponse)
            resolve(())
          case .failure(let error):
            print(error)
            reject(error)
        }
      }
    }
    return promise
  }
  
  
}
