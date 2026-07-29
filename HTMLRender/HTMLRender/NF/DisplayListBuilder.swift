//
//  DisplayListBuilder.swift
//  HTMLRender
//
//  Created by Attili Naga Srinivasu on 29/07/26.
//

import Foundation
import CoreGraphics
import SwiftUI

final class DisplayListBuilder {

    func build(
        document: CGMDocument,
        figureId: String,
        sourceFileName: String
    ) -> CGMDisplayList {

        var commands: [DisplayCommand] = []

        for primitive in document.primitives {

            switch primitive {

            case .polyline(let points, let style):
                commands.append(
                    .polyline(
                        points: points.map { CGPointDTO($0) },
                        style: mapStyle(style)
                    )
                )

            case .polygon(let points, let style):
                commands.append(
                    .polygon(
                        points: points.map { CGPointDTO($0) },
                        style: mapStyle(style)
                    )
                )

            case .rectangle(let rect, let style):
                commands.append(
                    .rectangle(
                        rect: CGRectDTO(rect),
                        style: mapStyle(style)
                    )
                )

            case .circle(let center, let radius, let style):
                commands.append(
                    .circle(
                        center: CGPointDTO(center),
                        radius: Double(radius),
                        style: mapStyle(style)
                    )
                )

            case .ellipse(let center, let radiusX, let radiusY, let style):
                commands.append(
                    .ellipse(
                        center: CGPointDTO(center),
                        radiusX: Double(radiusX),
                        radiusY: Double(radiusY),
                        style: mapStyle(style)
                    )
                )

            case .text(let position, let value, let style):
                commands.append(
                    .text(
                        position: CGPointDTO(position),
                        value: value,
                        style: mapStyle(style)
                    )
                )

            case .circularArc(
                let center,
                let radius,
                let startAngle,
                let endAngle,
                let closeType,
                let style
            ):
                commands.append(
                    .circularArc(
                        center: CGPointDTO(center),
                        radius: Double(radius),
                        startAngle: Double(startAngle),
                        endAngle: Double(endAngle),
                        closeType: closeType,
                        style: mapStyle(style)
                    )
                )

            case .ellipticalArc(
                let center,
                let radiusX,
                let radiusY,
                let startAngle,
                let endAngle,
                let closeType,
                let style
            ):
                commands.append(
                    .ellipticalArc(
                        center: CGPointDTO(center),
                        radiusX: Double(radiusX),
                        radiusY: Double(radiusY),
                        startAngle: Double(startAngle),
                        endAngle: Double(endAngle),
                        closeType: closeType,
                        style: mapStyle(style)
                    )
                )

            case .cellArray(
                let origin,
                let width,
                let height,
                let columns,
                let rows,
                let colors
            ):
                commands.append(
                    .cellArray(
                        origin: CGPointDTO(origin),
                        width: Double(width),
                        height: Double(height),
                        columns: columns,
                        rows: rows,
                        colors: colors.map { _ in
                            // Current parser uses SwiftUI Color.
                            // Exact RGB extraction from Color is not reliable.
                            // For now keep white fallback for cell array.
                            ColorDTO.white
                        }
                    )
                )

            case .markers(let points, let style):
                commands.append(
                    .markers(
                        points: points.map { CGPointDTO($0) },
                        style: mapStyle(style)
                    )
                )
            }
        }

        let bounds = document.vdcExtent ?? calculateBounds(commands: commands)

        return CGMDisplayList(
            figureId: figureId,
            sourceFileName: sourceFileName,
            bounds: CGRectDTO(bounds),
            commands: commands
        )
    }

    private func mapStyle(
        _ style: CGMGraphicStyle
    ) -> DisplayStyle {

        // SwiftUI Color cannot be reliably decomposed into RGB.
        // So for now we map semantic working colors based on your current renderer behavior.
        // Later we should store ColorDTO directly in CGMGraphicStyle.

        return DisplayStyle(
            lineColor: .black,
            fillColor: .blue,
            textColor: .black,
            edgeColor: .yellow,
            interiorStyle: style.interiorStyle == .solid ? .solid : .hollow,
            lineWidth: Double(style.lineWidth),
            edgeWidth: Double(style.edgeWidth),
            markerSize: Double(style.markerSize),
            characterHeight: Double(style.characterHeight),
            edgeVisible: style.edgeVisible,
            textBaseX: Double(style.textOrientation.base.x),
            textBaseY: Double(style.textOrientation.base.y)
        )
    }

    private func calculateBounds(
        commands: [DisplayCommand]
    ) -> CGRect {

        var points: [CGPoint] = []

        for command in commands {

            switch command {

            case .polyline(let pts, _):
                points.append(contentsOf: pts.map { $0.cgPoint })

            case .polygon(let pts, _):
                points.append(contentsOf: pts.map { $0.cgPoint })

            case .rectangle(let rect, _):
                let r = rect.cgRect
                points.append(CGPoint(x: r.minX, y: r.minY))
                points.append(CGPoint(x: r.maxX, y: r.maxY))

            case .circle(let center, let radius, _):
                let c = center.cgPoint
                let r = CGFloat(radius)
                points.append(CGPoint(x: c.x - r, y: c.y - r))
                points.append(CGPoint(x: c.x + r, y: c.y + r))

            case .ellipse(let center, let radiusX, let radiusY, _):
                let c = center.cgPoint
                points.append(CGPoint(x: c.x - CGFloat(radiusX), y: c.y - CGFloat(radiusY)))
                points.append(CGPoint(x: c.x + CGFloat(radiusX), y: c.y + CGFloat(radiusY)))

            case .text(let position, _, _):
                points.append(position.cgPoint)

            case .circularArc(let center, let radius, _, _, _, _):
                let c = center.cgPoint
                let r = CGFloat(radius)
                points.append(CGPoint(x: c.x - r, y: c.y - r))
                points.append(CGPoint(x: c.x + r, y: c.y + r))

            case .ellipticalArc(let center, let radiusX, let radiusY, _, _, _, _):
                let c = center.cgPoint
                points.append(CGPoint(x: c.x - CGFloat(radiusX), y: c.y - CGFloat(radiusY)))
                points.append(CGPoint(x: c.x + CGFloat(radiusX), y: c.y + CGFloat(radiusY)))

            case .cellArray(let origin, let width, let height, _, _, _):
                let o = origin.cgPoint
                points.append(o)
                points.append(CGPoint(x: o.x + CGFloat(width), y: o.y + CGFloat(height)))

            case .markers(let pts, _):
                points.append(contentsOf: pts.map { $0.cgPoint })
            }
        }

        guard let first = points.first else {
            return CGRect(x: 0, y: 0, width: 100, height: 100)
        }

        var minX = first.x
        var minY = first.y
        var maxX = first.x
        var maxY = first.y

        for point in points {
            minX = min(minX, point.x)
            minY = min(minY, point.y)
            maxX = max(maxX, point.x)
            maxY = max(maxY, point.y)
        }

        return CGRect(
            x: minX,
            y: minY,
            width: maxX - minX,
            height: maxY - minY
        )
    }
}
