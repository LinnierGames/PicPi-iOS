//
//  PictureFramePreferencesViewController.swift
//  PicPi
//
//  Created by Erick Sanchez on 1/14/21.
//

import UIKit
import SwiftUI

class PictureFramePreferencesViewController: UIHostingController<PictureFramePreferencesView> {
  init(pictureFrame: PictureFrame) {
    super.init(rootView: PictureFramePreferencesView(pictureFrame: pictureFrame))
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Preferences"
  }
}

struct PictureFramePreferencesView: View {
  let pictureFrame: PictureFrame

  private enum Orientation: CaseIterable {
    case portrait
    case landscape

    var localized: String {
      switch self {
      case .portrait:
        return "Portrait"
      case .landscape:
        return "Landscape"
      }
    }
  }

  private enum Duration: CaseIterable {
    case portrait
    case landscape

    var localized: String {
      switch self {
      case .portrait:
        return "Portrait"
      case .landscape:
        return "Landscape"
      }
    }
  }

  private static let slideshowDurations = [
    1, 5, 10, 60,
    2 * 60, 5 * 60, 10 * 60, 25 * 60, 60 * 60,
    2 * 3600, 3 * 3600, 4 * 3600, 8 * 3600,
  ]

  @State private var preferences: PictureFramePreferences? = nil
  @State private var error: Error? = nil
  @State private var orientation: Orientation = .portrait
  @State private var pendingChanges = false
  @State private var duration: Int = 1

  var body: some View {
    if let error = error {
      Text(error.localizedDescription)
    } else if let preferences = self.preferences {
      VStack {
        HStack {
          Text("Name")
            .font(.caption)
          Spacer()
        }
        Divider()
        VStack {
          Text(preferences.name ?? "Unnamed frame")
          Divider()
        }
        VStack {
          HStack {
            Text("Slideshow")
              .font(.caption)
            Spacer()
          }
          HStack {
            Text("Duration (in seconds)")
            Spacer()
            Picker(selection: $duration, label: Text("")) {
              ForEach(Self.slideshowDurations, id: \.self) { duration in
                Text(String(duration)).tag(duration)
              }
            }
            .frame(width: 96, height: 32)
            .clipShape(Rectangle())
          }
          Divider()
        }
        VStack {
          HStack {
            Text("Orientation")
              .font(.caption)
            Spacer()
          }
          Picker(selection: $orientation, label: Text("")) {
            ForEach(Orientation.allCases, id: \.self) { mode in
              Text(mode.localized).tag(mode)
            }
          }.pickerStyle(SegmentedPickerStyle())
          Divider()
        }
        Button("Forget Frame", action: pressForgetFrame)
        Spacer()
      }
      .padding()
      .navigationBarItems(
        trailing: Button("Save", action: pressSave).disabled(!pendingChanges)
      )

      .onChange(of: duration, perform: saveDuration)
      .onAppear {
        self.duration = preferences.slideshowDuration.map(Int.init).map { $0 / 1_000 } ?? 1
      }
    } else {
      Text(pictureFrame.name)
      Text("Loading")
        .onAppear(perform: loadPreferences)
    }
  }

  private func loadPreferences() {
    pictureFrame.preferences().then { preferences in
      self.preferences = preferences
    }.catch { error in
      self.error = error
    }
  }

  private func pressForgetFrame() {

  }

  private func pressSave() {

  }

  private func saveDuration(newValue: Int) {
    pictureFrame.set(
      preferences: PictureFramePreferences(slideshowDuration: TimeInterval(newValue * 1_000))
    ).then {
      self.preferences = nil
    }.catch { error in
      self.error = error
    }
  }
}
