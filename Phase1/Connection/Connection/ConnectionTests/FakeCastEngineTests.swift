import Combine
import Testing

@testable import Connection

@MainActor
struct FakeCastEngineTests {

    @Test func discoveryFindsTheFirstDevice() async throws {
        let livingRoom = CastDevice(id: "1", name: "Living Room", type: .tv)
        let engine = FakeCastEngine(lists: [[livingRoom]])
        var names: [String] = []
        let subscription = engine.devices
            .map { list in list.map(\.name) }
            .filter { found in !found.isEmpty }
            .sink { found in
                names = found
            }

        try await Task.sleep(for: .milliseconds(1500))
        engine.stop()

        #expect(names == ["Living Room"])
        _ = subscription
    }

    @Test func discoveryReplacesTheDeviceList() async throws {
        let livingRoom = CastDevice(id: "1", name: "Living Room", type: .tv)
        let kitchen = CastDevice(id: "2", name: "Kitchen", type: .tv)
        let engine = FakeCastEngine(lists: [
            [livingRoom],
            [kitchen],
        ])
        var snapshots: [[String]] = []
        let subscription = engine.devices
            .map { list in list.map(\.name) }
            .filter { found in !found.isEmpty }
            .removeDuplicates()
            .sink { found in
                snapshots.append(found)
            }

        try await Task.sleep(for: .milliseconds(2500))
        engine.stop()

        #expect(snapshots.contains(["Living Room"]))
        #expect(snapshots.contains(["Kitchen"]))
        _ = subscription
    }

    @Test func discoveryStopsPublishing() async throws {
        let livingRoom = CastDevice(id: "1", name: "Living Room", type: .tv)
        let kitchen = CastDevice(id: "2", name: "Kitchen", type: .tv)
        let engine = FakeCastEngine(lists: [
            [livingRoom],
            [kitchen],
        ])
        var snapshots: [[String]] = []
        let subscription = engine.devices
            .map { list in list.map(\.name) }
            .filter { found in !found.isEmpty }
            .removeDuplicates()
            .sink { found in
                snapshots.append(found)
            }

        try await Task.sleep(for: .milliseconds(1500))
        engine.stop()
        let countAtStop = snapshots.count
        try await Task.sleep(for: .milliseconds(1500))

        #expect(countAtStop > 0)
        #expect(snapshots.count == countAtStop)
        _ = subscription
    }

    @Test func discoveryPublishesConnectionStates() async throws {
        let livingRoom = CastDevice(id: "1", name: "Living Room", type: .tv)
        let engine = FakeCastEngine(lists: [
            [livingRoom],
            [livingRoom],
            [livingRoom],
        ])
        var states: [ConnectionState] = []
        let subscription = engine.connection.sink { state in
            states.append(state)
        }

        try await Task.sleep(for: .milliseconds(3500))
        engine.stop()

        #expect(
            states == [
                .disconnected,
                .discovering,
                .connecting(livingRoom),
                .connected(livingRoom),
            ]
        )
        _ = subscription
    }
}
