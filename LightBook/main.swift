//
//  main.swift
//  LightBook
//
//  Created by 朱浩宇 on 2022/8/24.
//

import Foundation
import ZhuiShuKanApi
import Darwin

var w = winsize()
guard ioctl(STDOUT_FILENO, TIOCGWINSZ, &w) == 0 else {
    exit(0)
}

print("Light Book\nMade by Ryan")
print(String(repeating: "-", count: Int(w.ws_col)) + "\n")

print("Search: ", terminator: "")
guard let searchBook = readLine() else { exit(0) }

let results = try await ZhuiShuKanApi.search(name: searchBook)

if results.isEmpty {
    print("No such book")
} else {
    print("\n" + String(repeating: "-", count: Int(w.ws_col)) + "\n")

    for (id, result) in results.enumerated() {
        print("-> \(id)", "|" , result.name, "|", result.author)
    }

    print("ID: ", terminator: "")
    guard let idStr = readLine(), let id = Int(idStr) else { exit(0) }

    let search = results[id]

    print("\n" + String(repeating: "-", count: Int(w.ws_col)) + "\n")

    print("Save Path: ", terminator: "")
    guard let pathStr = readLine() else { exit(0) }
    let path = URL(filePath: pathStr)

    print("\n" + String(repeating: "-", count: Int(w.ws_col)) + "\n")

    print("Downloading...")

    try await ZhuiShuKanApi.genEpub(at: path, with: search)

    print("\n" + String(repeating: "-", count: Int(w.ws_col)) + "\n")

    print("Finish")

}
