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

  }

  func testSetName() {

  }

  func testPreferences() {

  }

  func testSetPreferences() {

  }

  func testForget() {

  }
}
