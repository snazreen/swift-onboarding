import SwiftUI

struct CastButton: View {
    @ObservedObject var viewModel: HomeViewModel
    @State private var showPicker = false

    var body: some View {
        Button {
            showPicker = true
        } label: {
            Image(systemName: "tv.badge.wifi")
                .symbolVariant(viewModel.connectedDevice == nil ? .none : .fill)
        }
        .tint(viewModel.connectedDevice == nil ? Color.white : Color.blue)
        .sheet(isPresented: $showPicker) {
            DevicePickerView(viewModel: viewModel)
        }
    }
}