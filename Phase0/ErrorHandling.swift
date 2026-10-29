import Foundation
import Playgrounds

@propertyWrapper
struct Clamped {
    private var number = 0

    var wrappedValue: Int {
        get { number }
        set { number = min(max(newValue, 0), 100) }
    }

    init(wrappedValue: Int) {
        number = min(max(wrappedValue, 0), 100)
    }
}
@propertyWrapper
struct Trimmed {
    private var text = ""

    var wrappedValue: String {
        get { text }
        set { text = newValue.trimmingCharacters(in: .whitespaces) }
    }

    init(wrappedValue: String) {
        text = wrappedValue.trimmingCharacters(in: .whitespaces)
    }
}

@Observable
class NowPlaying {
    var title = "Pilot"
    var isPlaying = false
}

@Observable
class CastSession {
    var device = "Living Room"
    var connected = false
}

#Playground {

    // Error

    enum PlaybackError: Error {
        case missingTitle
        case tooLong
    }

    func loadTitle(_ title: String) throws -> String {
        if title.isEmpty {
            throw PlaybackError.missingTitle
        }
        if title.count > 20 {
            throw PlaybackError.tooLong
        }
        return title
    }

    do {
        let title = try loadTitle("Pilot")
        print(title)
    } catch PlaybackError.tooLong {
        print("title is too long")
    } catch PlaybackError.missingTitle {
        print("title is missing")
    }

    do {
        let title = try loadTitle("")
        print(title)
    } catch PlaybackError.tooLong {
        print("title is too long")
    } catch PlaybackError.missingTitle {
        print("title is missing")
    }

    do {
        let title = try loadTitle(
            "Hi hello how are you. Hi hello how are you. Hi hello how are you")
        print(title)
    } catch PlaybackError.tooLong {
        print("title is too long")
    } catch PlaybackError.missingTitle {
        print("title is missing")
    }

    // Observers

    class Volume {
        var level = 0 {
            willSet {
                print("volume will change from \(level) to \(newValue)")
            }
            didSet {
                print("volume changed from \(oldValue) to \(level)")
            }
        }
    }

    // The property has to be var. Assigning volume.level = 4 is what runs the observers. Creating Volume() does not, because the starting 0 is the initial value, not a later change.

    let volume = Volume()
    volume.level = 4
    volume.level = 7

    // concurrency

    print("start")
    // DispatchQueue.global() is a background queue. sync runs the block there and waits
    let loaded = DispatchQueue.global().sync {
        "loaded Pilot"
    }
    print(loaded)
    print("done")

    final class TitleBox {
        var text = ""
    }

    print("start")
    let title = await withCheckedContinuation { continuation in
        DispatchQueue.global().async {
            continuation.resume(returning: "loaded Pilot")
        }
    }
    print(title)

    func episodeTitle() async throws -> String {
        try await Task.sleep(for: .seconds(1))
        return "Pilot"
    }

    let name = try await episodeTitle()
    print(name)

    async let name2 = episodeTitle()
    print("still going")
    print(try await name2)

    // Katas

    // 1. Throwing errors. saveBookmark(minute:) returns a String and throws BookmarkError.
    // A minute below 0 throws .beforeStart.
    // A minute above 40 throws .afterCredits.
    // Any other minute returns "saved at minute 12" for 12.
    // Catch the cases and print your own messages:
    // saveBookmark(minute: 12) prints saved at minute 12
    // saveBookmark(minute: -2) prints too early
    // saveBookmark(minute: 55) prints during the credits

    enum BookmarkError: Error {
        case beforeStart
        case afterCredits
    }

    func saveBookmark(_ minute: Int) throws -> String {
        if minute < 0 {
            throw BookmarkError.beforeStart
        }
        if minute > 40 {
            throw BookmarkError.afterCredits
        }
        return "saved at minute \(minute)"
    }

    do {
        let title = try saveBookmark(50)
        print(title)
    } catch BookmarkError.beforeStart {
        print("too early")
    } catch BookmarkError.afterCredits {
        print("during the credits")
    }

    // 2. Property observer. A class Progress has var percent, starting at 0.
    // Use didSet so the stored value stays inside 0...100.
    // let progress = Progress()
    // progress.percent = 80
    // print(progress.percent)
    // progress.percent = 130
    // print(progress.percent)
    // progress.percent = -10
    // print(progress.percent)
    // The panel prints 80, then 100, then 0.

    class Progress {
        var percent = 0 {
            didSet {
                if percent > 100 {
                    percent = 100
                }
                if percent < 0 {
                    percent = 0
                }
                print("Progress changed from \(oldValue) to \(percent)")
            }
        }
    }

    let progress = Progress()
    progress.percent = 80
    print(progress.percent)
    progress.percent = 130
    print(progress.percent)
    progress.percent = -10
    print(progress.percent)

    // 3. Async. captions() is async throws, waits 1 second, and returns "English".
    // Start it with async let, print fetching before you await it, then print the result.
    // The panel prints fetching, then English.

    func captions() async throws -> String {
        try await Task.sleep(for: .seconds(1))
        return "English"
    }

    print("fetching")
    let caption = try await captions()
    print(caption)

    // property wrapper

    struct PlaybackProgress {
        @Clamped var percent = 0
    }

    var playback = PlaybackProgress()
    playback.percent = 80
    print(playback.percent)
    playback.percent = 130
    print(playback.percent)
    playback.percent = -10
    print(playback.percent)

    // Observable

    let show = NowPlaying()
    withObservationTracking {
        print(show.isPlaying)
    } onChange: {
        print("isPlaying changed")
    }
    show.isPlaying = true
    print(show.isPlaying)

    // Katas

    // 1. Property wrapper. Trimmed stores a String and removes spaces from both ends whenever the value is set.
    // It needs a wrappedValue property and an init(wrappedValue:), same as Clamped.
    // Put Trimmed above #Playground.
    // struct Speaker {
    //     @Trimmed var name = ""
    // }
    // var speaker = Speaker()
    // speaker.name = "  Living Room  "
    // print(speaker.name)
    // speaker.name = "   Kitchen   "
    // print(speaker.name)
    // The panel prints Living Room, then Kitchen.

    struct Speaker {
        @Trimmed var name = ""
    }

    var speaker = Speaker()
    speaker.name = "  Living Room  "
    print(speaker.name)
    speaker.name = "   Kitchen   "
    print(speaker.name)

    // 2. Observation. @Observable class CastSession has device, starting as "Living Room", and connected, starting as false.
    // Put CastSession above #Playground. Track only device.
    // let session = CastSession()
    // withObservationTracking {
    //     print(session.device)
    // } onChange: {
    //     print("device changed")
    // }
    // session.connected = true
    // session.device = "Kitchen"
    // print(session.device)
    // The panel prints Living Room, then device changed, then Kitchen.
    // Setting connected prints nothing, because the tracking closure never read connected.

    let session = CastSession()
    let watched = withObservationTracking {
        session.device
    } onChange: {
        print("device changed")
    }
    print(watched)
    session.connected = true
    session.device = "Kitchen"
    print(session.device)
}
