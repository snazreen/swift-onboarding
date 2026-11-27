import Combine
import Foundation

final class FakeCastEngine {
    let devices = CurrentValueSubject<[CastDevice], Never>([])
    let connection = CurrentValueSubject<ConnectionState, Never>(.disconnected)
    private var ticks: AnyCancellable?
    private var index = 0
    private let lists: [[CastDevice]]

    init(lists: [[CastDevice]]) {
        self.lists = lists
    }

    func startDiscovery() {
        guard ticks == nil else { return }
        if connection.value == .disconnected {
            connection.send(.discovering)
        }
        ticks = Timer.publish(every: 2, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in self?.tick() }
    }

    func stopDiscovery() {
        ticks?.cancel()
        ticks = nil
        if connection.value == .discovering {
            connection.send(.disconnected)
        }
    }

    func connect(to device: CastDevice) {
        stopDiscovery()
        connection.send(.connecting(device))
        Task {
            try? await Task.sleep(for: .seconds(1))
            guard connection.value == .connecting(device) else { return }
            connection.send(.connected(device))
        }
    }

    func disconnect() {
        connection.send(.disconnected)
    }

    private func tick() {
        devices.send(lists[index])
        index = (index + 1) % lists.count
    }
}