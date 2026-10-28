import Playgrounds

extension Int {
    func asDuration() -> String {
        let minutes = self / 60
        let seconds = self % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

extension String {
    var wordCount: Int {
        if isEmpty { return 0 }
        return split(separator: " ").count
    }
    
    func repeated(_ count: Int) -> String {
        var repeatedString = ""
        if count <= 0 {
            return ""
        }
            
        for _ in 0...count-1 {
            repeatedString += self
        }
        return repeatedString
    }
}

struct Track {
    fileprivate let seconds: Int
    let title: String

    init(title: String, seconds: Int) {
        self.title = title
        self.seconds = seconds
    }

    func label() -> String {
        return "\(title) · \(seconds.asDuration())"
    }
}

struct Safe {
    private let code: String

    init(code: String) {
        self.code = code
    }

    func opens(with : String) -> Bool {
        return with == self.code
    }
}

#Playground {
    
    //Extensions

    print(125.asDuration())
    print(45.asDuration())
    
    print("House of Dragon".wordCount)
    
    // Access Control
    
    let pilot = Track(title: "Pilot", seconds: 125)
    print(pilot.label())
    // print(pilot.seconds) fails as seconds is private
     print(pilot.seconds) //works as seconds is fileprivate
    
    // Initializers
    
    // Clip has no init in its definition. A struct writes that initializer for you, one argument per stored property
    // A class does not receive a free initializer,
    struct Clip {
        var title: String
        var seconds: Int
    }
    struct Mark {
        var title: String
        var seconds: Int
        init(title: String, minutes: Int, seconds: Int) {
            self.title = title
            self.seconds = minutes * 60 + seconds
        }
    }

    let intro = Clip(title: "Intro", seconds: 30)
    print(intro.seconds)

    let recap = Mark(title: "Recap", minutes: 1, seconds: 5)
    print(recap.seconds)
    
    enum PlaybackError: Error {
        case missingTitle
    }

    func loadTitle(_ title: String) -> Result<String, PlaybackError> {
        if title.isEmpty {
            return .failure(.missingTitle)
        }
        return .success(title)
    }

    switch loadTitle("Pilot") {
    case .success(let title):
        print(title)
    case .failure(let error):
        print(error)
    }
    
    // loadTitle("") will print missingTitle
    
    // Practice Katas
    
    // Extensions
    
    //"ha".repeated(3)  // "hahaha"
    //"ab".repeated(0)  // ""
    
    print("ha".repeated(3))
    print("ab".repeated(0))
    
    // Access Control
    
    //let safe = Safe(code: "1234")
    //safe.opens(with: "1234")  // true
    //safe.opens(with: "0000")  // false
    // safe.code is not allowed
    
    let safe = Safe(code: "1234")
    print(safe.opens(with: "1234"))
    print(safe.opens(with: "0000"))
    
    
    //Initializer. The caller passes a name. The struct stores the finished greeting. There is no Greeting(text:) initializer, because this init replaces the free one.
    
    //Greeting(name: "Nazreen").text  // "Hello, Nazreen"
    
    struct Greeting {
        var text: String
        init(name: String) {
            self.text = "Hello, \(name)"
        }
    }
    
    print(Greeting(name: "Nazreen").text)  // "Hello, Nazreen"
    
    //Result. Below 0 fails as too low. Above 100 fails as too high. Anything from 0 through 100 succeeds with "pass" when the score is at least 50, and "fail" otherwise.
    
    //grade(85)   // .success("pass")
    //grade(40)   // .success("fail")
    //grade(-1)   // .failure(.tooLow)
    //grade(101)  // .failure(.tooHigh)
    
    enum ExamMarkError: Error {
        case tooLow
        case tooHigh
    }
    
    func grade(_ mark: Int) -> Result<String, ExamMarkError> {
        if mark < 0 {
            return .failure(.tooLow)
        }
        if mark > 100 {
            return .failure(.tooHigh)
        }
        return .success(mark < 50 ? "fail" : "pass")
    }
    
    print(grade(85))
    print(grade(40))
    print(grade(-1))
    print(grade(101))

}
