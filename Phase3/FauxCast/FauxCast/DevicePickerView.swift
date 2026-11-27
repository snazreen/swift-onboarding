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
                            viewModel.connect(to: device)
                            dismiss()
                        } label: {
                            HStack {
                                Label(device.name, systemImage: device.type == .tv ? "tv" : "cable.connector")
                                Spacer()
                                if viewModel.connectedDevice == device {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Cast to…")
            .toolbarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                if viewModel.connectedDevice != nil {
                    ToolbarItem(placement: .primaryAction) {
                        Button("Stop casting", role: .destructive) {
                            viewModel.disconnect()
                            dismiss()
                        }
                    }
                }
            }
        }
        .frame(minWidth: 320, minHeight: 280)
        .onAppear { viewModel.startDiscovery() }
        .onDisappear { viewModel.stopDiscovery() }
    }
}
