import Playgrounds

#Playground {

    //Structs
    struct Episode {
        var title: String
        var seconds: Int
    }

    var pilot = Episode(title: "Pilot", seconds: 125)
    var copy = pilot
    copy.seconds = 10
    print(pilot.seconds)
    print(copy.seconds)

    //Classes
    class PlaybackSession {
        var seconds: Int

        init(seconds: Int) {
            self.seconds = seconds
        }
    }

    let session = PlaybackSession(seconds: 125)
    let sameSession = session
    sameSession.seconds = 10
    print(session.seconds)
    print(sameSession.seconds)

    let fixed = Episode(title: "Pilot", seconds: 125)
    // fixed.seconds = 10 // fails as fixed is let

    // Use a struct for a value you want copied, such as an episode. Use a class when several parts of the app must share one object, such as the current playback session.

    //Closures
    let format: (Int) -> String = { totalSeconds in
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    print(format(125))

    let titles = ["Pilot", "Infected", "Long, Long Time"]
    let shortTitles = titles.filter { title in
        title.count < 10
    }
    print(shortTitles)

    //Swift lets the closure sit outside the parentheses, and it can use $0 instead of a name.

    enum Connection {
        case disconnected
        case connecting(device: String)
        case connected(device: String)
        case failed(message: String)
    }

    var current = Connection.connected(device: "Living Room")

    switch current {
    case .disconnected:
        print("nothing connected")
    case .connecting(let device):
        print("connecting to \(device)")
    case .connected(let device):
        print("connected to \(device)")
    case .failed(let message):
        print(message)
    }

    current = Connection.failed(message: "device disappeared")

    // Practice Qns

    //func renamed(_ episode: Episode, to title: String) -> Episode
    //let original = Episode(title: "Pilot", seconds: 125)
    //let updated = renamed(original, to: "Infected")
    // updated.title is "Infected"
    // original.title is still "Pilot"

    func renamed(_ episode: Episode, to title: String) -> Episode {
        var latest = episode
        latest.title = title
        return latest
    }

    let original = Episode(title: "Pilot", seconds: 125)
    let updated = renamed(original, to: "Infected")
    print(updated.title)
    print(original.title)

    //func advance(_ session: PlaybackSession, by extra: Int)
    //let session = PlaybackSession(seconds: 125)
    //advance(session, by: 15)
    // session.seconds is 140

    func advance(_ session: PlaybackSession, by extra: Int) {
        session.seconds = session.seconds + extra
    }
    let newSession = PlaybackSession(seconds: 125)
    advance(newSession, by: 15)
    print(newSession.seconds)

    enum Playback {
        case vod(title: String, seconds: Int)
        case live(channel: String)
    }
    //func mediaLabel(_ playback: Playback) -> String
    // mediaLabel(.vod(title: "Pilot", seconds: 125)) // "Pilot · 02:05"
    //mediaLabel(.live(channel: "News")) // "News · live"

    func formatDuration(_ totalSeconds: Int) -> String {
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    func mediaLabel(_ playback: Playback) -> String {

        var medialabel = ""

        switch playback {
        case .vod(let title, let seconds):
            let duration = formatDuration(seconds)
            medialabel = "\(title) · \(duration)"
        case .live(let channel):
            medialabel = "\(channel) · live"
        }

        return medialabel
    }

    print(mediaLabel(.vod(title: "Pilot", seconds: 125)))  // "Pilot · 02:05"
    print(mediaLabel(.live(channel: "News")))
}
