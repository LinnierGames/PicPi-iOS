//
//  AddPhotoUploadSessionViewController.swift
//  PicPi
//
//  Created by Erick Sanchez on 12/29/20.
//

import UIKit

class AddPhotoUploadSessionViewController: UIViewController {
  private let session: MediaUploaderSession
  private let totalImages: Int
  private var finishedUploads = 0
  private var errors = 0

  private let progressLabel = UILabel()
  private let searchButton = customBtnRoundCornerBlueWithShadow(type: .custom)

  init(session: MediaUploaderSession, totalImages: Int) {
    self.session = session
    self.totalImages = totalImages
    super.init(nibName: nil, bundle: nil)
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .white
    title = "Add Photos"
    navigationItem.hidesBackButton = true
    setupProgressLabel()
    setupDoneButton()

    session.didFinishUpload.add(self) { result in
      self.handleProgressUpdate(
        result: result.map { result -> (mediaProvider: MediaProvider, filename: String) in
          (result.payload, result.product)
        }
      )
    }
    session.didCompleteSession.add(self) { [weak self] success in
      guard let self = self else { return }

      let alert = UIAlertController(
        title: "Upload",
        message: success ? "success" : "something went wrong",
        button: "Dismiss"
      )
      self.present(alert, animated: true)

      self.updateUI()
    }
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    updateUI()
  }

  // MARK: - Private

  private func setupProgressLabel() {
    progressLabel.numberOfLines = 0
    progressLabel.textAlignment = .center
    progressLabel.translatesAutoresizingMaskIntoConstraints = false

    view.addSubview(progressLabel)
    NSLayoutConstraint.activate([
      progressLabel.leadingAnchor.constraint(
        equalTo: view.safeAreaLayoutGuide.leadingAnchor,
        constant: Constants.Spacing.medium
      ),
      view.safeAreaLayoutGuide.trailingAnchor.constraint(
        equalTo: progressLabel.trailingAnchor,
        constant: Constants.Spacing.medium
      ),
      progressLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
    ])
  }

  private func setupDoneButton() {
    searchButton.setTitle("Cancel", for: .normal)
    searchButton.addTarget(
      self,
      action: #selector(AddPhotoUploadSessionViewController.pressButton),
      for: .touchUpInside
    )
    searchButton.translatesAutoresizingMaskIntoConstraints = false

    view.addSubview(searchButton)
    NSLayoutConstraint.activate([
      searchButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      searchButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
    ])
  }

  private func handleProgressUpdate(
    result: Result<(payload: MediaProvider, product: String), Error>
  ) {
    switch result {
    case .success:
      finishedUploads += 1
    case .failure(let error):
      print("failed to upload an image: \(error)")
      errors += 1
    }

    updateProgressLabel()
  }

  private func updateUI() {
    updateProgressLabel()
    updateButton()
  }

  private func updateProgressLabel() {
    if session.isCompleted {
      progressLabel.text =
        "Finished uploading \(finishedUploads) images with the following errors: \(errors)"
    } else {
      progressLabel.text =
        """
        Uploading...
        \(finishedUploads) of \(totalImages) finished
        errors: \(errors)
        """
    }
  }

  private func updateButton() {
    self.searchButton.setTitle(session.isCompleted ? "Finish" : "Cancel", for: .normal)
  }

  @objc private func pressButton() {
    if session.isCompleted {
      presentingViewController?.dismiss(animated: true)
    } else {
      // TODO: Cancel session.
    }
  }
}
