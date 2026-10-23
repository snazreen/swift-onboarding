import Playgrounds

#Playground {
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

  // Return a label like "S1E3".
  //func episodeLabel(season: Int, episode: Int) -> String
  //episodeLabel(season: 1, episode: 3)  // "S1E3"

  func episodeLabel(season: Int, episode: Int) -> String {
    var result = "S\(season)E\(episode)"
    return result
  }

  print(episodeLabel(season: 1, episode: 3))

  //Add every number in the array.
  //func totalDuration(_ parts: [Int]) -> Int
  //totalDuration([60, 45, 30])  // 135

  func totalDuration(_ parts: [Int]) -> Int {

    var sum = 0

    for num in parts {
      sum = sum + num
    }

    return sum
  }

  print(totalDuration([60, 45, 30]))

  //Return the device names with the duplicates removed.

  //func uniqueDevices(_ names: [String]) -> Set<String>
  //uniqueDevices(["Living Room", "Bedroom", "Living Room"]).count  // 2

  func uniqueDevices(_ names: [String]) -> Set<String> {
    var result: Set<String> = []
    for name in names {
      result.insert(name)
    }
    return result
  }

  print(uniqueDevices(["Living Room", "Bedroom", "Living Room"]).count)

  //Look up a title. A missing title returns 0.

  //func length(of title: String, in lengths: [String: Int]) -> Int
  //let lengths = ["Pilot": 125, "Infected": 150]
  //length(of: "Pilot", in: lengths)  // 125
  //length(of: "Nope", in: lengths)   // 0

  func length(of title: String, in lengths: [String: Int]) -> Int {

    return lengths[title] ?? 0
  }

  let lengths = ["Pilot": 125, "Infected": 150]
  print(length(of: "Pilot", in: lengths))  // 125
  print(length(of: "Nope", in: lengths))  // 0

  //Add a PlaybackState enum with playing, paused, and stopped. Return one word for each case.

  //func describe(_ state: PlaybackState) -> String
  //describe(.playing)  // "playing"
  //describe(.paused)   // "paused"
  //describe(.stopped)  // "stopped"

  func describe(_ state: PlaybackState) -> String {

    switch state {
    case .stopped:
      return "stopped"

    case .playing:
      return "playing"

    case .paused:
      return "paused"

    }
  }

  enum PlaybackState {
    case playing
    case paused
    case stopped
  }

  print(describe(.playing))
  print(describe(.stopped))
  print(describe(.paused))

  //Build one status line. Use your formatDuration for the time, and choose "muted" or "sound on" from muted.

  //func statusLine(device: String, muted: Bool, seconds: Int) -> String
  //statusLine(device: "Living Room", muted: false, seconds: 125)
  // "Living Room · sound on · 02:05"

  func statusLine(device: String, muted: Bool, seconds: Int) -> String {
    let mutedValue = muted ? "muted" : "sound on"
    return "\(device) · \(mutedValue) · \(formatDuration(seconds))"
  }

  print(statusLine(device: "Living Room", muted: false, seconds: 125))

}
