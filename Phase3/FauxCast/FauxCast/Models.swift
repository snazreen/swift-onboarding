import Foundation

enum DeviceType {
    case tv
    case dongle
}

struct CastDevice: Identifiable, Equatable {
    let id: String
    let name: String
    let type: DeviceType
}

enum FailureReason: Equatable {
    case connectionLost
    case timedOut
    case deviceUnavailable
}

enum ConnectionState: Equatable {
    case disconnected
    case discovering
    case connecting(CastDevice)
    case connected(CastDevice)
    case reconnecting
    case failed(FailureReason)
}

struct Media {
    let title: String
    let subtitle: String
}