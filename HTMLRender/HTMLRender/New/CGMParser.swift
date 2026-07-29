//
//  CGMParser.swift
//  HTMLRender
//
//  Created by Attili Naga Srinivasu on 29/07/26.
//

import Foundation
import CoreGraphics
import SwiftUI

final class CGMParser {

    private var currentStyle = CGMGraphicStyle()

    private var colorTable: [Int: Color] = [
        0: Color(red: 1.0, green: 1.0, blue: 1.0), // White
        1: Color(red: 0.0, green: 0.0, blue: 0.0), // Black
        2: Color(red: 1.0, green: 0.0, blue: 0.0), // Red
        3: Color(red: 0.0, green: 1.0, blue: 0.0), // Green
        4: Color(red: 0.0, green: 0.0, blue: 1.0), // Blue
        5: Color(red: 0.0, green: 1.0, blue: 1.0), // Cyan
        6: Color(red: 1.0, green: 0.0, blue: 1.0), // Magenta
        7: Color(red: 1.0, green: 1.0, blue: 0.0)  // Yellow
    ]

    func parse(url: URL) throws -> CGMDocument {

        let data = try Data(contentsOf: url)
        var reader = CGMDataReader(data: data)

        var document = CGMDocument()

        while !reader.isAtEnd {

            guard let header = reader.readUInt16() else {
                break
            }

            let elementClass = Int((header & 0xF000) >> 12)
            let elementId = Int((header & 0x0FE0) >> 5)

            var parameterLength = Int(header & 0x001F)

            if parameterLength == 31 {
                guard let longLength = reader.readUInt16() else {
                    break
                }

                parameterLength = Int(longLength & 0x7FFF)
            }

            let parameterData = reader.readData(length: parameterLength)

            if parameterLength % 2 != 0 {
                reader.skip(bytes: 1)
            }

            if elementClass == 0 && elementId == 2 {
                break
            }

            parseElement(
                elementClass: elementClass,
                elementId: elementId,
                data: parameterData,
                document: &document
            )
        }

        return document
    }

    private func parseElement(
        elementClass: Int,
        elementId: Int,
        data: Data,
        document: inout CGMDocument
    ) {
//        print("Class=\(elementClass) Id=\(elementId)")

        switch (elementClass, elementId) {

        // VDC EXTENT
        case (2, 6):
            if let rect = parseVDCExtent(data: data) {
                document.vdcExtent = rect
            }

        // POLYLINE
        case (4, 1):
            let points = parsePoints(data: data)

            if points.count >= 2 {
                document.primitives.append(
                    .polyline(points, currentStyle)
                )
            }
            // DISJOINT POLYLINE
            case (4, 2):
                let points = parsePoints(data: data)

                var index = 0

                while index + 1 < points.count {
                    let segment = [
                        points[index],
                        points[index + 1]
                    ]

                    document.primitives.append(
                        .polyline(segment, currentStyle)
                    )

                    index += 2
                }
            // POLYMARKER
            case (4, 3):
                let points = parsePoints(data: data)

                if !points.isEmpty {
                    document.primitives.append(
                        .markers(points, currentStyle)
                    )
                }
        // TEXT
        case (4, 4):
            if let textPrimitive = parseText(data: data) {
                document.primitives.append(textPrimitive)
            }

        // RESTRICTED TEXT
        case (4, 5):
            if let textPrimitive = parseRestrictedText(data: data) {
                document.primitives.append(textPrimitive)
            }

        // APPEND TEXT
        case (4, 6):
            // APPEND_TEXT should normally merge with previous TEXT.
            // Ignored now to avoid duplicate/garbage text.
            break

        // POLYGON
        case (4, 7):
            let points = parsePoints(data: data)

            if points.count >= 3 {
                document.primitives.append(
                    .polygon(points, currentStyle)
                )
            }
            
            // POLYSET - simplified
            case (4, 8):
                print("POLYSET FOUND")
                let points = parsePolysetPoints(data: data)

                if points.count >= 3 {
                    document.primitives.append(
                        .polygon(points, currentStyle)
                    )
                }

        // CELL ARRAY
        case (4, 9):

            if let cellArray = parseCellArray(data: data) {
                document.primitives.append(cellArray)
            }


        // RECTANGLE
        case (4, 11):
            if let rect = parseRectangle(data: data) {
                document.primitives.append(
                    .rectangle(rect, currentStyle)
                )
            }

        // CIRCLE
        case (4, 12):
            if let circle = parseCircle(data: data) {
                document.primitives.append(circle)
            }

        // CIRCULAR ARC 3 POINT
        case (4, 13):
            if let arc = parseCircularArc3Point(data: data, closeType: nil) {
                document.primitives.append(arc)
            }

        // CIRCULAR ARC 3 POINT CLOSE
        case (4, 14):
            if let arc = parseCircularArc3PointClose(data: data) {
                document.primitives.append(arc)
            }

        // CIRCULAR ARC CENTER
        case (4, 15):
            if let arc = parseCircularArcCenter(data: data, hasClose: false) {
                document.primitives.append(arc)
            }

        // CIRCULAR ARC CENTER CLOSE
        case (4, 16):
            if let arc = parseCircularArcCenter(data: data, hasClose: true) {
                document.primitives.append(arc)
            }

        // ELLIPSE
        case (4, 17):
            if let ellipse = parseEllipse(data: data) {
                document.primitives.append(ellipse)
            }

            // ELLIPTICAL ARC
            case (4, 18):
                if let arc = parseEllipticalArc(data: data, hasClose: false) {
                    document.primitives.append(arc)
                }

            // ELLIPTICAL ARC CLOSE
            case (4, 19):
                if let arc = parseEllipticalArc(data: data, hasClose: true) {
                    document.primitives.append(arc)
                }
        // LINE COLOUR
        case (5, 4):
            currentStyle.lineColor = parseColor(data: data)
            // LINE WIDTH
            case (5, 3):
                currentStyle.lineWidth = parseSizeValue(data: data)
                print("LINE WIDTH = \(currentStyle.lineWidth)")
            
            // MARKER SIZE
            case (5, 7):
                currentStyle.markerSize = parseSizeValue(data: data)

            // EDGE WIDTH
            case (5, 28):
                currentStyle.edgeWidth = parseSizeValue(data: data)
                print("EDGE WIDTH = \(currentStyle.edgeWidth)")
            
        // TEXT COLOUR
        case (5, 14):
            currentStyle.textColor = parseColor(data: data)

        // CHARACTER HEIGHT
        case (5, 15):
            currentStyle.characterHeight = parseCharacterHeight(data: data)

        // CHARACTER ORIENTATION
        case (5, 16):
            currentStyle.textOrientation = parseCharacterOrientation(data: data)

        // INTERIOR STYLE
        case (5, 22):
            currentStyle.interiorStyle = parseInteriorStyle(data: data)

        // FILL COLOUR
        case (5, 23):
            currentStyle.fillColor = parseColor(data: data)

        // EDGE COLOUR
        case (5, 29):
            currentStyle.edgeColor = parseColor(data: data)

        // EDGE VISIBILITY
        case (5, 30):
            currentStyle.edgeVisible = parseEdgeVisibility(data: data)

        // COLOUR TABLE
        case (5, 34):
            parseColorTable(data: data)

        default:
            break
        }
    }
    
    private func parseSizeValue(data: Data) -> CGFloat {

        var reader = CGMDataReader(data: data)

        guard let rawValue = reader.readInt16() else {
            return 1
        }

        let value = CGFloat(abs(Int(rawValue)))

        print("RAW WIDTH = \(value)")

        // Convert CGM logical width to screen width
        return max(1, value / 10.0)
    }
        
    
    private func hexDump(_ data: Data) -> String {
        data.map {
            String(format: "%02X", $0)
        }
        .joined(separator: " ")
    }

    private func parseVDCExtent(data: Data) -> CGRect? {

        var reader = CGMDataReader(data: data)

        guard
            let x1 = reader.readInt16(),
            let y1 = reader.readInt16(),
            let x2 = reader.readInt16(),
            let y2 = reader.readInt16()
        else {
            return nil
        }

        let minX = CGFloat(min(x1, x2))
        let minY = CGFloat(min(y1, y2))
        let maxX = CGFloat(max(x1, x2))
        let maxY = CGFloat(max(y1, y2))

        return CGRect(
            x: minX,
            y: minY,
            width: maxX - minX,
            height: maxY - minY
        )
    }

    private func parsePolysetPoints(data: Data) -> [CGPoint] {

        var reader = CGMDataReader(data: data)
        var points: [CGPoint] = []

        while !reader.isAtEnd {

            guard
                let x = reader.readInt16(),
                let y = reader.readInt16()
            else {
                break
            }

            points.append(
                CGPoint(
                    x: CGFloat(x),
                    y: CGFloat(y)
                )
            )

            // Polyset usually has edge visibility flag after each point.
            // Skip it if available.
            if !reader.isAtEnd {
                _ = reader.readUInt16()
            }
        }

        return points
    }
    
    private func parsePoints(data: Data) -> [CGPoint] {

        var reader = CGMDataReader(data: data)
        var points: [CGPoint] = []

        while !reader.isAtEnd {
            guard
                let x = reader.readInt16(),
                let y = reader.readInt16()
            else {
                break
            }

            points.append(
                CGPoint(
                    x: CGFloat(x),
                    y: CGFloat(y)
                )
            )
        }

        return points
    }

    private func parseRectangle(data: Data) -> CGRect? {

        var reader = CGMDataReader(data: data)

        guard
            let x1 = reader.readInt16(),
            let y1 = reader.readInt16(),
            let x2 = reader.readInt16(),
            let y2 = reader.readInt16()
        else {
            return nil
        }

        let minX = CGFloat(min(x1, x2))
        let minY = CGFloat(min(y1, y2))
        let maxX = CGFloat(max(x1, x2))
        let maxY = CGFloat(max(y1, y2))

        return CGRect(
            x: minX,
            y: minY,
            width: maxX - minX,
            height: maxY - minY
        )
    }

    private func parseCircle(data: Data) -> CGMPrimitive? {

        var reader = CGMDataReader(data: data)

        guard
            let x = reader.readInt16(),
            let y = reader.readInt16(),
            let radius = reader.readInt16()
        else {
            return nil
        }

        return .circle(
            center: CGPoint(
                x: CGFloat(x),
                y: CGFloat(y)
            ),
            radius: CGFloat(abs(Int(radius))),
            currentStyle
        )
    }

    private func parseEllipse(data: Data) -> CGMPrimitive? {

        var reader = CGMDataReader(data: data)

        guard
            let cx = reader.readInt16(),
            let cy = reader.readInt16(),
            let x1 = reader.readInt16(),
            let y1 = reader.readInt16(),
            let x2 = reader.readInt16(),
            let y2 = reader.readInt16()
        else {
            return nil
        }

        let center = CGPoint(
            x: CGFloat(cx),
            y: CGFloat(cy)
        )

        let radiusX = hypot(
            CGFloat(x1 - cx),
            CGFloat(y1 - cy)
        )

        let radiusY = hypot(
            CGFloat(x2 - cx),
            CGFloat(y2 - cy)
        )

        return .ellipse(
            center: center,
            radiusX: radiusX,
            radiusY: radiusY,
            currentStyle
        )
    }

    private func parseEllipticalArc(
        data: Data,
        hasClose: Bool
    ) -> CGMPrimitive? {

        var reader = CGMDataReader(data: data)

        guard
            let cx = reader.readInt16(),
            let cy = reader.readInt16(),

            let x1 = reader.readInt16(),
            let y1 = reader.readInt16(),

            let x2 = reader.readInt16(),
            let y2 = reader.readInt16(),

            let startX = reader.readInt16(),
            let startY = reader.readInt16(),

            let endX = reader.readInt16(),
            let endY = reader.readInt16()
        else {
            return nil
        }

        var closeType: Int? = nil

        if hasClose {
            closeType = Int(reader.readUInt16() ?? 0)
        }

        let center = CGPoint(
            x: CGFloat(cx),
            y: CGFloat(cy)
        )

        let radiusX = hypot(
            CGFloat(x1 - cx),
            CGFloat(y1 - cy)
        )

        let radiusY = hypot(
            CGFloat(x2 - cx),
            CGFloat(y2 - cy)
        )

        let startAngle = atan2(
            CGFloat(startY - cy),
            CGFloat(startX - cx)
        )

        let endAngle = atan2(
            CGFloat(endY - cy),
            CGFloat(endX - cx)
        )

        return .ellipticalArc(
            center: center,
            radiusX: radiusX,
            radiusY: radiusY,
            startAngle: startAngle,
            endAngle: endAngle,
            closeType: closeType,
            currentStyle
        )
    }
    
    private func parseText(data: Data) -> CGMPrimitive? {

        var reader = CGMDataReader(data: data)

        guard
            let x = reader.readInt16(),
            let y = reader.readInt16()
        else {
            return nil
        }

        // Final flag
        _ = reader.readUInt16()

        guard let text = reader.readString(),
              !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        else {
            return nil
        }

        return .text(
            position: CGPoint(
                x: CGFloat(x),
                y: CGFloat(y)
            ),
            value: text,
            currentStyle
        )
    }

    private func parseRestrictedText(data: Data) -> CGMPrimitive? {

        var reader = CGMDataReader(data: data)

        // Simplified restricted text:
        // box width/height + position + final flag + string
        guard
            let _ = reader.readInt16(),
            let _ = reader.readInt16(),
            let x = reader.readInt16(),
            let y = reader.readInt16()
        else {
            return nil
        }

        _ = reader.readUInt16()

        guard let text = reader.readString(),
              !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        else {
            return nil
        }

        return .text(
            position: CGPoint(
                x: CGFloat(x),
                y: CGFloat(y)
            ),
            value: text,
            currentStyle
        )
    }

    private func parseCircularArcCenter(
        data: Data,
        hasClose: Bool
    ) -> CGMPrimitive? {

        var reader = CGMDataReader(data: data)

        guard
            let cx = reader.readInt16(),
            let cy = reader.readInt16(),
            let startDX = reader.readInt16(),
            let startDY = reader.readInt16(),
            let endDX = reader.readInt16(),
            let endDY = reader.readInt16(),
            let radiusValue = reader.readInt16()
        else {
            return nil
        }

        var closeType: Int? = nil

        if hasClose {
            closeType = Int(reader.readUInt16() ?? 0)
        }

        let startAngle = atan2(
            CGFloat(startDY),
            CGFloat(startDX)
        )

        let endAngle = atan2(
            CGFloat(endDY),
            CGFloat(endDX)
        )

        return .circularArc(
            center: CGPoint(
                x: CGFloat(cx),
                y: CGFloat(cy)
            ),
            radius: CGFloat(abs(Int(radiusValue))),
            startAngle: startAngle,
            endAngle: endAngle,
            closeType: closeType,
            currentStyle
        )
    }

    private func parseCircularArc3Point(
        data: Data,
        closeType: Int?
    ) -> CGMPrimitive? {

        var reader = CGMDataReader(data: data)

        guard
            let x1 = reader.readInt16(),
            let y1 = reader.readInt16(),
            let x2 = reader.readInt16(),
            let y2 = reader.readInt16(),
            let x3 = reader.readInt16(),
            let y3 = reader.readInt16()
        else {
            return nil
        }

        let p1 = CGPoint(x: CGFloat(x1), y: CGFloat(y1))
        let p2 = CGPoint(x: CGFloat(x2), y: CGFloat(y2))
        let p3 = CGPoint(x: CGFloat(x3), y: CGFloat(y3))

        guard let circle = circleFrom3Points(p1, p2, p3) else {
            return nil
        }

        let startAngle = atan2(
            p1.y - circle.center.y,
            p1.x - circle.center.x
        )

        let endAngle = atan2(
            p3.y - circle.center.y,
            p3.x - circle.center.x
        )

        return .circularArc(
            center: circle.center,
            radius: circle.radius,
            startAngle: startAngle,
            endAngle: endAngle,
            closeType: closeType,
            currentStyle
        )
    }

    private func parseCircularArc3PointClose(
        data: Data
    ) -> CGMPrimitive? {

        guard data.count >= 14 else {
            return parseCircularArc3Point(
                data: data,
                closeType: nil
            )
        }

        let pointData = data.subdata(in: 0..<12)
        let closeData = data.subdata(in: 12..<data.count)

        var closeReader = CGMDataReader(data: closeData)
        let closeType = Int(closeReader.readUInt16() ?? 0)

        return parseCircularArc3Point(
            data: pointData,
            closeType: closeType
        )
    }

    private func circleFrom3Points(
        _ p1: CGPoint,
        _ p2: CGPoint,
        _ p3: CGPoint
    ) -> (center: CGPoint, radius: CGFloat)? {

        let a = p2.x - p1.x
        let b = p2.y - p1.y
        let c = p3.x - p1.x
        let d = p3.y - p1.y

        let e = a * (p1.x + p2.x) + b * (p1.y + p2.y)
        let f = c * (p1.x + p3.x) + d * (p1.y + p3.y)

        let g = 2 * (a * (p3.y - p2.y) - b * (p3.x - p2.x))

        if abs(g) < 0.001 {
            return nil
        }

        let cx = (d * e - b * f) / g
        let cy = (a * f - c * e) / g

        let center = CGPoint(x: cx, y: cy)

        let radius = hypot(
            center.x - p1.x,
            center.y - p1.y
        )

        return (center, radius)
    }

    private func parseCellArray(data: Data) -> CGMPrimitive? {

        var reader = CGMDataReader(data: data)

        guard
            let pX = reader.readInt16(),
            let pY = reader.readInt16(),
            let qX = reader.readInt16(),
            let qY = reader.readInt16(),
            let rX = reader.readInt16(),
            let rY = reader.readInt16(),
            let columnsValue = reader.readUInt16(),
            let rowsValue = reader.readUInt16()
        else {
            return nil
        }

        let columns = max(1, Int(columnsValue))
        let rows = max(1, Int(rowsValue))

        let minX = min(CGFloat(pX), CGFloat(qX), CGFloat(rX))
        let maxX = max(CGFloat(pX), CGFloat(qX), CGFloat(rX))
        let minY = min(CGFloat(pY), CGFloat(qY), CGFloat(rY))
        let maxY = max(CGFloat(pY), CGFloat(qY), CGFloat(rY))

        let expectedColorCount = columns * rows

        var colors: [Color] = []
        var rawIndexes: [UInt8] = []

        while !reader.isAtEnd && colors.count < expectedColorCount {

            guard let rawIndex = reader.readByte() else {
                break
            }

            rawIndexes.append(rawIndex)

            let color = colorTable[Int(rawIndex)] ?? Color.black
            colors.append(color)
        }

        print("CELL ARRAY FOUND")
        print("columns = \(columns)")
        print("rows = \(rows)")
        print("raw color indexes = \(rawIndexes)")
        print("colors = \(colors.count)")
        print("bounds = \(minX), \(minY), \(maxX), \(maxY)")

        return .cellArray(
            origin: CGPoint(
                x: minX,
                y: minY
            ),
            width: maxX - minX,
            height: maxY - minY,
            columns: columns,
            rows: rows,
            colors: colors
        )
    }

    private func parseInteriorStyle(data: Data) -> CGMInteriorStyle {

        var reader = CGMDataReader(data: data)

        guard let style = reader.readUInt16() else {
            return .hollow
        }

        if style == 1 {
            return .solid
        } else {
            return .hollow
        }
    }

    private func parseCharacterHeight(data: Data) -> CGFloat {

        var reader = CGMDataReader(data: data)

        guard let value = reader.readInt16() else {
            return currentStyle.characterHeight
        }

        return CGFloat(abs(Int(value)))
    }

    private func parseCharacterOrientation(data: Data) -> CGMTextOrientation {

        var reader = CGMDataReader(data: data)

        guard
            let upX = reader.readInt16(),
            let upY = reader.readInt16(),
            let baseX = reader.readInt16(),
            let baseY = reader.readInt16()
        else {
            return currentStyle.textOrientation
        }

        return CGMTextOrientation(
            up: CGPoint(
                x: CGFloat(upX),
                y: CGFloat(upY)
            ),
            base: CGPoint(
                x: CGFloat(baseX),
                y: CGFloat(baseY)
            )
        )
    }

    private func parseEdgeVisibility(data: Data) -> Bool {

        var reader = CGMDataReader(data: data)

        guard let value = reader.readUInt16() else {
            return true
        }

        return value != 0
    }

    private func parseColor(data: Data) -> Color {

        if data.count == 1 {
            let index = Int(data[0])
            return colorTable[index] ?? .black
        }

        if data.count == 2 {
            var reader = CGMDataReader(data: data)
            let index = Int(reader.readUInt16() ?? 1)
            return colorTable[index] ?? .black
        }

        if data.count >= 3 {
            let r = Double(data[0]) / 255.0
            let g = Double(data[1]) / 255.0
            let b = Double(data[2]) / 255.0

            return Color(
                red: r,
                green: g,
                blue: b
            )
        }

        return .black
    }

    private func parseColorTable(data: Data) {

        var reader = CGMDataReader(data: data)

        // In this CGM file:
        // Length = 25 means:
        // 1 byte first index + 8 RGB colors * 3 bytes
        guard let firstIndexByte = reader.readByte() else {
            return
        }

        var index = Int(firstIndexByte)

        while !reader.isAtEnd {

            guard
                let r = reader.readByte(),
                let g = reader.readByte(),
                let b = reader.readByte()
            else {
                break
            }

            let color = Color(
                red: Double(r) / 255.0,
                green: Double(g) / 255.0,
                blue: Double(b) / 255.0
            )

            colorTable[index] = color


            index += 1
        }
    }
}
