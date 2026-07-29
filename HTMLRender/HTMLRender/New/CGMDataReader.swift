//
//  CGMDataReader.swift
//  HTMLRender
//
//  Created by Attili Naga Srinivasu on 29/07/26.
//

import Foundation

struct CGMDataReader {

    private let data: Data
    private var offset: Int = 0

    init(data: Data) {
        self.data = data
    }

    var isAtEnd: Bool {
        offset >= data.count
    }

    mutating func readByte() -> UInt8? {
        guard offset < data.count else {
            return nil
        }

        let value = data[offset]
        offset += 1
        return value
    }

    mutating func readUInt16() -> UInt16? {
        guard offset + 2 <= data.count else {
            return nil
        }

        let first = UInt16(data[offset])
        let second = UInt16(data[offset + 1])
        offset += 2

        return (first << 8) | second
    }

    mutating func readInt16() -> Int16? {
        guard let value = readUInt16() else {
            return nil
        }

        return Int16(bitPattern: value)
    }

    mutating func readData(length: Int) -> Data {
        guard length > 0 else {
            return Data()
        }

        let end = min(offset + length, data.count)
        let subdata = data.subdata(in: offset..<end)
        offset = end
        return subdata
    }

    mutating func readString() -> String? {
        guard let lengthByte = readByte() else {
            return nil
        }

        var length = Int(lengthByte)

        if length == 255 {
            guard let longLength = readUInt16() else {
                return nil
            }

            length = Int(longLength)
        }

        guard offset + length <= data.count else {
            return nil
        }

        let stringData = data.subdata(in: offset..<(offset + length))
        offset += length

        return String(data: stringData, encoding: .ascii)
            ?? String(data: stringData, encoding: .utf8)
    }

    mutating func skip(bytes: Int) {
        offset = min(offset + bytes, data.count)
    }
}
