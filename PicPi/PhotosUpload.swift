//
//  photosUpload.swift
//  PicPi
//
//  Created by Mustafa T. Mohammed on 12/16/20.
//

import Foundation
import Moya

/// photosUpload endpoint
enum PhotosUpload {
  ///enter nameAndExtension as one entry because when using PHAsset will return full file name with extension 
  case uploadPhoto(photoData: Data , nameAndExtension: String)
}

extension PhotosUpload: TargetType {
  var baseURL: URL {
    ///Pi IP hard coded for now
     return URL(string: "http://192.168.0.5:3000")!
  }
  /// path for the specified operation (e.g. : upload photo , delete photo...)
  var path: String {
    switch self {
      case .uploadPhoto:
        return"/photos/upload"
    }
  }
  /// http method for the specified operation
  var method: Moya.Method {
    switch self {
      case .uploadPhoto:
        return .post
    }
  }
  /// sample data for testing Moya
  var sampleData: Data {
    return Data()
  }
  /// task like upload, download...
  var task: Moya.Task {
    switch self {
      case .uploadPhoto(let image, let photoNameAndExtension):
        let imageData = image
        let formData: [Moya.MultipartFormData] =
          [
             Moya.MultipartFormData(
              provider: .data(imageData),
              name: "photos",
              fileName:  photoNameAndExtension ,
              mimeType: "image/png")  
          ]
        
        return .uploadMultipart(formData)
    }
  }
  /// additional headers if needed
  var headers: [String : String]? {
    return nil
  }
  
}
