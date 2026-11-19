import Combine
import Foundation

protocol CastingLog {
    func record(_ message: String)
}

final class CastLog: CastingLog {
    static let shared = CastLog()
    private init() {}

    func record(_ message: String) {
        print("cast: \(message)")
    }
}

final class MemoryLog: CastingLog {
    func record(_ message: String) {
        print("saved: \(message)")
    }
}

final class DevicePickerViewModel: ObservableObject {
    let devices = [
        Device(name: "Living Room"),
        Device(name: "Kitchen"),
    ]
    @Published private var selected: Device?
   // private let log: CastingLog = CastLog.shared

   private let log: CastingLog

init(log: CastingLog = CastLog.shared) {
    self.log = log
    print(names(startingWith: "K"))
}

    var title: String { selected?.name ?? "None" }

func names(startingWith prefix: String) -> [String] {
    devices
        .map(\.name)
        .filter { name in
            name.hasPrefix(prefix)
        }
}
    func choose(_ device: Device) {
        selected = device
        log.record(device.name)
    }
}
