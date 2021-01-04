//
//  FrameAPIImpl.swift
//  PicPi
//
//  Created by Mustafa T. Mohammed on 12/25/20.
//

import Foundation
import Moya
import Promises

func injectFrameAPI(host: URL) -> FrameAPI {
    return FrameAPIImpl(host: host)
}

private class FrameAPIImpl: FrameAPI {
    let host: URL
    
    private lazy var encoder = JSONEncoder()
    private lazy var decoder = JSONDecoder()
    private let photoProvider = MoyaProvider<PiAPI>()
    
    init(host: URL) {
        self.host = host
    }
    
    func retrievePIPrefrences() -> Promise<PictureFramePreferences> {
        let promise = Promise<PictureFramePreferences>.pending()
        /// get the current PI preferencses as a dictionary
        self.photoProvider.request( PiAPI.init(endpoint: PhotosUpload.retrievePIPreferences, host: host)) { [weak self](result) in
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
        self.photoProvider.request(PiAPI.init(endpoint: PhotosUpload.updatePI(preferences: preferences), host: host)
        ) { (result) in
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
        self.photoProvider.request(PiAPI.init(endpoint: PhotosUpload.removePhoto(filename: filename), host: host)) { (result) in
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
    
    
    func retrievePhotosInfo() -> Promise<[PhotoInfoData]> {
        let promise = Promise<[PhotoInfoData]>.pending()
        
        /// Requesting the thumbnails of all the photos on the PI or Mac
        photoProvider.request(PiAPI.init(endpoint: PhotosUpload.retrieveThumbnails, host: host)) { (result) in
            switch result {
            case .success(let response):
                do {
                    let decodedBases = try self.decoder.decode(
                        [FailableDecodable<PhotoInfoData>].self,
                        from: response.data
                    )
                    let thumbnails = decodedBases.compactMap { $0.base }
                    promise.fulfill(thumbnails)
                } catch {
                    print(error)
                    promise.reject(error)
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
        self.photoProvider.request(PiAPI.init(endpoint: PhotosUpload.uploadPhoto(photoData: photoData, nameAndExtension: filename), host: host)
        ) { (result) in
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
