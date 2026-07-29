//
//  DisplayListRenderer.swift
//  HTMLRender
//
//  Created by Attili Naga Srinivasu on 29/07/26.
//

import SwiftUI
import CoreGraphics

struct DisplayListRenderer {

    static func render(
        displayList: CGMDisplayList,
        context: inout GraphicsContext,
        size: CGSize
    ) {

        let bounds = displayList.bounds.cgRect

        guard bounds.width > 0, bounds.height > 0 else {
            return
        }

        let scaleX = size.width / bounds.width
        let scaleY = size.height / bounds.height
        let scale = min(scaleX, scaleY) * 0.88

        let drawingWidth = bounds.width * scale
        let drawingHeight = bounds.height * scale

        let offsetX = (size.width - drawingWidth) / 2
        let offsetY = (size.height - drawingHeight) / 2

        func mapPoint(_ point: CGPoint) -> CGPoint {
            let x = ((point.x - bounds.minX) * scale) + offsetX
            let y = ((bounds.maxY - point.y) * scale) + offsetY
            return CGPoint(x: x, y: y)
        }

        for command in displayList.commands {

            switch command {

            case .polyline(let points, let style):
                drawPolyline(
                    points: points.map { $0.cgPoint },
                    style: style,
                    context: &context,
                    mapPoint: mapPoint
                )

            case .polygon(let points, let style):
                drawPolygon(
                    points: points.map { $0.cgPoint },
                    style: style,
                    context: &context,
                    mapPoint: mapPoint
                )

            case .rectangle(let rect, let style):
                drawRectangle(
                    rect: rect.cgRect,
                    style: style,
                    context: &context,
                    mapPoint: mapPoint
                )

            case .circle(let center, let radius, let style):
                drawCircle(
                    center: center.cgPoint,
                    radius: CGFloat(radius),
                    scale: scale,
                    style: style,
                    context: &context,
                    mapPoint: mapPoint
                )

            case .ellipse(let center, let radiusX, let radiusY, let style):
                drawEllipse(
                    center: center.cgPoint,
                    radiusX: CGFloat(radiusX),
                    radiusY: CGFloat(radiusY),
                    scale: scale,
                    style: style,
                    context: &context,
                    mapPoint: mapPoint
                )

            case .text(let position, let value, let style):
                drawText(
                    position: position.cgPoint,
                    value: value,
                    style: style,
                    scale: scale,
                    context: &context,
                    mapPoint: mapPoint
                )

            case .circularArc(
                let center,
                let radius,
                let startAngle,
                let endAngle,
                let closeType,
                let style
            ):
                drawCircularArc(
                    center: center.cgPoint,
                    radius: CGFloat(radius),
                    startAngle: CGFloat(startAngle),
                    endAngle: CGFloat(endAngle),
                    closeType: closeType,
                    style: style,
                    scale: scale,
                    context: &context,
                    mapPoint: mapPoint
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
                drawEllipticalArc(
                    center: center.cgPoint,
                    radiusX: CGFloat(radiusX),
                    radiusY: CGFloat(radiusY),
                    startAngle: CGFloat(startAngle),
                    endAngle: CGFloat(endAngle),
                    closeType: closeType,
                    style: style,
                    scale: scale,
                    context: &context,
                    mapPoint: mapPoint
                )

            case .cellArray(
                let origin,
                let width,
                let height,
                let columns,
                let rows,
                let colors
            ):
                drawCellArray(
                    origin: origin.cgPoint,
                    width: CGFloat(width),
                    height: CGFloat(height),
                    columns: columns,
                    rows: rows,
                    colors: colors,
                    scale: scale,
                    context: &context,
                    mapPoint: mapPoint
                )

            case .markers(let points, let style):
                drawMarkers(
                    points: points.map { $0.cgPoint },
                    style: style,
                    context: &context,
                    mapPoint: mapPoint
                )
            }
        }
    }

    private static func drawPolyline(
        points: [CGPoint],
        style: DisplayStyle,
        context: inout GraphicsContext,
        mapPoint: (CGPoint) -> CGPoint
    ) {

        guard let first = points.first else {
            return
        }

        var path = Path()
        path.move(to: mapPoint(first))

        for point in points.dropFirst() {
            path.addLine(to: mapPoint(point))
        }

        context.stroke(
            path,
            with: .color(style.lineColor.swiftUIColor),
            lineWidth: CGFloat(style.lineWidth)
        )
    }

    private static func drawPolygon(
        points: [CGPoint],
        style: DisplayStyle,
        context: inout GraphicsContext,
        mapPoint: (CGPoint) -> CGPoint
    ) {

        guard let first = points.first else {
            return
        }

        var path = Path()
        path.move(to: mapPoint(first))

        for point in points.dropFirst() {
            path.addLine(to: mapPoint(point))
        }

        path.closeSubpath()

        drawClosedPath(
            path,
            style: style,
            context: &context
        )
    }

    private static func drawRectangle(
        rect: CGRect,
        style: DisplayStyle,
        context: inout GraphicsContext,
        mapPoint: (CGPoint) -> CGPoint
    ) {

        let topLeft = mapPoint(
            CGPoint(
                x: rect.minX,
                y: rect.maxY
            )
        )

        let bottomRight = mapPoint(
            CGPoint(
                x: rect.maxX,
                y: rect.minY
            )
        )

        let mappedRect = CGRect(
            x: topLeft.x,
            y: topLeft.y,
            width: bottomRight.x - topLeft.x,
            height: bottomRight.y - topLeft.y
        )

        drawClosedPath(
            Path(mappedRect),
            style: style,
            context: &context
        )
    }

    private static func drawCircle(
        center: CGPoint,
        radius: CGFloat,
        scale: CGFloat,
        style: DisplayStyle,
        context: inout GraphicsContext,
        mapPoint: (CGPoint) -> CGPoint
    ) {

        let mappedCenter = mapPoint(center)
        let mappedRadius = radius * scale

        let rect = CGRect(
            x: mappedCenter.x - mappedRadius,
            y: mappedCenter.y - mappedRadius,
            width: mappedRadius * 2,
            height: mappedRadius * 2
        )

        drawClosedPath(
            Path(ellipseIn: rect),
            style: style,
            context: &context
        )
    }

    private static func drawEllipse(
        center: CGPoint,
        radiusX: CGFloat,
        radiusY: CGFloat,
        scale: CGFloat,
        style: DisplayStyle,
        context: inout GraphicsContext,
        mapPoint: (CGPoint) -> CGPoint
    ) {

        let mappedCenter = mapPoint(center)

        let rect = CGRect(
            x: mappedCenter.x - radiusX * scale,
            y: mappedCenter.y - radiusY * scale,
            width: radiusX * scale * 2,
            height: radiusY * scale * 2
        )

        drawClosedPath(
            Path(ellipseIn: rect),
            style: style,
            context: &context
        )
    }

    private static func drawCircularArc(
        center: CGPoint,
        radius: CGFloat,
        startAngle: CGFloat,
        endAngle: CGFloat,
        closeType: Int?,
        style: DisplayStyle,
        scale: CGFloat,
        context: inout GraphicsContext,
        mapPoint: (CGPoint) -> CGPoint
    ) {

        let mappedCenter = mapPoint(center)
        let mappedRadius = radius * scale

        var path = Path()

        path.addArc(
            center: mappedCenter,
            radius: mappedRadius,
            startAngle: Angle(radians: Double(-startAngle)),
            endAngle: Angle(radians: Double(-endAngle)),
            clockwise: true
        )

        if closeType != nil {
            path.addLine(to: mappedCenter)
            path.closeSubpath()

            drawClosedPath(
                path,
                style: style,
                context: &context
            )
        } else {
            context.stroke(
                path,
                with: .color(style.lineColor.swiftUIColor),
                lineWidth: CGFloat(style.lineWidth)
            )
        }
    }

    private static func drawEllipticalArc(
        center: CGPoint,
        radiusX: CGFloat,
        radiusY: CGFloat,
        startAngle: CGFloat,
        endAngle: CGFloat,
        closeType: Int?,
        style: DisplayStyle,
        scale: CGFloat,
        context: inout GraphicsContext,
        mapPoint: (CGPoint) -> CGPoint
    ) {

        let mappedCenter = mapPoint(center)

        let mappedRadiusX = radiusX * scale
        let mappedRadiusY = radiusY * scale

        let steps = 64
        var path = Path()

        for index in 0...steps {
            let t = CGFloat(index) / CGFloat(steps)
            let angle = startAngle + (endAngle - startAngle) * t

            let x = mappedCenter.x + cos(angle) * mappedRadiusX
            let y = mappedCenter.y - sin(angle) * mappedRadiusY

            let point = CGPoint(x: x, y: y)

            if index == 0 {
                path.move(to: point)
            } else {
                path.addLine(to: point)
            }
        }

        if closeType != nil {
            path.addLine(to: mappedCenter)
            path.closeSubpath()

            drawClosedPath(
                path,
                style: style,
                context: &context
            )
        } else {
            context.stroke(
                path,
                with: .color(style.lineColor.swiftUIColor),
                lineWidth: CGFloat(style.lineWidth)
            )
        }
    }

    private static func drawClosedPath(
        _ path: Path,
        style: DisplayStyle,
        context: inout GraphicsContext
    ) {

        if style.interiorStyle == .solid {
            context.fill(
                path,
                with: .color(style.fillColor.swiftUIColor)
            )

            if style.edgeVisible {
                context.stroke(
                    path,
                    with: .color(style.edgeColor.swiftUIColor),
                    lineWidth: CGFloat(style.edgeWidth)
                )
            }
        } else {
            context.stroke(
                path,
                with: .color(style.lineColor.swiftUIColor),
                lineWidth: CGFloat(style.lineWidth)
            )
        }
    }

    private static func drawText(
        position: CGPoint,
        value: String,
        style: DisplayStyle,
        scale: CGFloat,
        context: inout GraphicsContext,
        mapPoint: (CGPoint) -> CGPoint
    ) {

        let mapped = mapPoint(position)

        let fontSize = max(
            8,
            min(
                90,
                CGFloat(style.characterHeight) * scale
            )
        )

        let angle = atan2(
            -CGFloat(style.textBaseY),
            CGFloat(style.textBaseX)
        )

        var localContext = context

        localContext.translateBy(
            x: mapped.x,
            y: mapped.y
        )

        localContext.rotate(
            by: Angle(radians: Double(angle))
        )

        let text = Text(value)
            .font(.system(size: fontSize, weight: .bold))
            .foregroundColor(style.textColor.swiftUIColor)

        localContext.draw(
            text,
            at: .zero,
            anchor: .topLeading
        )
    }

    private static func drawCellArray(
        origin: CGPoint,
        width: CGFloat,
        height: CGFloat,
        columns: Int,
        rows: Int,
        colors: [ColorDTO],
        scale: CGFloat,
        context: inout GraphicsContext,
        mapPoint: (CGPoint) -> CGPoint
    ) {

        let topLeft = mapPoint(
            CGPoint(
                x: origin.x,
                y: origin.y + height
            )
        )

        let bottomRight = mapPoint(
            CGPoint(
                x: origin.x + width,
                y: origin.y
            )
        )

        let mappedWidth = abs(bottomRight.x - topLeft.x)
        let mappedHeight = abs(bottomRight.y - topLeft.y)

        let cellWidth = mappedWidth / CGFloat(columns)
        let cellHeight = mappedHeight / CGFloat(rows)

        for row in 0..<rows {
            for column in 0..<columns {

                let index = row * columns + column

                guard index < colors.count else {
                    continue
                }

                let rect = CGRect(
                    x: topLeft.x + CGFloat(column) * cellWidth,
                    y: topLeft.y + CGFloat(row) * cellHeight,
                    width: cellWidth,
                    height: cellHeight
                )

                context.fill(
                    Path(rect),
                    with: .color(colors[index].swiftUIColor)
                )

                context.stroke(
                    Path(rect),
                    with: .color(.black),
                    lineWidth: 0.5
                )
            }
        }
    }

    private static func drawMarkers(
        points: [CGPoint],
        style: DisplayStyle,
        context: inout GraphicsContext,
        mapPoint: (CGPoint) -> CGPoint
    ) {

        for point in points {

            let mapped = mapPoint(point)
            let size = max(
                3,
                min(
                    20,
                    CGFloat(style.markerSize)
                )
            )

            var path = Path()

            path.move(
                to: CGPoint(
                    x: mapped.x - size,
                    y: mapped.y
                )
            )

            path.addLine(
                to: CGPoint(
                    x: mapped.x + size,
                    y: mapped.y
                )
            )

            path.move(
                to: CGPoint(
                    x: mapped.x,
                    y: mapped.y - size
                )
            )

            path.addLine(
                to: CGPoint(
                    x: mapped.x,
                    y: mapped.y + size
                )
            )

            context.stroke(
                path,
                with: .color(style.lineColor.swiftUIColor),
                lineWidth: CGFloat(style.lineWidth)
            )
        }
    }
}
