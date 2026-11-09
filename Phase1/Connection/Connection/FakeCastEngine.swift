import Combine
import Playgrounds

#Playground {

    // Just is a publisher that sends one value and then finishes.
    /* let devices = Just([
        CastDevice(id: "1", name: "Living Room", type: .tv)
    ])

    let subscription = devices.sink { list in
        print(list)
    }
    _ = subscription */

    // PassthroughSubject is a publisher that sends values to its subscribers.

    /* let devices = PassthroughSubject<[CastDevice], Never>()
    let subscription = devices.sink { list in
        print(list.count)
    }
    devices.send([
        CastDevice(id: "1", name: "Living Room", type: .tv)
    ])
    devices.send([
        CastDevice(id: "1", name: "Living Room", type: .tv),
        CastDevice(id: "2", name: "Kitchen", type: .tv)
    ])
    _ = subscription */

    /* let devices = CurrentValueSubject<[CastDevice], Never>([])

    let subscription = devices.sink { list in
        print(list.count)
    }

    devices.send([
        CastDevice(id: "1", name: "Living Room", type: .tv)
    ])
    _ = subscription */

    // CurrentValueSubject is a publisher that sends the latest value to its subscribers.

    let devices = CurrentValueSubject<[CastDevice], Never>([])

    /* let subscription = devices
        .map { list in
            list.map(\.name)
        }
        .sink { names in
            print(names)
        } */

    let subscription =
        devices
        .map { list in
            list.map(\.name)
        }
        .filter { names in
            !names.isEmpty
        }
        .sink { names in
            print(names)
        }

    devices.send([
        CastDevice(id: "1", name: "Living Room", type: .tv)
    ])
    _ = subscription

}
