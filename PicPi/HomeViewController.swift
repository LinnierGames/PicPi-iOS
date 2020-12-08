//
//  ViewController.swift
//  PicPi
//
//  Created by Erick Sanchez on 12/7/20.
//

import UIKit

class HomeViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.

    view.backgroundColor = .red
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

//    let addSomethingSuperLongAndHeavyToThisVar = AddFrameViewControllerThatIsSuperAwesome(
//      varOne: 123123,
//      varTwo: false,
//      varOne: 123123,
//      varTwo: false,
//      varOne: 123123,
//      varTwo: false,
//      varOne: 123123
//    )
//    present(addFrameVc, animated: true)
  }

  // MARK: - UITableViewDataSource

//  func tableView(
//    _ tableView: UITableView,
//    numberOfRowsInSection section: Int
//  ) -> Int {
//    <#code#>
//  }
//
//  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, moreHere: Bool) -> UITableViewCell {
//    <#code#>
//  }

//  func collectAgenda(for date: Date) -> Promise<Agenda> {
//    self.collectAgenda(for: date).then { agenda in
//
//    }.catch { error in
//
//    }
//  }

  // MARK: - Private

  private func doSomethingPrivately() {

  }
}

//struct PhotoPayload: Codable {
//  let imageData: Data
//  let filename: String
//
//  init(image: UIImage, filename: String) {
//    self.imageData = image.pngData() ?? Data()
//    self.filename = filename
//  }
//}
