import Combine
import Foundation
import Playgrounds

final class FakeCastEngine {
    let devices = CurrentValueSubject<[CastDevice], Never>([])
    let connection = CurrentValueSubject<ConnectionState, Never>(.disconnected)
    private var ticks: AnyCancellable?
    private var index = 0
    private let lists: [[CastDevice]]

    init(lists: [[CastDevice]]) {
        self.lists = lists
        let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
        ticks = timer.sink { [weak self] _ in
            guard let self else { return }
            let list = self.lists[self.index]
            self.devices.send(list)
            self.connection.send(self.nextConnection(for: list))
            self.index = (self.index + 1) % self.lists.count
        }
    }

    func stop() {
        ticks?.cancel()
        ticks = nil
    }

    private func nextConnection(for list: [CastDevice]) -> ConnectionState {
        switch index {
        case 0:
            return .discovering
        case 1:
            if let device = list.first {
                return .connecting(device)
            }
            return .discovering
        default:
            if let device = list.first {
                return .connected(device)
            }
            return .discovering
        }
    }
}

#Playground {
    let livingRoom = CastDevice(id: "1", name: "Living Room", type: .tv)
    let kitchen = CastDevice(id: "2", name: "Kitchen", type: .tv)
    let engine = FakeCastEngine(lists: [
        [livingRoom],
        [livingRoom, kitchen],
        [kitchen],
    ])
    let names = engine.devices
        .map { list in list.map(\.name) }
        .filter { found in !found.isEmpty }
        .removeDuplicates()
        .sink { found in
            print(found)
        }
    let states = engine.connection.sink { state in
        print(state)
    }

    try await Task.sleep(for: .seconds(3))
    engine.stop()
    try await Task.sleep(for: .seconds(2))
    _ = names
    _ = states
}
