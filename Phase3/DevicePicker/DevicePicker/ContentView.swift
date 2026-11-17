import SwiftUI
import Playgrounds

/* struct DeviceRow: View {
    let name: String
    @Binding var selected: String

    var body: some View {
        Button(name) {
            selected = name
        }
    }
}

struct ContentView: View {
    @State private var names = ["Living Room", "Kitchen"]
    @State private var selected = "None"

    var body: some View {
        VStack {
            Text(selected)
            List(names, id: \.self) { name in
                DeviceRow(name: name, selected: $selected)
            }
        }
    }
} */

final class DeviceSelection: ObservableObject {
    @Published var name = "None"
}

struct ContentView: View {
    @State private var names = ["Living Room", "Kitchen"]
    @StateObject private var selection = DeviceSelection()

    var body: some View {
        VStack {
            Text(selection.name)
            List(names, id: \.self) { name in
                Button(name) {
                    selection.name = name
                    print(selection.name)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}

#Playground {
    _ = 1 + 2
}
