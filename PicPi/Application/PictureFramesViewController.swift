//
//  PictureFramesViewController.swift
//  PicPi
//
//  Created by Erick Sanchez on 12/31/20.
//

import UIKit

class PictureFramesViewController: UITableViewController {
  private var pictureFrames = [PictureFrame]()

  private let pictureFrameManager = injectPictureFrameManager()

  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.register(AddPictureFrameTableViewCell.self)
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    reloadPictureFramesSection()
  }

  override func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }

  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    switch section {
    case 0:
      return nil
    case 1:
      return "Picture Frames"
    default:
      assertionFailure("unexpected section: \(section)")
      return nil
    }
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case 0:
      return 1
    case 1:
      return pictureFrames.count
    default:
      assertionFailure("unexpected section: \(section)")
      return 0
    }
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch indexPath.section {
    case 0:
      return tableView.dequeueReusableCell(
        for: indexPath
      ) as AddPictureFrameTableViewCell
    case 1:
      let frame = pictureFrames[indexPath.row]

      let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
      cell.textLabel?.text = frame.name
      cell.accessoryType = .disclosureIndicator

      return cell
    default:
      assertionFailure("unexpected index path: \(indexPath)")
      return UITableViewCell()
    }
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    switch indexPath.section {
    case 0:
      let navigator = injectNavigator()
      navigator.presentAddPictureFrameFlow()
    case 1:
      let selectedPictureFrame = pictureFrames[indexPath.row]
      let frameDetailVc = PictureFrameDetailsTabViewController(pictureFrame: selectedPictureFrame)
      navigationController?.pushViewController(frameDetailVc, animated: true)
    default:
      assertionFailure("unexpected index path: \(indexPath)")
    }
  }

  override func tableView(
    _ tableView: UITableView,
    commit editingStyle: UITableViewCell.EditingStyle,
    forRowAt indexPath: IndexPath
  ) {
    switch editingStyle {
    case .delete:
      let frame = pictureFrames[indexPath.row]
      frame.forget().then {
        self.reloadPictureFramesSection()
      }.catch { error in
        let alert = UIAlertController(
          title: "Delete Picture Frame",
          message: "Failed delete frame: \(error.localizedDescription)",
          button: "Dismiss"
        )
        self.present(alert, animated: true)
      }
    default: break
    }
  }

  private func reloadPictureFramesSection() {
    pictureFrameManager.registeredFrames().then { [weak self] frames in
      self?.pictureFrames = frames
      self?.tableView.reloadSections(IndexSet([1]), with: .automatic)
    }
  }
}
