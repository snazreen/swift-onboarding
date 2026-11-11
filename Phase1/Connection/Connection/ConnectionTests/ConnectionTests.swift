import Combine
import Testing

@testable import Connection

@MainActor
struct ConnectionStateTests {

    let bedroomTV = CastDevice(id: "101", name: "Bedroom TV", type: .tv)
    let officeTV = CastDevice(id: "202", name: "Office TV", type: .tv)

    @Test func beginsDeviceDiscovery() {
        let result = canTransition(
            from: .disconnected,
            to: .discovering
        )

        #expect(result == true)
    }

    @Test func establishesConnectionWithSelectedDevice() {
        #expect(
            canTransition(
                from: .discovering,
                to: .connecting(bedroomTV)
            )
        )

        #expect(
            canTransition(
                from: .connecting(bedroomTV),
                to: .connected(bedroomTV)
            )
        )
    }

    @Test func preventsSwitchingDevicesDuringConnection() {
        let result = canTransition(
            from: .connecting(bedroomTV),
            to: .connected(officeTV)
        )

        #expect(result == false)
    }

    @Test func handlesConnectionInterruption() {
        #expect(
            canTransition(
                from: .connected(bedroomTV),
                to: .reconnecting
            )
        )

        #expect(
            canTransition(
                from: .reconnecting,
                to: .failed(.connectionLost)
            )
        )
    }

    @Test func rejectsUnexpectedInitialStates() {
        let invalidTargets: [ConnectionState] = [
            .connecting(bedroomTV),
            .connected(bedroomTV),
            .reconnecting,
            .failed(.timedOut),
        ]

        for target in invalidTargets {
            #expect(
                !canTransition(
                    from: .disconnected,
                    to: target
                )
            )
        }
    }

    @Test func connectionTimeoutIsPreserved() {
        let errorState = ConnectionState.failed(.timedOut)

        #expect(
            canTransition(
                from: .connecting(bedroomTV),
                to: errorState
            )
        )

        if case .failed(let error) = errorState {
            #expect(error == .timedOut)
        } else {
            Issue.record("Connection should enter a failed state")
        }
    }

    @Test func allowsRestartAfterConnectionFailure() {
        let failureState = ConnectionState.failed(.deviceUnavailable)

        #expect(
            canTransition(
                from: failureState,
                to: .disconnected
            )
        )

        #expect(
            canTransition(
                from: failureState,
                to: .discovering
            )
        )
    }

    @Test func connectedDeviceCannotDirectlyStartDiscovery() {
        #expect(
            !canTransition(
                from: .connected(bedroomTV),
                to: .discovering
            )
        )
    }

    @Test func discoveryCannotSkipConnectionPhase() {
        #expect(
            !canTransition(
                from: .discovering,
                to: .connected(bedroomTV)
            )
        )
    }

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
}
