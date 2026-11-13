import Combine
import Foundation
import Playgrounds

actor DeviceRegistry {
    private var names: [String] = []

    func add(_ name: String) {
        names.append(name)
    }

    func all() -> [String] {
        names
    }
}

protocol RoomLabel {
    func label() -> String
}

struct Television: RoomLabel {
    func label() -> String { "Living Room" }
}

struct StreamingStick: RoomLabel {
    func label() -> String { "Kitchen" }
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

    /* let rapid = PassthroughSubject<[String], Never>()
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
    _ = states */

    /* let names = AsyncStream<[String]> { continuation in
        continuation.yield(["Living Room"])
        continuation.yield(["Living Room", "Kitchen"])
        continuation.yield(["Kitchen"])
        continuation.finish()
    }

    for await list in names {
        print(list)
    } */

    /* let names = AsyncStream<[String]> { continuation in
        let task = Task {
            continuation.yield(["Living Room"])
            try await Task.sleep(for: .seconds(1))
            continuation.yield(["Living Room", "Kitchen"])
            try await Task.sleep(for: .seconds(1))
            continuation.yield(["Kitchen"])
            try await Task.sleep(for: .seconds(1))
            continuation.yield(["Bedroom"])
            continuation.finish()
        }
        continuation.onTermination = { _ in
            task.cancel()
            print("stopped")
        }
    }

    var seen = 0
    for await list in names {
        print(list)
        seen += 1
        if seen == 2 {
            break
        }
    } */

    let group = DispatchGroup()
    let queue = DispatchQueue.global()

    queue.async(group: group) {
        print("found Living Room")
    }
    queue.async(group: group) {
        print("found Kitchen")
    }
    // group.wait()
    print("discovery finished")

    let found = await withTaskGroup(of: String.self) { group in
        group.addTask { "Living Room" }
        group.addTask { "Kitchen" }
        var names: [String] = []
        for await name in group {
            names.append(name)
        }
        return names
    }
    print(found)

    let inherited = await Task {
        "inherited main: \(Thread.isMainThread)"
    }.value

    let detached = await Task.detached {
        "detached main: \(Thread.isMainThread)"
    }.value

    print(inherited)
    print(detached)

    let registry = DeviceRegistry()
    await registry.add("Living Room")
    await registry.add("Kitchen")
    print(await registry.all())

    let rooms: [any RoomLabel] = [Television(), StreamingStick()]
    for room in rooms {
        print(room.label())
    }

    /* let discovery = DispatchQueue(label: "cast.discovery")
    discovery.async {
        print("started")
        discovery.sync {
            print("never prints")
        }
        print("finished")
    }
    try await Task.sleep(for: .seconds(1)) */

    let subject = CurrentValueSubject<String, Never>("Living Room")
    let publisher: AnyPublisher<String, Never> = subject.eraseToAnyPublisher()
    let subscription = publisher.sink { name in
        print(name)
    }
    subject.send("Kitchen")
    _ = subscription

    func load(completion: (String) -> Void) {
        completion("Living Room")
    }

    func loadLater(completion: @escaping (String) -> Void) {
        DispatchQueue.global().async {
            completion("Kitchen")
        }
    }

    load { name in
        print(name)
    }
    loadLater { name in
        print(name)
    }
    try await Task.sleep(for: .milliseconds(200))

    func connect(to name: @autoclosure () -> String) {
        print(name())
    }

    connect(to: "Living Room")

    let address = URL(string: "https://jsonplaceholder.typicode.com/posts/1")!
    let (data, response) = try await URLSession.shared.data(from: address)
    let status = (response as? HTTPURLResponse)?.statusCode ?? 0
    print(status)
    print(String(data: data, encoding: .utf8) ?? "")

}
