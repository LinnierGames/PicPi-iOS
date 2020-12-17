//
//  photosUpload.swift
//  PicPi
//
//  Created by Mustafa T. Mohammed on 12/16/20.
//

import Foundation
import Moya

enum photosUpload {
  case uploadPhoto(_ imageData: Data ,_ name: String,_ extension: String)
//  case connectedPi(_ ip: String)
}

extension photosUpload: TargetType {
  var baseURL: URL {
    //    switch self {
    //      case .connectedPi(let ip):
    //      print(ip)
    //        return URL(string: "http://\(ip)")!
    //
    //      case .uploadPhoto(_, _, _):
    //        print("Done!")
    //    }
    return URL(string: "http://192.168.0.161:3000")!
  }
  
  var path: String {
    switch self {
      case .uploadPhoto(_, _, _):
        return"/photos/upload"
    }
  }
  
  var method: Moya.Method {
    switch self {
      case .uploadPhoto(_, _, _):
        return .post
      }
  }
  
  var sampleData: Data {
    return Data()
  }
  
  var task: Task {
    switch self {
      case .uploadPhoto(let image , let photoName, let photoExtension):
        let imageData = image
        let formData: [Moya.MultipartFormData] =
          [
            Moya.MultipartFormData(provider: .data(imageData),
                                   name: "photos",
                                   fileName: "\(photoName).\(photoExtension)",
                                   mimeType: "image/png")
          ]
 
        return .uploadMultipart(formData)
    
    }
  }
  
  var headers: [String : String]? {
    return nil
  }
  
  
}
