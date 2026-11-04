import SwiftUI
import Playgrounds

struct ContentView: View {
    @Environment(\.scenePhase) private var scenePhase
    @State private var tick = 0

    var body: some View {
        Text("Hello, World!!")
            .padding()
            .task {
                while !Task.isCancelled {
                    try? await Task.sleep(for: .seconds(1))
                    tick += 1
                    print("tick \(tick)")
                }
            }
            .onChange(of: scenePhase) { _, phase in
                switch phase {
                case .active:
                    print("active: controls work")
                case .inactive:
                    print("inactive: touches are paused")
                case .background:
                    print("background: ticks pause, the TV session can keep playing")
                @unknown default:
                    break
                }
            }
    }
}

#Preview {
    ContentView()
}

#Playground {
    _ = 1 + 2
}
