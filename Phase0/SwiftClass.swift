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

    // katas for above learnings

    //func totalRuntime(_ episodes: [Episode]) -> Int
    //let episodes = [
    // Episode(title: "Pilot", seconds: 125),
    // Episode(title: "Infected", seconds: 150)
    //]
    //totalRuntime(episodes)  // 275

    func totalRuntime(_ episodes: [Episode]) -> Int {

        var totalDuration = 0

        for episode in episodes {
            totalDuration = totalDuration + episode.seconds
        }

        return totalDuration
    }

    let episodes = [
        Episode(title: "Pilot", seconds: 125),
        Episode(title: "Infected", seconds: 150),
    ]
    print(totalRuntime(episodes))

    class DeviceSession {
        var name: String
        init(name: String) { self.name = name }
    }

    //func rename(_ session: DeviceSession, to name: String)
    //let livingRoom = DeviceSession(name: "Living Room")
    //let sameRoom = livingRoom
    //rename(livingRoom, to: "Kitchen")
    // sameRoom.name is "Kitchen"

    func rename(_ session: DeviceSession, to name: String) {
        session.name = name
    }

    let livingRoom = DeviceSession(name: "Living Room")
    let sameRoom = livingRoom
    rename(livingRoom, to: "Kitchen")
    print(sameRoom.name)

    enum Session {
        case idle
        case playing(title: String, seconds: Int)
        case paused(title: String, seconds: Int)
    }

    //func pause(_ session: Session) -> Session
    //pause(.playing(title: "Pilot", seconds: 40))
    // .paused(title: "Pilot", seconds: 40)
    //pause(.paused(title: "Pilot", seconds: 40))
    // .paused(title: "Pilot", seconds: 40)
    //pause(.idle)
    // .idle

    func pause(_ session: Session) -> Session {
        switch session {
        case .playing(let title, let seconds):
            return .paused(title: title, seconds: seconds)
        case .paused(let title, let seconds):
            return .paused(title: title, seconds: seconds)
        case .idle:
            return .idle

        }

    }

    print(pause(.playing(title: "Pilot", seconds: 40)))
    print(pause(.paused(title: "Pilot", seconds: 40)))
    print(pause(.idle))

    //func episodesShorterThan(_ episodes: [Episode], limit: Int) -> [String]
    //episodesShorterThan(
    //   [
    //    Episode(title: "Pilot", seconds: 125),
    //   Episode(title: "Infected", seconds: 150),
    //  Episode(title: "News", seconds: 30)
    //],
    // limit: 130
    //)  // ["Pilot", "News"]

    func episodesShorterThan(_ episodes: [Episode], limit: Int) -> [String] {

        let shorterEpisodes = episodes.filter {
            episode in
            episode.seconds < limit

        }
        return shorterEpisodes.map { $0.title }

    }

    print(
        episodesShorterThan(
            [
                Episode(title: "Pilot", seconds: 125),
                Episode(title: "Infected", seconds: 150),
                Episode(title: "News", seconds: 30),
            ],
            limit: 130
        ))

    //protocols
    protocol Playable {
        var title: String { get }
        func label() -> String
    }

    struct Movie: Playable {
        var title: String

        func label() -> String {
            return title
        }
    }

    struct Channel: Playable {
        var name: String
        var title: String { name }

        func label() -> String {
            return "\(name) · live"
        }
    }

    func playableLabel(_ item: any Playable) -> String {
        return item.label()
    }

    print(playableLabel(Movie(title: "Pilot")))
    print(playableLabel(Channel(name: "News")))

    // Delegates

    protocol SessionDelegate: AnyObject {
        func sessionDidRename(to name: String)
    }

    class Room {
        var name: String
        //weak means Room does not keep Logger alive. logger has to stay in its own let, or the delegate disappears
        weak var delegate: SessionDelegate?

        init(name: String) {
            self.name = name
        }

        func rename(to name: String) {
            self.name = name
            delegate?.sessionDidRename(to: name)
        }
    }

    class Logger: SessionDelegate {
        func sessionDidRename(to name: String) {
            print("renamed to \(name)")
        }
    }

    let room = Room(name: "Living Room")
    let logger = Logger()
    room.delegate = logger
    room.rename(to: "Kitchen")

    // optionals

    let selected: String? = "Living Room"
    let missing: String? = nil

    if let name = selected {
        print(name)
    }

    print(missing ?? "no device")

    let lengths = ["Pilot": 125]
    print(lengths["Pilot"] ?? 0)
    print(lengths["Nope"] ?? 0)

    // Generics
    func firstItem<T>(_ items: [T]) -> T? {
        return items.first
    }

    print(firstItem(["Pilot", "Infected"]) ?? "none")
    print(firstItem([125, 150]) ?? 0)
    print(firstItem([String]()) ?? "none")

    struct Pair<T> {
        var first: T
        var second: T
    }

    let titlePair = Pair(first: "Pilot", second: "Infected")
    let runtimePair = Pair(first: 125, second: 150)
    print(titlePair.first)
    print(runtimePair.second)

    // Practice katas

    // Protocol
    protocol Switchable {
        func turnedOn() -> String
    }

    //func status(of item: any Switchable) -> String
    //status(of: Lamp(room: "Kitchen"))  // "Kitchen lamp on"
    //status(of: Fan(speed: 2))          // "Fan speed 2"

    struct Lamp: Switchable {

        var room: String
        func turnedOn() -> String {
            return ("\(room) lamp on")
        }
    }

    struct Fan: Switchable {

        var speed: Int
        func turnedOn() -> String {
            return "Fan speed \(speed)"
        }
    }

    func status(of item: any Switchable) -> String {
        return item.turnedOn()
    }

    print(status(of: Lamp(room: "Kitchen")))
    print(status(of: Fan(speed: 2)))

    //Delegates
    protocol DownloadDelegate: AnyObject {
        func downloadDidFinish(file: String)
    }

    //let loader = Downloader()
    //let record = DownloadRecord()
    //loader.delegate = record
    //loader.finish(file: "pilot.mp4")
    //loader.finish(file: "news.mp4")
    // record.files is ["pilot.mp4", "news.mp4"]

    class Downloader {

        weak var delegate: DownloadDelegate?
        func finish(file: String) {
            delegate?.downloadDidFinish(file: file)
        }
    }

    class DownloadRecord: DownloadDelegate {

        var files: [String] = []
        func downloadDidFinish(file: String) {
            files.append(file)
        }
    }

    let loader = Downloader()
    let record = DownloadRecord()
    loader.delegate = record
    loader.finish(file: "pilot.mp4")
    loader.finish(file: "news.mp4")
    print(record.files)

    // optional

    //func displayName(_ name: String?) -> String
    //displayName("Nazreen")  // "Nazreen"
    //displayName(nil)        // "Guest"
    //displayName("")         // "Guest"

    func displayName(_ name: String?) -> String {
        return name ?? "Guest"
    }

    print(displayName("Nazreen"))
    print(displayName(nil))
    print(displayName(""))

    // Generics

    //func repeatItem<T>(_ item: T, times: Int) -> [T]
    //repeatItem("Hi", times: 3)  // ["Hi", "Hi", "Hi"]
    //repeatItem(1, times: 2)     // [1, 1]

    func repeatItem<T>(_ item: T, times: Int) -> [T] {

        var itemsList: [T] = []
        for _ in 0..<times {
            itemsList.append(item)
        }

        return itemsList
    }

    print(repeatItem("Hi", times: 3))
    print(repeatItem(1, times: 2))
    
    //func wordCounts(_ words: [String]) -> [String: Int]
    //wordCounts(["play", "pause", "play"])
    // ["play": 2, "pause": 1]

    func wordCounts(_ words: [String]) -> [String: Int] {
        
        var wordList : [String: Int] = [:]
        
        for word in words {
            wordList[word] = (wordList[word] ?? 0) + 1
        }
        
        return wordList
    }
    
    print(wordCounts(["play", "pause", "play"]))
}
