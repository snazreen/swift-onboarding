import Combine
import Foundation

final class HomeViewModel: ObservableObject {
    static let livingRoom = CastDevice(id: "1", name: "Living Room", type: .tv)
    static let kitchen = CastDevice(id: "2", name: "Kitchen", type: .dongle)
    static let demoLists: [[CastDevice]] = [
        [livingRoom, kitchen],
    ]

    @Published private(set) var devices: [CastDevice] = []
    @Published private(set) var state: ConnectionState = .disconnected
    @Published private(set) var movies: [Movie] = []
    @Published private(set) var playingMovie: Movie?
    private let engine: FakeCastEngine

    init(engine: FakeCastEngine = FakeCastEngine(lists: HomeViewModel.demoLists)) {
        self.engine = engine
        engine.devices.assign(to: &$devices)
        engine.connection.assign(to: &$state)
    }

    var connectedDevice: CastDevice? {
        if case .connected(let device) = state { return device }
        return nil
    }

    func loadMovies() async {
        do {
            movies = try await TMDB.trending()
        } catch {
            print(error)
        }
    }

    func play(_ movie: Movie) {
        guard connectedDevice != nil else { return }
        playingMovie = movie
    }

    func startDiscovery() { engine.startDiscovery() }
    func stopDiscovery() { engine.stopDiscovery() }

    func connect(to device: CastDevice) {
        playingMovie = nil
        engine.connect(to: device)
    }

    func disconnect() {
        playingMovie = nil
        engine.disconnect()
    }
}
