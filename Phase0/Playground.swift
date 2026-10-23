import Playgrounds

#Playground {

  // A datatype is the kind of value a name holds.

  let episodeNumber: Int = 3  // Int
  let progress: Double = 0.5  // Double
  let isMuted: Bool = false  // Bool
  let deviceName: String = "Living Room"  // String

  print(episodeNumber)
  print(progress)
  print(isMuted)
  print(deviceName)

  // Functions

  func formatDuration(_ totalSeconds: Int) -> String {
    let minutes = totalSeconds / 60
    let seconds = totalSeconds % 60
    return String(format: "%02d:%02d", minutes, seconds)
  }

  func secondsAsDouble(from seconds: Int) -> Double {
    return Double(seconds)
  }

  func duration(minutes: Int, seconds: Int) -> Int {
    return minutes * 60 + seconds
  }

  print(formatDuration(225))
  print(secondsAsDouble(from: 123))
  print(duration(minutes: 2, seconds: 30))

  // Variables

  let episodeNumberFixed = 3
  // episodeNumberFixed = 4   // error: episodeNumberFixed is a let

  var playbackSeconds = 0
  print(playbackSeconds)

  playbackSeconds = 30
  print(playbackSeconds)

  playbackSeconds = playbackSeconds + 15
  print(playbackSeconds)

  // playbackSeconds = "done" // error: cannot assign a String to an Int

  // Strings

  let title = "The Last of Us"
  let episodeLabel = "Episode " + String(episodeNumber)
  print(episodeLabel)

  let status = "\(deviceName) · \(title) · \(formatDuration(playbackSeconds))"
  print(status)

  print(title.count)
  print(title.isEmpty)
  print(title.contains("Last"))

  // let bad = "Episode " + episodeNumber // throws error

  // Arrays

  let episodeTitles = ["Pilot", "Infected", "Long, Long Time"]
  print(episodeTitles[0])
  print(episodeTitles.count)
  //episodeTitles.append("Hi") // throws error
  // episodeTitles[1] = "hi" // throws error

  var devices = ["Living Room", "Bedroom"]
  devices.append("Kitchen")
  print(devices)
  devices.append("Hi")
  devices[1] = "hi"

  devices.remove(at: 0)
  print(devices)
  print(devices.first ?? "none")

  // Dictionaries

  let episodeLengths = [
    "Pilot": 125,
    "Infected": 150,
    "Long, Long Time": 180,
  ]
  print(episodeLengths["Pilot"] ?? 0)
  print(episodeLengths.count)

  var volumeByRoom = [
    "Living Room": 0.4,
    "Bedroom": 0.2,
  ]
  volumeByRoom["Kitchen"] = 0.6
  volumeByRoom["Bedroom"] = 0.1
  volumeByRoom["Living Room"] = nil
  print(volumeByRoom)
  print(volumeByRoom["hi"])  //prints nil

  let broken = ["Pilot": "long", "Infected": 150]

  print(broken)

  // Sets

  var rooms: Set<String> = ["Living Room", "Bedroom", "Living Room"]
  print(rooms)
  print(rooms.count)

  rooms.insert("Kitchen")
  rooms.insert("Bedroom")
  print(rooms.contains("Bedroom"))
  rooms.remove("Living Room")
  print(rooms)

  let playing: Set<String> = ["Living Room", "Kitchen"]
  print(rooms.intersection(playing))
  print(rooms.union(playing))

  //playing.insert("hi") // throws error

  // Enums

  enum PlaybackState {
    case playing
    case paused
    case stopped
  }

  let state = PlaybackState.playing
  var control: PlaybackState = .paused
  print(state)
  print(control)

  control = .stopped
  print(control == .stopped)

  if control == .playing {
    print("video is moving")
  } else {
    print("video is not moving")
  }

  // Type annotations

  let season: Int = 3
  let seasonInferred = 2

  let ratio: Double = 1
  print(type(of: ratio))
  print(type(of: seasonInferred))

  var nextControl: PlaybackState = .playing

  var queue: [String] = []
  var scores: [String: Int] = [:]
  print(queue.isEmpty)
  print(scores.isEmpty)

  // Loops

  for title in episodeTitles {
    print(title)
  }

  for number in 1...season {
    print("episode \(number)")
  }

  var remaining = 3
  while remaining > 0 {
    print(remaining)
    remaining = remaining - 1
  }
  print("done")

  // If / else

  if playbackSeconds == 0 {
    print("not started")
  } else if playbackSeconds < 60 {
    print("under a minute")
  } else {
    print("a minute or more")
  }

  if isMuted && control == .playing {
    print("playing with no sound")
  } else if control == .stopped {
    print("stopped")
  }

  // Switch

  switch control {
  case .playing:
    print("video is moving")
  case .paused:
    print("video is paused")
  case .stopped:
    print("video is stopped")
  }

  switch control {
  case .playing:
    print("video is moving")
  case .paused, .stopped:
    print("video is not moving")
  }

  switch season {
  case 1:
    print("first season")
  default:
    print("another season")
  }

  //Leaving default off an enum is useful. If you later add case buffering to PlaybackState, the switch stops compiling until you handle that new case. A default would hide it and run the catch-all instead.

  // Ternary

  let label = control == .playing ? "playing" : "not playing"
  print(label)

  print(isMuted ? "muted" : "sound on")

}
