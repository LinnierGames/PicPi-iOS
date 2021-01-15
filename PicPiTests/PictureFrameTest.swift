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
    let imageDataLocal = UIImage(named: "AddButton")!.pngData()!
    let filenameLocal =  "String.png"
    let image = MediaProvider.init { () -> Promise<(data: Data, filename: String)> in
      return  Promise((imageDataLocal , filenameLocal))
    }
 
    let expectUpload = expectation(description: "PictureFrame:upload")
    
    frameAPIMock.expectUploadPhotoDataFilename { (imageData, filename) -> Promise<Void> in
      XCTAssertEqual(imageData, imageDataLocal)
      XCTAssertEqual(filename, filenameLocal)
      expectUpload.fulfill()
      
      return Promise(())
    }
     let pictureFrame = PictureFrameImpl(frameAPI: frameAPIMock, ip: ip)
    
     _ = pictureFrame.storeMedia(images: [image])
    
    waitForExpectations(timeout: 5.0)
  }

  func testSetName() {

  }

  func testPreferences() {
    let ip = "255.255.255.255"
    let preferencesLocal = PictureFramePreferences.init(slideshowDuration: 100, connectionPasscode: "", name: "PicPi")
    
    let expectPreferences = expectation(description: "PictureFrame:preferences")
    frameAPIMock.expectRetrievePIPrefrences { () -> Promise<PictureFramePreferences> in
      return Promise(preferencesLocal)
    }
    
    let pictureFrame = PictureFrameImpl(frameAPI: frameAPIMock, ip: ip)
    pictureFrame.preferences().then { (preferences)   in
      XCTAssertEqual(preferences.connectionPasscode, preferencesLocal.connectionPasscode)
      XCTAssertEqual(preferences.name, preferencesLocal.name)
      XCTAssertEqual(preferences.slideshowDuration, preferencesLocal.slideshowDuration)
      expectPreferences.fulfill()
    }
    
    waitForExpectations(timeout: 5.0)
  }

  func testSetPreferences() {

  }

  func testForget() {

  }
}
