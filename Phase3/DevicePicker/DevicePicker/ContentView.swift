import SwiftUI
import Combine

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

/* final class DeviceSelection: ObservableObject {
    @Published var name = "None"
} */

// ObservedObject
/* struct ContentView: View {
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
} */

/* struct DeviceList: View {
    @ObservedObject var selection: DeviceSelection
    let names: [String]

    var body: some View {
        List(names, id: \.self) { name in
            Button(name) {
                selection.name = name
                print(selection.name)
            }
        }
    }
}

struct ContentView: View {
    @State private var names = ["Living Room", "Kitchen"]
    @StateObject private var selection = DeviceSelection()
    @State private var ticket: AnyCancellable?

    var body: some View {
        VStack {
            Text(selection.name)
            DeviceList(selection: selection, names: names)
        }
        .onAppear {
            ticket = selection.objectWillChange.sink {
                print("object will change")
            }
        }
    }
} */

// EnvironmentObject
/* 
struct DeviceList: View {
    @EnvironmentObject var selection: DeviceSelection
    let names: [String]

    var body: some View {
        List(names, id: \.self) { name in
            Button(name) {
                selection.name = name
                print(selection.name)
            }
        }
    }
}

struct ContentView: View {
    @State private var names = ["Living Room", "Kitchen"]
    @StateObject private var selection = DeviceSelection()
    @State private var ticket: AnyCancellable?

    var body: some View {
        VStack {
            Text(selection.name)
            //DeviceList(selection: selection, names: names)
            DeviceList(names: names)
            /* List(names, id: \.self) { name in
                Button(name) {
                    selection.name = name
                    print(selection.name)
                }
            } */
        }
        .environmentObject(selection)
        .onAppear {
            ticket = selection.objectWillChange.sink {
                print("object will change")
            }
        }
    }
} */

// private

final class DeviceSelection: ObservableObject {
    @Published private var name = "None"

    var title: String { name }

    func choose(_ newName: String) {
        name = newName
        print(name)
    }
}

struct DeviceList: View {
    @EnvironmentObject var selection: DeviceSelection
    let names: [String]

    var body: some View {
        List(names, id: \.self) { name in
            Button(name) {
    selection.choose(name)
}
        }
    }
}

struct ContentView: View {
    @State private var names = ["Living Room", "Kitchen"]
    @StateObject private var selection = DeviceSelection()
    @State private var ticket: AnyCancellable?

    var body: some View {
        VStack {
            DeviceList(names: names)
        }
        .environmentObject(selection)
        .onAppear {
            ticket = selection.objectWillChange.sink {
                print("object will change")
            }
        }
    }
}

#Preview {
    ContentView()
}
