//
//  DisplayListModels.swift
//  HTMLRender
//
//  Created by Attili Naga Srinivasu on 29/07/26.
//

import Foundation
import CoreGraphics
import SwiftUI

struct CGPointDTO: Codable {
    let x: Double
    let y: Double

    init(_ point: CGPoint) {
        self.x = Double(point.x)
        self.y = Double(point.y)
    }

    var cgPoint: CGPoint {
        CGPoint(x: x, y: y)
    }
}

struct CGRectDTO: Codable {
    let x: Double
    let y: Double
    let width: Double
    let height: Double

    init(_ rect: CGRect) {
        self.x = Double(rect.origin.x)
        self.y = Double(rect.origin.y)
        self.width = Double(rect.size.width)
        self.height = Double(rect.size.height)
    }

    var cgRect: CGRect {
        CGRect(
            x: x,
            y: y,
            width: width,
            height: height
        )
    }
}

struct ColorDTO: Codable {
    let red: Double
    let green: Double
    let blue: Double
    let alpha: Double

    init(
        red: Double,
        green: Double,
        blue: Double,
        alpha: Double = 1.0
    ) {
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = alpha
    }

    var swiftUIColor: Color {
        Color(
            red: red,
            green: green,
            blue: blue,
            opacity: alpha
        )
    }

    static let black = ColorDTO(red: 0, green: 0, blue: 0)
    static let white = ColorDTO(red: 1, green: 1, blue: 1)
    static let clear = ColorDTO(red: 0, green: 0, blue: 0, alpha: 0)
    static let blue = ColorDTO(red: 0, green: 0, blue: 1)
    static let yellow = ColorDTO(red: 1, green: 1, blue: 0)
}

enum DisplayInteriorStyle: String, Codable {
    case hollow
    case solid
}

struct DisplayStyle: Codable {
    var lineColor: ColorDTO
    var fillColor: ColorDTO
    var textColor: ColorDTO
    var edgeColor: ColorDTO

    var interiorStyle: DisplayInteriorStyle

    var lineWidth: Double
    var edgeWidth: Double
    var markerSize: Double
    var characterHeight: Double

    var edgeVisible: Bool

    var textBaseX: Double
    var textBaseY: Double

    static let `default` = DisplayStyle(
        lineColor: .black,
        fillColor: .clear,
        textColor: .black,
        edgeColor: .black,
        interiorStyle: .hollow,
        lineWidth: 1,
        edgeWidth: 1,
        markerSize: 5,
        characterHeight: 24,
        edgeVisible: true,
        textBaseX: 1,
        textBaseY: 0
    )
}

enum DisplayCommand: Codable {

    case polyline(
        points: [CGPointDTO],
        style: DisplayStyle
    )

    case polygon(
        points: [CGPointDTO],
        style: DisplayStyle
    )

    case rectangle(
        rect: CGRectDTO,
        style: DisplayStyle
    )

    case circle(
        center: CGPointDTO,
        radius: Double,
        style: DisplayStyle
    )

    case ellipse(
        center: CGPointDTO,
        radiusX: Double,
        radiusY: Double,
        style: DisplayStyle
    )

    case text(
        position: CGPointDTO,
        value: String,
        style: DisplayStyle
    )

    case circularArc(
        center: CGPointDTO,
        radius: Double,
        startAngle: Double,
        endAngle: Double,
        closeType: Int?,
        style: DisplayStyle
    )

    case ellipticalArc(
        center: CGPointDTO,
        radiusX: Double,
        radiusY: Double,
        startAngle: Double,
        endAngle: Double,
        closeType: Int?,
        style: DisplayStyle
    )

    case cellArray(
        origin: CGPointDTO,
        width: Double,
        height: Double,
        columns: Int,
        rows: Int,
        colors: [ColorDTO]
    )

    case markers(
        points: [CGPointDTO],
        style: DisplayStyle
    )
}

struct CGMDisplayList: Codable {
    let figureId: String
    let sourceFileName: String
    let bounds: CGRectDTO
    let commands: [DisplayCommand]
}
