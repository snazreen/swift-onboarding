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

    // Just is a publisher that sends one value and then finishes.
    /* let devices = Just([
        CastDevice(id: "1", name: "Living Room", type: .tv)
    ])

    let subscription = devices.sink { list in
        print(list)
    }
    _ = subscription */

    // PassthroughSubject is a publisher that sends values to its subscribers.

    /* let devices = PassthroughSubject<[CastDevice], Never>()
    let subscription = devices.sink { list in
        print(list.count)
    }
    devices.send([
        CastDevice(id: "1", name: "Living Room", type: .tv)
    ])
    devices.send([
        CastDevice(id: "1", name: "Living Room", type: .tv),
        CastDevice(id: "2", name: "Kitchen", type: .tv)
    ])
    _ = subscription */

    /* let devices = CurrentValueSubject<[CastDevice], Never>([])

    let subscription = devices.sink { list in
        print(list.count)
    }

    devices.send([
        CastDevice(id: "1", name: "Living Room", type: .tv)
    ])
    _ = subscription */

    // CurrentValueSubject is a publisher that sends the latest value to its subscribers.

    /* let devices = CurrentValueSubject<[CastDevice], Never>([])

    let subscription = devices
        .map { list in
            list.map(\.name)
        }
        .sink { names in
            print(names)
        }

    let subscription =
        devices
        .map { list in
            list.map(\.name)
        }
        .filter { names in
            !names.isEmpty
        }
        .removeDuplicates()
        .sink { names in
            print(names)
        }

    devices.send([
        CastDevice(id: "1", name: "Living Room", type: .tv)
    ])
    devices.send([
        CastDevice(id: "1", name: "Living Room", type: .tv)
    ])
    _ = subscription */

    /* let livingRoom = CastDevice(id: "1", name: "Living Room", type: .tv)
    let kitchen = CastDevice(id: "2", name: "Kitchen", type: .tv)
    let lists: [[CastDevice]] = [
        [livingRoom],
        [livingRoom, kitchen],
        [kitchen],
    ]
    var index = 0

    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    let ticks = timer.sink { _ in
        devices.send(lists[index])
        index = (index + 1) % lists.count
    }
    try await Task.sleep(for: .seconds(4))
    _ = ticks */

    /* let livingRoom = CastDevice(id: "1", name: "Living Room", type: .tv)
    let kitchen = CastDevice(id: "2", name: "Kitchen", type: .tv)
    let engine = FakeCastEngine(lists: [
        [livingRoom],
        [livingRoom, kitchen],
        [kitchen],
    ])
    let subscription = engine.devices
        .map { list in list.map(\.name) }
        .filter { names in !names.isEmpty }
        .removeDuplicates()
        .sink { names in
            print(names)
        }

    try await Task.sleep(for: .seconds(3))
    engine.stop()
    try await Task.sleep(for: .seconds(2))
    _ = subscription */

    let rapid = PassthroughSubject<[String], Never>()
    let debounced =
        rapid
        .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
        .sink { names in
            print(names)
        }

    rapid.send(["Living Room"])
    rapid.send(["Living Room", "Kitchen"])
    rapid.send(["Kitchen"])
    try await Task.sleep(for: .seconds(1))
    _ = debounced

    let livingRoom = CastDevice(id: "1", name: "Living Room", type: .tv)
    let engine = FakeCastEngine(lists: [
        [],
        [livingRoom],
        [livingRoom],
    ])
    let states = engine.connection.sink { state in
        print(state)
    }
    try await Task.sleep(for: .seconds(4))
    engine.stop()
    _ = states

}
