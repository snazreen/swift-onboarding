import Combine
import Foundation

final class HomeViewModel: ObservableObject {
    let media = Media(title: "Fight Club", subtitle: "Movie · 1999")
    @Published private(set) var devices: [CastDevice] = []
    @Published private(set) var state: ConnectionState = .disconnected

    var status: String {
        switch state {
        case .disconnected: "Not casting"
        case .discovering: "Searching…"
        case .connecting(let device): "Connecting to \(device.name)…"
        case .connected(let device): "Casting to \(device.name)"
        case .reconnecting: "Reconnecting…"
        case .failed: "Connection failed"
        }
    }

    func startDiscovery() async {
        state = .discovering
        devices = []
        try? await Task.sleep(for: .seconds(2))
        devices = [
            CastDevice(id: "1", name: "Living Room", type: .tv),
            CastDevice(id: "2", name: "Kitchen", type: .dongle),
        ]
    }

    func connect(to device: CastDevice) async {
        state = .connecting(device)
        try? await Task.sleep(for: .seconds(1))
        state = .connected(device)
    }
}