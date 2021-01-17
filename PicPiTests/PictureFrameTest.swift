//
//  PictureFrameTest.swift
//  PicPiTests
//
//  Created by Erick Sanchez on 1/14/21.
//

import XCTest
import Promises

@testable import PicPi

class PictureFrameTest: XCTestCase {

  private var frameAPIMock: FrameAPIMock!

  override func setUp() {
    super.setUp()
    frameAPIMock = FrameAPIMock(testCase: self)
  }

  func testContent() {
    let ip = "255.255.255.255"

    let filename = "image.png"
    let thumbnail = URL(string: "image.google.com/image.png?thumbnail=true")!
    let image = URL(string: "image.google.com/image.png")!

    frameAPIMock.expectRetrievePhotosInfo { () -> Promise<[PhotoInfoData]> in
      return Promise([
        PhotoInfoData(filename: filename, thumbnail: thumbnail, image: image)
      ])
    }
    let pictureFrame = PictureFrameImpl(frameAPI: frameAPIMock, ip: ip)

    let expectContent = expectation(description: "PictureFrame:content")
    pictureFrame.content().then { content in
      XCTAssertEqual(content.media.count, 1)
      XCTAssertEqual(content.media[0].filename, filename)
      XCTAssertEqual(content.media[0].thumbnail, thumbnail)
      XCTAssertEqual(content.media[0].fullImage, image)
      expectContent.fulfill()
    }.catch { error in
      XCTFail("unexpected error: \(error)")
    }

    waitForExpectations(timeout: 5.0)
  }

  func testStoreMedia() {
    let ip = "255.255.255.255"
    guard let imageDataLocal = UIImage(named: "AddButton")?.pngData()  else {
      return
    }
    let filenameLocal =  "AddButton.png"
    let image = MediaProvider.init { () -> Promise<(data: Data, filename: String)> in
      return  Promise((imageDataLocal , filenameLocal))
    }
    let expectUpload = expectation(description: "PictureFrame:upload")
    
    frameAPIMock.expectUploadPhotoDataFilename { (imageData, filename) -> Promise<Void> in
      let promise = Promise<Void>.pending()
      
      XCTAssertEqual(imageData, imageDataLocal)
      XCTAssertEqual(filename, filenameLocal)
//    promise.reject(FrameAPIErrors.dataMalformed)
      promise.fulfill(())
      return promise
    }
    let pictureFrame = PictureFrameImpl(frameAPI: frameAPIMock, ip: ip)
    
    let session = pictureFrame.storeMedia(images: [image])
    
    session.didFinishUpload.add(pictureFrame) { (result) in
      checkResult(
        result: result.map { result -> (mediaProvider: MediaProvider, filename: String) in
          (result.payload, result.product)
        }
      )
    }
    func checkResult(
      result: Result<(payload: MediaProvider, product: String), Error>
    ) {
      switch result {
      case .success:
        _ =   result.map { result -> (mediaProvider: MediaProvider, filename: String) in
          XCTAssertTrue(result.payload === image)
          XCTAssertEqual(result.product, filenameLocal)
          ///did not work without expectation "expectUpload"
          expectUpload.fulfill()
          
          return (result.payload , result.product)
        }
       case .failure(let error):
        XCTFail(error.localizedDescription)
      }
      
     }
    waitForExpectations(timeout: 5.0)
  }

  func testSetName() {

  }

  func testPreferences() {
    let ip = "255.255.255.255"
    let preferencesLocal = PictureFramePreferences.init(slideshowDuration: 100, connectionPasscode: "", name: "PicPi")
    
    let expectPreferences = expectation(description: "PictureFrame:preferences")
    frameAPIMock.expectRetrievePIPrefrences { () -> Promise<PictureFramePreferences> in
      let promise = Promise<PictureFramePreferences>.pending()
//    promise.reject(FrameAPIErrors.dataMalformed)
      promise.fulfill(preferencesLocal)
      return promise
    }
    
    let pictureFrame = PictureFrameImpl(frameAPI: frameAPIMock, ip: ip)
    pictureFrame.preferences().then { (preferences)   in
      XCTAssertEqual(preferences.connectionPasscode, preferencesLocal.connectionPasscode)
      XCTAssertEqual(preferences.name, preferencesLocal.name)
      XCTAssertEqual(preferences.slideshowDuration, preferencesLocal.slideshowDuration)
      expectPreferences.fulfill()
    }.catch { (error) in
      XCTFail(error.localizedDescription)
    }
    
    waitForExpectations(timeout: 5.0)
  }

  func testSetPreferences() {
    let ip = "255.255.255.255"
    let preferencesLocal = PictureFramePreferences.init(slideshowDuration: 100, connectionPasscode: "", name: "PicPi")
    
    let expectPreferences = expectation(description: "PictureFrame:preferences set")

    frameAPIMock.expectUpdatePIPreferences { (preferences) -> Promise<Void> in
      let promise = Promise<Void>.pending()
      XCTAssertEqual(preferences.slideshowDuration, preferencesLocal.slideshowDuration)
      XCTAssertEqual(preferences.connectionPasscode, preferencesLocal.connectionPasscode)
      XCTAssertEqual(preferences.name, preferencesLocal.name)
//    promise.reject(FrameAPIErrors.dataMalformed)
      promise.fulfill(())
      return promise
    }
    let pictureFrame = PictureFrameImpl(frameAPI: frameAPIMock, ip: ip)
    pictureFrame.set(preferences: preferencesLocal).then { () -> Promise<Void> in
      let promise = Promise<Void>.pending()
      promise.fulfill(())
      expectPreferences.fulfill()
      return promise
    }.catch { (error) in
      XCTFail(error.localizedDescription)
    }
   
    
    waitForExpectations(timeout: 5.0)
  }

  func testForget() {

  }
}
