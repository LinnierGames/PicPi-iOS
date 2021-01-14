// Generated using Sourcery 1.0.2 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

import XCTest
import Promises
import Photos

@testable import PicPi

// MARK: - FrameAPI
class FrameAPIMock: FrameAPI {

  private let testCase: XCTestCase

  init(testCase: XCTestCase) {
    self.testCase = testCase
  }

  // MARK: upload(photoData: Data, filename: String)

  private var expectationForUploadPhotoDataFilename: XCTestExpectation?
  private var expectUploadPhotoDataFilenameBlock: (Data, String) throws -> Promise<Void> = { _,_  in
    XCTFail("unexpected call to FrameAPI.upload(photoData:filename:)")
    fatalError()
  }

  @discardableResult
  func expectUploadPhotoDataFilename(_ block: @escaping (Data, String) throws -> Promise<Void>) -> XCTestExpectation {
    self.expectationForUploadPhotoDataFilename = self.testCase.expectation(description: "FrameAPI.upload(photoData:filename:)")
    self.expectUploadPhotoDataFilenameBlock = block
    return self.expectationForUploadPhotoDataFilename!
  }

  func upload(photoData: Data, filename: String) -> Promise<Void> {
    XCTAssertNotNil(self.expectationForUploadPhotoDataFilename)
    self.expectationForUploadPhotoDataFilename?.fulfill()
    do {
      return try self.expectUploadPhotoDataFilenameBlock(photoData, filename)
    } catch {
      XCTFail("unexpecting thrown error: \(error.localizedDescription)")
      fatalError()
    }
  }
  // MARK: retrievePhotosInfo()

  private var expectationForRetrievePhotosInfo: XCTestExpectation?
  private var expectRetrievePhotosInfoBlock: () throws -> Promise<[PhotoInfoData]> = {  
    XCTFail("unexpected call to FrameAPI.retrievePhotosInfo")
    fatalError()
  }

  @discardableResult
  func expectRetrievePhotosInfo(_ block: @escaping () throws -> Promise<[PhotoInfoData]>) -> XCTestExpectation {
    self.expectationForRetrievePhotosInfo = self.testCase.expectation(description: "FrameAPI.retrievePhotosInfo")
    self.expectRetrievePhotosInfoBlock = block
    return self.expectationForRetrievePhotosInfo!
  }

  func retrievePhotosInfo() -> Promise<[PhotoInfoData]> {
    XCTAssertNotNil(self.expectationForRetrievePhotosInfo)
    self.expectationForRetrievePhotosInfo?.fulfill()
    do {
      return try self.expectRetrievePhotosInfoBlock()
    } catch {
      XCTFail("unexpecting thrown error: \(error.localizedDescription)")
      fatalError()
    }
  }
  // MARK: removePhoto(filename: String)

  private var expectationForRemovePhotoFilename: XCTestExpectation?
  private var expectRemovePhotoFilenameBlock: (String) throws -> Promise<Void> = { _  in
    XCTFail("unexpected call to FrameAPI.removePhoto(filename:)")
    fatalError()
  }

  @discardableResult
  func expectRemovePhotoFilename(_ block: @escaping (String) throws -> Promise<Void>) -> XCTestExpectation {
    self.expectationForRemovePhotoFilename = self.testCase.expectation(description: "FrameAPI.removePhoto(filename:)")
    self.expectRemovePhotoFilenameBlock = block
    return self.expectationForRemovePhotoFilename!
  }

  func removePhoto(filename: String) -> Promise<Void> {
    XCTAssertNotNil(self.expectationForRemovePhotoFilename)
    self.expectationForRemovePhotoFilename?.fulfill()
    do {
      return try self.expectRemovePhotoFilenameBlock(filename)
    } catch {
      XCTFail("unexpecting thrown error: \(error.localizedDescription)")
      fatalError()
    }
  }
  // MARK: retrievePIPrefrences()

  private var expectationForRetrievePIPrefrences: XCTestExpectation?
  private var expectRetrievePIPrefrencesBlock: () throws -> Promise<PictureFramePreferences> = {  
    XCTFail("unexpected call to FrameAPI.retrievePIPrefrences")
    fatalError()
  }

  @discardableResult
  func expectRetrievePIPrefrences(_ block: @escaping () throws -> Promise<PictureFramePreferences>) -> XCTestExpectation {
    self.expectationForRetrievePIPrefrences = self.testCase.expectation(description: "FrameAPI.retrievePIPrefrences")
    self.expectRetrievePIPrefrencesBlock = block
    return self.expectationForRetrievePIPrefrences!
  }

  func retrievePIPrefrences() -> Promise<PictureFramePreferences> {
    XCTAssertNotNil(self.expectationForRetrievePIPrefrences)
    self.expectationForRetrievePIPrefrences?.fulfill()
    do {
      return try self.expectRetrievePIPrefrencesBlock()
    } catch {
      XCTFail("unexpecting thrown error: \(error.localizedDescription)")
      fatalError()
    }
  }
  // MARK: updatePI(preferences: PictureFramePreferences)

  private var expectationForUpdatePIPreferences: XCTestExpectation?
  private var expectUpdatePIPreferencesBlock: (PictureFramePreferences) throws -> Promise<Void> = { _  in
    XCTFail("unexpected call to FrameAPI.updatePI(preferences:)")
    fatalError()
  }

  @discardableResult
  func expectUpdatePIPreferences(_ block: @escaping (PictureFramePreferences) throws -> Promise<Void>) -> XCTestExpectation {
    self.expectationForUpdatePIPreferences = self.testCase.expectation(description: "FrameAPI.updatePI(preferences:)")
    self.expectUpdatePIPreferencesBlock = block
    return self.expectationForUpdatePIPreferences!
  }

  func updatePI(preferences: PictureFramePreferences) -> Promise<Void> {
    XCTAssertNotNil(self.expectationForUpdatePIPreferences)
    self.expectationForUpdatePIPreferences?.fulfill()
    do {
      return try self.expectUpdatePIPreferencesBlock(preferences)
    } catch {
      XCTFail("unexpecting thrown error: \(error.localizedDescription)")
      fatalError()
    }
  }
}

// MARK: - MQTTManagerDelegate
class MQTTManagerDelegateMock: MQTTManagerDelegate {

  private let testCase: XCTestCase

  init(testCase: XCTestCase) {
    self.testCase = testCase
  }

  // MARK: manager(_ manager: MQTTManager, didUpdateConnectionStatus isConnected: Bool)

  private var expectationForManagerManagerIsConnected: XCTestExpectation?
  private var expectManagerManagerIsConnectedBlock: (MQTTManager, Bool) throws -> Void = { _,_  in
    XCTFail("unexpected call to MQTTManagerDelegate.manager(_:didUpdateConnectionStatus:)")
    fatalError()
  }

  @discardableResult
  func expectManagerManagerIsConnected(_ block: @escaping (MQTTManager, Bool) throws -> Void) -> XCTestExpectation {
    self.expectationForManagerManagerIsConnected = self.testCase.expectation(description: "MQTTManagerDelegate.manager(_:didUpdateConnectionStatus:)")
    self.expectManagerManagerIsConnectedBlock = block
    return self.expectationForManagerManagerIsConnected!
  }

  func manager(_ manager: MQTTManager, didUpdateConnectionStatus isConnected: Bool) -> Void {
    XCTAssertNotNil(self.expectationForManagerManagerIsConnected)
    self.expectationForManagerManagerIsConnected?.fulfill()
    do {
      return try self.expectManagerManagerIsConnectedBlock(manager, isConnected)
    } catch {
      XCTFail("unexpecting thrown error: \(error.localizedDescription)")
      fatalError()
    }
  }
}

// MARK: - Navigator
class NavigatorMock: Navigator {

  private let testCase: XCTestCase

  init(testCase: XCTestCase) {
    self.testCase = testCase
  }

  // MARK: presentAddPictureFrameFlow()

  private var expectationForPresentAddPictureFrameFlow: XCTestExpectation?
  private var expectPresentAddPictureFrameFlowBlock: () throws -> Void = {  
    XCTFail("unexpected call to Navigator.presentAddPictureFrameFlow")
    fatalError()
  }

  @discardableResult
  func expectPresentAddPictureFrameFlow(_ block: @escaping () throws -> Void) -> XCTestExpectation {
    self.expectationForPresentAddPictureFrameFlow = self.testCase.expectation(description: "Navigator.presentAddPictureFrameFlow")
    self.expectPresentAddPictureFrameFlowBlock = block
    return self.expectationForPresentAddPictureFrameFlow!
  }

  func presentAddPictureFrameFlow() -> Void {
    XCTAssertNotNil(self.expectationForPresentAddPictureFrameFlow)
    self.expectationForPresentAddPictureFrameFlow?.fulfill()
    do {
      return try self.expectPresentAddPictureFrameFlowBlock()
    } catch {
      XCTFail("unexpecting thrown error: \(error.localizedDescription)")
      fatalError()
    }
  }
  // MARK: presentAddPhotoFlow(preselectedAssets: [PHAsset], preselectedFrames: [PictureFrame])

  private var expectationForPresentAddPhotoFlowPreselectedAssetsPreselectedFrames: XCTestExpectation?
  private var expectPresentAddPhotoFlowPreselectedAssetsPreselectedFramesBlock: ([PHAsset], [PictureFrame]) throws -> Void = { _,_  in
    XCTFail("unexpected call to Navigator.presentAddPhotoFlow(preselectedAssets:preselectedFrames:)")
    fatalError()
  }

  @discardableResult
  func expectPresentAddPhotoFlowPreselectedAssetsPreselectedFrames(_ block: @escaping ([PHAsset], [PictureFrame]) throws -> Void) -> XCTestExpectation {
    self.expectationForPresentAddPhotoFlowPreselectedAssetsPreselectedFrames = self.testCase.expectation(description: "Navigator.presentAddPhotoFlow(preselectedAssets:preselectedFrames:)")
    self.expectPresentAddPhotoFlowPreselectedAssetsPreselectedFramesBlock = block
    return self.expectationForPresentAddPhotoFlowPreselectedAssetsPreselectedFrames!
  }

  func presentAddPhotoFlow(preselectedAssets: [PHAsset], preselectedFrames: [PictureFrame]) -> Void {
    XCTAssertNotNil(self.expectationForPresentAddPhotoFlowPreselectedAssetsPreselectedFrames)
    self.expectationForPresentAddPhotoFlowPreselectedAssetsPreselectedFrames?.fulfill()
    do {
      return try self.expectPresentAddPhotoFlowPreselectedAssetsPreselectedFramesBlock(preselectedAssets, preselectedFrames)
    } catch {
      XCTFail("unexpecting thrown error: \(error.localizedDescription)")
      fatalError()
    }
  }
}

// MARK: - Photo
class PhotoMock: Photo {
  var filename: String {
    get { return underlyingFilename }
    set(value) { underlyingFilename = value }
  }
  var underlyingFilename: String!
  var thumbnail: URL {
    get { return underlyingThumbnail }
    set(value) { underlyingThumbnail = value }
  }
  var underlyingThumbnail: URL!
  var fullImage: URL {
    get { return underlyingFullImage }
    set(value) { underlyingFullImage = value }
  }
  var underlyingFullImage: URL!

  private let testCase: XCTestCase

  init(testCase: XCTestCase) {
    self.testCase = testCase
  }

  // MARK: removeFromFrame()

  private var expectationForRemoveFromFrame: XCTestExpectation?
  private var expectRemoveFromFrameBlock: () throws -> Promise<Void> = {  
    XCTFail("unexpected call to Photo.removeFromFrame")
    fatalError()
  }

  @discardableResult
  func expectRemoveFromFrame(_ block: @escaping () throws -> Promise<Void>) -> XCTestExpectation {
    self.expectationForRemoveFromFrame = self.testCase.expectation(description: "Photo.removeFromFrame")
    self.expectRemoveFromFrameBlock = block
    return self.expectationForRemoveFromFrame!
  }

  func removeFromFrame() -> Promise<Void> {
    XCTAssertNotNil(self.expectationForRemoveFromFrame)
    self.expectationForRemoveFromFrame?.fulfill()
    do {
      return try self.expectRemoveFromFrameBlock()
    } catch {
      XCTFail("unexpecting thrown error: \(error.localizedDescription)")
      fatalError()
    }
  }
}

// MARK: - PictureFrame
class PictureFrameMock: PictureFrame {
  var id: String {
    get { return underlyingId }
    set(value) { underlyingId = value }
  }
  var underlyingId: String!
  var name: String {
    get { return underlyingName }
    set(value) { underlyingName = value }
  }
  var underlyingName: String!
  var isConnected: Bool {
    get { return underlyingIsConnected }
    set(value) { underlyingIsConnected = value }
  }
  var underlyingIsConnected: Bool!

  private let testCase: XCTestCase

  init(testCase: XCTestCase) {
    self.testCase = testCase
  }

  // MARK: content()

  private var expectationForContent: XCTestExpectation?
  private var expectContentBlock: () throws -> Promise<PictureFrameContent> = {  
    XCTFail("unexpected call to PictureFrame.content")
    fatalError()
  }

  @discardableResult
  func expectContent(_ block: @escaping () throws -> Promise<PictureFrameContent>) -> XCTestExpectation {
    self.expectationForContent = self.testCase.expectation(description: "PictureFrame.content")
    self.expectContentBlock = block
    return self.expectationForContent!
  }

  func content() -> Promise<PictureFrameContent> {
    XCTAssertNotNil(self.expectationForContent)
    self.expectationForContent?.fulfill()
    do {
      return try self.expectContentBlock()
    } catch {
      XCTFail("unexpecting thrown error: \(error.localizedDescription)")
      fatalError()
    }
  }
  // MARK: storeMedia(images: [MediaProvider])

  private var expectationForStoreMediaImages: XCTestExpectation?
  private var expectStoreMediaImagesBlock: ([MediaProvider]) throws -> MediaUploaderSession = { _  in
    XCTFail("unexpected call to PictureFrame.storeMedia(images:)")
    fatalError()
  }

  @discardableResult
  func expectStoreMediaImages(_ block: @escaping ([MediaProvider]) throws -> MediaUploaderSession) -> XCTestExpectation {
    self.expectationForStoreMediaImages = self.testCase.expectation(description: "PictureFrame.storeMedia(images:)")
    self.expectStoreMediaImagesBlock = block
    return self.expectationForStoreMediaImages!
  }

  func storeMedia(images: [MediaProvider]) -> MediaUploaderSession {
    XCTAssertNotNil(self.expectationForStoreMediaImages)
    self.expectationForStoreMediaImages?.fulfill()
    do {
      return try self.expectStoreMediaImagesBlock(images)
    } catch {
      XCTFail("unexpecting thrown error: \(error.localizedDescription)")
      fatalError()
    }
  }
  // MARK: set(name: String)

  private var expectationForSetName: XCTestExpectation?
  private var expectSetNameBlock: (String) throws -> Promise<Void> = { _  in
    XCTFail("unexpected call to PictureFrame.set(name:)")
    fatalError()
  }

  @discardableResult
  func expectSetName(_ block: @escaping (String) throws -> Promise<Void>) -> XCTestExpectation {
    self.expectationForSetName = self.testCase.expectation(description: "PictureFrame.set(name:)")
    self.expectSetNameBlock = block
    return self.expectationForSetName!
  }

  func set(name: String) -> Promise<Void> {
    XCTAssertNotNil(self.expectationForSetName)
    self.expectationForSetName?.fulfill()
    do {
      return try self.expectSetNameBlock(name)
    } catch {
      XCTFail("unexpecting thrown error: \(error.localizedDescription)")
      fatalError()
    }
  }
  // MARK: preferences()

  private var expectationForPreferences: XCTestExpectation?
  private var expectPreferencesBlock: () throws -> Promise<PictureFramePreferences> = {  
    XCTFail("unexpected call to PictureFrame.preferences")
    fatalError()
  }

  @discardableResult
  func expectPreferences(_ block: @escaping () throws -> Promise<PictureFramePreferences>) -> XCTestExpectation {
    self.expectationForPreferences = self.testCase.expectation(description: "PictureFrame.preferences")
    self.expectPreferencesBlock = block
    return self.expectationForPreferences!
  }

  func preferences() -> Promise<PictureFramePreferences> {
    XCTAssertNotNil(self.expectationForPreferences)
    self.expectationForPreferences?.fulfill()
    do {
      return try self.expectPreferencesBlock()
    } catch {
      XCTFail("unexpecting thrown error: \(error.localizedDescription)")
      fatalError()
    }
  }
  // MARK: set(preferences: PictureFramePreferences)

  private var expectationForSetPreferences: XCTestExpectation?
  private var expectSetPreferencesBlock: (PictureFramePreferences) throws -> Promise<Void> = { _  in
    XCTFail("unexpected call to PictureFrame.set(preferences:)")
    fatalError()
  }

  @discardableResult
  func expectSetPreferences(_ block: @escaping (PictureFramePreferences) throws -> Promise<Void>) -> XCTestExpectation {
    self.expectationForSetPreferences = self.testCase.expectation(description: "PictureFrame.set(preferences:)")
    self.expectSetPreferencesBlock = block
    return self.expectationForSetPreferences!
  }

  func set(preferences: PictureFramePreferences) -> Promise<Void> {
    XCTAssertNotNil(self.expectationForSetPreferences)
    self.expectationForSetPreferences?.fulfill()
    do {
      return try self.expectSetPreferencesBlock(preferences)
    } catch {
      XCTFail("unexpecting thrown error: \(error.localizedDescription)")
      fatalError()
    }
  }
  // MARK: forget()

  private var expectationForForget: XCTestExpectation?
  private var expectForgetBlock: () throws -> Promise<Void> = {  
    XCTFail("unexpected call to PictureFrame.forget")
    fatalError()
  }

  @discardableResult
  func expectForget(_ block: @escaping () throws -> Promise<Void>) -> XCTestExpectation {
    self.expectationForForget = self.testCase.expectation(description: "PictureFrame.forget")
    self.expectForgetBlock = block
    return self.expectationForForget!
  }

  func forget() -> Promise<Void> {
    XCTAssertNotNil(self.expectationForForget)
    self.expectationForForget?.fulfill()
    do {
      return try self.expectForgetBlock()
    } catch {
      XCTFail("unexpecting thrown error: \(error.localizedDescription)")
      fatalError()
    }
  }
}

// MARK: - PictureFrameContent
class PictureFrameContentMock: PictureFrameContent {
  var didUpdate: Event<Void> {
    get { return underlyingDidUpdate }
    set(value) { underlyingDidUpdate = value }
  }
  var underlyingDidUpdate: Event<Void>!
  var media: [Photo] = []

  private let testCase: XCTestCase

  init(testCase: XCTestCase) {
    self.testCase = testCase
  }

  // MARK: expand()

  private var expectationForExpand: XCTestExpectation?
  private var expectExpandBlock: () throws -> Promise<Void> = {  
    XCTFail("unexpected call to PictureFrameContent.expand")
    fatalError()
  }

  @discardableResult
  func expectExpand(_ block: @escaping () throws -> Promise<Void>) -> XCTestExpectation {
    self.expectationForExpand = self.testCase.expectation(description: "PictureFrameContent.expand")
    self.expectExpandBlock = block
    return self.expectationForExpand!
  }

  func expand() -> Promise<Void> {
    XCTAssertNotNil(self.expectationForExpand)
    self.expectationForExpand?.fulfill()
    do {
      return try self.expectExpandBlock()
    } catch {
      XCTFail("unexpecting thrown error: \(error.localizedDescription)")
      fatalError()
    }
  }
}

// MARK: - PictureFrameManager
class PictureFrameManagerMock: PictureFrameManager {

  private let testCase: XCTestCase

  init(testCase: XCTestCase) {
    self.testCase = testCase
  }

  // MARK: searchForFrames()

  private var expectationForSearchForFrames: XCTestExpectation?
  private var expectSearchForFramesBlock: () throws -> Promise<[UnregisteredPictureFrame]> = {  
    XCTFail("unexpected call to PictureFrameManager.searchForFrames")
    fatalError()
  }

  @discardableResult
  func expectSearchForFrames(_ block: @escaping () throws -> Promise<[UnregisteredPictureFrame]>) -> XCTestExpectation {
    self.expectationForSearchForFrames = self.testCase.expectation(description: "PictureFrameManager.searchForFrames")
    self.expectSearchForFramesBlock = block
    return self.expectationForSearchForFrames!
  }

  func searchForFrames() -> Promise<[UnregisteredPictureFrame]> {
    XCTAssertNotNil(self.expectationForSearchForFrames)
    self.expectationForSearchForFrames?.fulfill()
    do {
      return try self.expectSearchForFramesBlock()
    } catch {
      XCTFail("unexpecting thrown error: \(error.localizedDescription)")
      fatalError()
    }
  }
  // MARK: registeredFrames()

  private var expectationForRegisteredFrames: XCTestExpectation?
  private var expectRegisteredFramesBlock: () throws -> Promise<[PictureFrame]> = {  
    XCTFail("unexpected call to PictureFrameManager.registeredFrames")
    fatalError()
  }

  @discardableResult
  func expectRegisteredFrames(_ block: @escaping () throws -> Promise<[PictureFrame]>) -> XCTestExpectation {
    self.expectationForRegisteredFrames = self.testCase.expectation(description: "PictureFrameManager.registeredFrames")
    self.expectRegisteredFramesBlock = block
    return self.expectationForRegisteredFrames!
  }

  func registeredFrames() -> Promise<[PictureFrame]> {
    XCTAssertNotNil(self.expectationForRegisteredFrames)
    self.expectationForRegisteredFrames?.fulfill()
    do {
      return try self.expectRegisteredFramesBlock()
    } catch {
      XCTFail("unexpecting thrown error: \(error.localizedDescription)")
      fatalError()
    }
  }
}

// MARK: - UnregisteredPictureFrame
class UnregisteredPictureFrameMock: UnregisteredPictureFrame {
  var name: String {
    get { return underlyingName }
    set(value) { underlyingName = value }
  }
  var underlyingName: String!

  private let testCase: XCTestCase

  init(testCase: XCTestCase) {
    self.testCase = testCase
  }

  // MARK: connect()

  private var expectationForConnect: XCTestExpectation?
  private var expectConnectBlock: () throws -> Promise<Void> = {  
    XCTFail("unexpected call to UnregisteredPictureFrame.connect")
    fatalError()
  }

  @discardableResult
  func expectConnect(_ block: @escaping () throws -> Promise<Void>) -> XCTestExpectation {
    self.expectationForConnect = self.testCase.expectation(description: "UnregisteredPictureFrame.connect")
    self.expectConnectBlock = block
    return self.expectationForConnect!
  }

  func connect() -> Promise<Void> {
    XCTAssertNotNil(self.expectationForConnect)
    self.expectationForConnect?.fulfill()
    do {
      return try self.expectConnectBlock()
    } catch {
      XCTFail("unexpecting thrown error: \(error.localizedDescription)")
      fatalError()
    }
  }
}

// MARK: - UserPreferences
class UserPreferencesMock: UserPreferences {

  private let testCase: XCTestCase

  init(testCase: XCTestCase) {
    self.testCase = testCase
  }

  // MARK: add(ipAddress: String)

  private var expectationForAddIpAddress: XCTestExpectation?
  private var expectAddIpAddressBlock: (String) throws -> Void = { _  in
    XCTFail("unexpected call to UserPreferences.add(ipAddress:)")
    fatalError()
  }

  @discardableResult
  func expectAddIpAddress(_ block: @escaping (String) throws -> Void) -> XCTestExpectation {
    self.expectationForAddIpAddress = self.testCase.expectation(description: "UserPreferences.add(ipAddress:)")
    self.expectAddIpAddressBlock = block
    return self.expectationForAddIpAddress!
  }

  func add(ipAddress: String) -> Void {
    XCTAssertNotNil(self.expectationForAddIpAddress)
    self.expectationForAddIpAddress?.fulfill()
    do {
      return try self.expectAddIpAddressBlock(ipAddress)
    } catch {
      XCTFail("unexpecting thrown error: \(error.localizedDescription)")
      fatalError()
    }
  }
  // MARK: remove(ipAddress: String)

  private var expectationForRemoveIpAddress: XCTestExpectation?
  private var expectRemoveIpAddressBlock: (String) throws -> Void = { _  in
    XCTFail("unexpected call to UserPreferences.remove(ipAddress:)")
    fatalError()
  }

  @discardableResult
  func expectRemoveIpAddress(_ block: @escaping (String) throws -> Void) -> XCTestExpectation {
    self.expectationForRemoveIpAddress = self.testCase.expectation(description: "UserPreferences.remove(ipAddress:)")
    self.expectRemoveIpAddressBlock = block
    return self.expectationForRemoveIpAddress!
  }

  func remove(ipAddress: String) -> Void {
    XCTAssertNotNil(self.expectationForRemoveIpAddress)
    self.expectationForRemoveIpAddress?.fulfill()
    do {
      return try self.expectRemoveIpAddressBlock(ipAddress)
    } catch {
      XCTFail("unexpecting thrown error: \(error.localizedDescription)")
      fatalError()
    }
  }
  // MARK: ipAddresses()

  private var expectationForIpAddresses: XCTestExpectation?
  private var expectIpAddressesBlock: () throws -> [String] = {  
    XCTFail("unexpected call to UserPreferences.ipAddresses")
    fatalError()
  }

  @discardableResult
  func expectIpAddresses(_ block: @escaping () throws -> [String]) -> XCTestExpectation {
    self.expectationForIpAddresses = self.testCase.expectation(description: "UserPreferences.ipAddresses")
    self.expectIpAddressesBlock = block
    return self.expectationForIpAddresses!
  }

  func ipAddresses() -> [String] {
    XCTAssertNotNil(self.expectationForIpAddresses)
    self.expectationForIpAddresses?.fulfill()
    do {
      return try self.expectIpAddressesBlock()
    } catch {
      XCTFail("unexpecting thrown error: \(error.localizedDescription)")
      fatalError()
    }
  }
}

