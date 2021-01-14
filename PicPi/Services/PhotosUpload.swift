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
    /// retrieve the URLs of all the thumbnails on the PI
    case retrieveThumbnails
    /// remove the specified photo by filename
    case removePhoto(filename: String)
    /// get the current preferences of the PI
    case retrievePIPreferences
    /// update the PI preferences
    case updatePI(preferences: PictureFramePreferences)
}

class PiAPI: TargetType {
    let endpoint: PhotosUpload
    let host: URL
    
    var baseURL: URL {
        /// return the host passed by FrameAPI
        return self.host
    }
    /// path for the specified operation (e.g. : upload photo , delete photo...)
    var path: String {
        switch endpoint {
        case .uploadPhoto:
            return "/photos/upload"
        case .retrieveThumbnails:
            return "/photos"
        case .removePhoto(let filename):
            return "/photos/\(filename)"
        case .retrievePIPreferences, .updatePI:
            return "/preferences"
        }
    }
    /// http method for the specified operation
    var method: Moya.Method {
        switch endpoint {
        case .uploadPhoto:
            return .post
        case .removePhoto:
            return .delete
        case .retrieveThumbnails:
            return .get
        case .retrievePIPreferences:
            return .get
        case .updatePI:
            return .patch
        }
    }
    /// sample data for testing Moya
    var sampleData: Data {
        return Data()
    }
    /// task like upload, download...
    var task: Moya.Task {
        switch endpoint {
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
            
        case .removePhoto:
            return .requestPlain
            
        case .retrieveThumbnails:
            return .requestPlain
            
        case .retrievePIPreferences:
            return .requestPlain
            
        case .updatePI(let preferences):
            /// send a dictionary of the updated preferences
            return .requestJSONEncodable(preferences)
        }
    }
    /// additional headers if needed
    var headers: [String : String]? {
        return nil
    }
    
    init(endpoint: PhotosUpload , host: URL) {
        self.endpoint = endpoint
        self.host = host
    }
}
