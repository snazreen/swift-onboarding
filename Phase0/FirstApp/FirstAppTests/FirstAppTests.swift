//
//  FirstAppTests.swift
//  FirstAppTests
//
//  Created by NAZREEN S  on 04/11/26.
//

import Testing
import Collections

struct FirstAppTests {

    @Test func addition() {
        #expect(1 + 1 == 2)
    }
    
    @Test func uniqueTitles() {
        let titles: OrderedSet = ["Pilot", "News", "Pilot"]
        #expect(titles.count == 2)
    }

}
