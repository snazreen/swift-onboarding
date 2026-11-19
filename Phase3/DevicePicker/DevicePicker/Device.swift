import Foundation

struct Device: Identifiable {
    let name: String
    var id: String { name }
}
