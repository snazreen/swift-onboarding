import SwiftUI

struct DevicePickerView: View {
    @ObservedObject var viewModel: HomeViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.devices.isEmpty {
                    ContentUnavailableView(
                        "Searching for devices…",
                        systemImage: "antenna.radiowaves.left.and.right"
                    )
                } else {
                    List(viewModel.devices) { device in
                        Button {
                            Task { await viewModel.connect(to: device) }
                            dismiss()
                        } label: {
                            Label(device.name, systemImage: device.type == .tv ? "tv" : "cable.connector")
                        }
                    }
                }
            }
            .navigationTitle("Cast to…")
            .toolbar {
                Button("Cancel") { dismiss() }
            }
        }
        .frame(minWidth: 320, minHeight: 280)
        .task { await viewModel.startDiscovery() }
    }
}