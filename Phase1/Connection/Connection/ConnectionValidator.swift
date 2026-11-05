import Playgrounds

func canTransition(from current: ConnectionState, to next: ConnectionState) -> Bool {
    switch (current, next) {
    case (.disconnected, .discovering):
        return true
    case (.discovering, .connecting):
        return true
    case (.discovering, .disconnected):
        return true
    case (.connecting(let currentDevice), .connected(let nextDevice)):
        return currentDevice == nextDevice
    case (.connecting, .failed):
        return true
    case (.connecting, .disconnected):
        return true
    case (.connected, .reconnecting):
        return true
    case (.connected, .disconnected):
        return true
    case (.reconnecting, .connected):
        return true
    case (.reconnecting, .failed):
        return true
    case (.failed, .disconnected):
        return true
    case (.failed, .discovering):
        return true
    default:
        return false
    }
}

#Playground {
    let livingRoom = CastDevice(id: "1", name: "Living Room", type: .tv)
    let kitchen = CastDevice(id: "2", name: "Kitchen", type: .tv)

    print(canTransition(from: .disconnected, to: .discovering))
    print(canTransition(from: .disconnected, to: .connected(livingRoom)))
    print(canTransition(from: .connecting(livingRoom), to: .connected(livingRoom)))
    print(canTransition(from: .connecting(livingRoom), to: .connected(kitchen)))
    
    let failed = ConnectionState.failed(.connectionLost)
    print(canTransition(from: .reconnecting, to: failed))
    if case .failed(let reason) = failed {
        print(reason)
    }
}
