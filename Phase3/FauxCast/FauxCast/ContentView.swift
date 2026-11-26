import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = HomeViewModel()
    @State private var showPicker = false

    var body: some View {
        VStack(spacing: 16) {
            Text(viewModel.media.title)
                .font(.largeTitle.bold())
            Text(viewModel.media.subtitle)
                .foregroundStyle(.secondary)

            Text(viewModel.status)
                .padding(.top, 24)

            Button("Cast", systemImage: "tv") {
                showPicker = true
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .sheet(isPresented: $showPicker) {
            DevicePickerView(viewModel: viewModel)
        }
    }
}

#Preview {
    ContentView()
}