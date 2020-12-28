//
//  FrameAPIImpl.swift
//  PicPi
//
//  Created by Mustafa T. Mohammed on 12/25/20.
//

import Foundation
import Moya
import Promises

enum FrameAPIErrors: Error {
  case dataMalformed
}

class FrameAPIImpl: FrameAPI {
 
  private lazy var encoder = JSONEncoder()
  private lazy var decoder = JSONDecoder()
  private let photoProvider = MoyaProvider<PhotosUpload>()

  func retrievePIPrefrences() -> Promise<PictureFramePreferences> {
    let promise = Promise<PictureFramePreferences>.pending()
    /// get the current PI preferencses as a dictionary
    self.photoProvider.request(.retrievePIPreferences) { [weak self](result) in
      guard let self = self else {return}
      switch result {
        case .success(let response):
          do {
            /// trying to Serialize the response
              let pictureFramePreferences =  try self.decoder.decode(
                    PictureFramePreferences.self,
                    from: response.data)
            /// casting the serialized response (responseSerialized) as a dictionary
               /// fulfiling the promis with the reterieved dictionary
              promise.fulfill(pictureFramePreferences)
             
          } catch {
            promise.reject(error)
            print(error)
          }
        case .failure(let error):
          /// reject if there was any error
          promise.reject(error)
      }
    }
    return promise
  }
  
  func updatePI(preferences: PictureFramePreferences) -> Promise<Void> {
    let promise = Promise<Void>.pending()
    /// updating the PI preferencses by sending a dictionary of the updated preferencses
    self.photoProvider.request(
      .updatePI(preferences: preferences)) { (result) in
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
            let responseSerialized = try JSONSerialization.jsonObject(
              with: response.data,
              options: .mutableLeaves)
            /// casting the serilized response (responseSerialized) as an array of Strings
            if let urlsAsString = responseSerialized as? Array<String> {
              /// converting the array of String into array of URL
              let URLs = urlsAsString.compactMap(URL.init)
              /// fulfiling the promis with the array of URL
              promise.fulfill(URLs)
            }else {
              promise.reject(FrameAPIErrors.dataMalformed)
            }
          } catch {
            promise.reject(error)
            print(error)
          }
        case .failure(let error):
          /// reject if there was an error like there is no photos stored on the PI
          promise.reject(error)
      }
    }
    return promise
  }

  func upload(photoData: Data, filename: String) -> Promise<Void> {
    let promise = Promise<Void>.pending()
    /// uploading the selected photo to the PI
    self.photoProvider.request(
      .uploadPhoto(photoData: photoData,
                   nameAndExtension: filename)) { (result) in
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
