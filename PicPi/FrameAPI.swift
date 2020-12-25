//
//  FrameAPI.swift
//  PicPi
//
//  Created by Mustafa T. Mohammed on 12/21/20.
//

import Foundation
import Moya
import Promises
func injectFrameAPI() -> FrameAPI{return FrameAPIImpl()}
protocol FrameAPI {
  func upload(photoData: Data, filename: String) -> Promise<Void>
  func retrieveThumbnails() -> Promise<[URL]>
  func removePhoto(filename: String) -> Promise<Void>
  func retrievePIPrefrences() -> Promise<[String : Any]>
  func updatePI(preferences: [String : Any]) -> Promise<Void>
}
class FrameAPIImpl: FrameAPI {
  
  func retrievePIPrefrences() -> Promise<[String : Any]> {
    let promise = Promise<[String : Any]>.pending()
    /// get the current PI preferencses as a dictionary
    self.photoProvider.request(.retrievePIPreferences) { (result) in
      switch result {
        case .success(let response):
          do {
            /// trying to Serialize the response
            let responseSerialized = try JSONSerialization.jsonObject(
              with: response.data,
              options: .mutableLeaves)
            /// casting the serialized response (responseSerialized) as a dictionary
            if let prefrencesDict = responseSerialized as? Dictionary<String,Any> {
              /// fulfiling the promis with the reterieved dictionary
              promise.fulfill(prefrencesDict)
            }
          } catch {
            print(error)
          }
        case .failure(let error):
          /// reject if there was any error
          promise.reject(error)
      }
    }
    return promise
  }
  
  func updatePI(preferences: [String : Any]) -> Promise<Void> {
    let promise = Promise<Void>.pending()
    /// updating the PI preferencses by sending a dictionary of the updated preferencses
    self.photoProvider.request(.updatePI(preferences: preferences)) { (result) in
      switch result {
        case .success(let response):
          print(response , "Success")
          promise.fulfill(())
        case .failure(let error):
          promise.reject(error)
      }
    }
    return promise
  }
  func removePhoto(filename: String) -> Promise<Void> {
    let promise = Promise<Void>.pending()
    /// requesting to remove photo with filename
    self.photoProvider.request(.removePhoto(filename: filename)) { (result) in
      switch result {
        case .success(let reponse):
          print(reponse , "Success")
          promise.fulfill(())
        case .failure(let error):
          /// reject if there was an error , like no such file name
          promise.reject(error)
      }
    }
    return promise
  }
  
  func retrieveThumbnails() -> Promise<[URL]> {
    let promise = Promise<[URL]>.pending()
    /// requesting the thumbnails of all the photos on the PI or Mac
    /// result will be the URL of the thumbnail
    photoProvider.request(.retrieveThumbnails) { (result) in
      switch result {
        case .success(let response):
          do {
            /// trying to Serialize the response
            let responseSerialized = try JSONSerialization.jsonObject(with: response.data, options: .mutableLeaves)
            /// casting the serilized response (responseSerialized) as an array of Strings
            if let urlsAsString = responseSerialized as? Array<String> {
              /// converting the array of String into array of URL
              let URLs = urlsAsString.compactMap(URL.init)
              /// fulfiling the promis with the array of URL
              promise.fulfill(URLs)
            }
          } catch {
            print(error)
          }
        case .failure(let error):
          /// reject if there was an error like there is no photos stored on the PI
          promise.reject(error)
      }
    }
    return promise
  }
  
  private let photoProvider = MoyaProvider<PhotosUpload>()
  
  func upload(photoData: Data, filename: String) -> Promise<Void> {
    let promise = Promise<Void>.pending()
    /// uploading the selected photo to the PI
    self.photoProvider.request(.uploadPhoto(photoData: photoData, nameAndExtension: filename)) { (result) in
      switch result {
        case .success(let reponse):
          print(reponse)
          /// fulfiling the promise when successfuly upload the photo
          promise.fulfill(())
        case .failure(let error):
          /// reject if there was an error
          promise.reject(error)
      }
    }
    return promise
  }
  
}
