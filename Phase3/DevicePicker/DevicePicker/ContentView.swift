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

/* final class DeviceSelection: ObservableObject {
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
} */

struct DeviceList: View {
    @EnvironmentObject var viewModel: DevicePickerViewModel

    var body: some View {
        List(viewModel.devices) { device in
            Button(device.name) {
                viewModel.choose(device)
            }
        }
    }
}

/* struct ContentView: View {
   // @StateObject private var viewModel = DevicePickerViewModel()
   //SOLID
    @StateObject private var viewModel = DevicePickerViewModel(log: MemoryLog())
    @State private var ticket: AnyCancellable?

    var body: some View {
        VStack {
            Text(viewModel.title)
            DeviceList()
        }
        .environmentObject(viewModel)
        .onAppear {
            ticket = viewModel.objectWillChange.sink {
                print("object will change")
            }
        }
    }
} */

struct ContentView: View {
    @State private var title = "Loading…"

    var body: some View {
        Text(title)
            .task {
                do {
                    /* let movie = try await loadMovie()
                   title = "\(movie.title) \(movie.id)"
                   print(movie.title, movie.id) */
                   let posts = try await loadPosts()
                   title = posts[0].title
                   print(posts[0].author)
                } catch {
                    title = "Failed"
                    print(error)
                }
            }
    }
}

#Preview {
    ContentView()
}
