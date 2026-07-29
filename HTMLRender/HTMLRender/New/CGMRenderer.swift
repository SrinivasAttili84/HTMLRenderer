//
//  CGMRenderer.swift
//  HTMLRender
//
//  Created by Attili Naga Srinivasu on 29/07/26.
//

import SwiftUI
import CoreGraphics

struct CGMRenderer {

    static func render(
        document: CGMDocument,
        context: inout GraphicsContext,
        size: CGSize
    ) {

        let bounds = calculateBounds(document: document)

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

        for primitive in document.primitives {

            switch primitive {

            case .polyline(let points, let style):
                drawPolyline(
                    points: points,
                    style: style,
                    context: &context,
                    mapPoint: mapPoint
                )

            case .polygon(let points, let style):
                drawPolygon(
                    points: points,
                    style: style,
                    context: &context,
                    mapPoint: mapPoint
                )

            case .rectangle(let rect, let style):
                drawRectangle(
                    rect: rect,
                    style: style,
                    context: &context,
                    mapPoint: mapPoint
                )

            case .circle(let center, let radius, let style):
                drawCircle(
                    center: center,
                    radius: radius,
                    scale: scale,
                    style: style,
                    context: &context,
                    mapPoint: mapPoint
                )

            case .ellipse(let center, let radiusX, let radiusY, let style):
                drawEllipse(
                    center: center,
                    radiusX: radiusX,
                    radiusY: radiusY,
                    scale: scale,
                    style: style,
                    context: &context,
                    mapPoint: mapPoint
                )

            case .text(let position, let value, let style):
                drawText(
                    position: position,
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
                    center: center,
                    radius: radius,
                    startAngle: startAngle,
                    endAngle: endAngle,
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
                    origin: origin,
                    width: width,
                    height: height,
                    columns: columns,
                    rows: rows,
                    colors: colors,
                    scale: scale,
                    context: &context,
                    mapPoint: mapPoint
                )
                
            case .markers(let points, let style):
                drawMarkers(
                    points: points,
                    style: style,
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
                    center: center,
                    radiusX: radiusX,
                    radiusY: radiusY,
                    startAngle: startAngle,
                    endAngle: endAngle,
                    closeType: closeType,
                    style: style,
                    scale: scale,
                    context: &context,
                    mapPoint: mapPoint
                )
            }
        }
    }

    private static func drawEllipticalArc(
        center: CGPoint,
        radiusX: CGFloat,
        radiusY: CGFloat,
        startAngle: CGFloat,
        endAngle: CGFloat,
        closeType: Int?,
        style: CGMGraphicStyle,
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
                with: .color(style.lineColor),
                lineWidth: style.lineWidth
            )
        }
    }
    
    private static func drawPolyline(
        points: [CGPoint],
        style: CGMGraphicStyle,
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
            with: .color(style.lineColor),
            lineWidth: style.lineWidth
        )
    }

    private static func drawPolygon(
        points: [CGPoint],
        style: CGMGraphicStyle,
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
        style: CGMGraphicStyle,
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

        let path = Path(mappedRect)

        drawClosedPath(
            path,
            style: style,
            context: &context
        )
    }

    private static func drawCircle(
        center: CGPoint,
        radius: CGFloat,
        scale: CGFloat,
        style: CGMGraphicStyle,
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

        let path = Path(ellipseIn: rect)

        drawClosedPath(
            path,
            style: style,
            context: &context
        )
    }

    private static func drawEllipse(
        center: CGPoint,
        radiusX: CGFloat,
        radiusY: CGFloat,
        scale: CGFloat,
        style: CGMGraphicStyle,
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

        let path = Path(ellipseIn: rect)

        drawClosedPath(
            path,
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
        style: CGMGraphicStyle,
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
                with: .color(style.lineColor),
                lineWidth: style.lineWidth
            )
        }
    }

    private static func drawClosedPath(
        _ path: Path,
        style: CGMGraphicStyle,
        context: inout GraphicsContext
    ) {

        if style.interiorStyle == .solid {

            context.fill(
                path,
                with: .color(style.fillColor)
            )

            if style.edgeVisible {
                context.stroke(
                    path,
                    with: .color(style.edgeColor),
                    lineWidth: style.edgeWidth
                )
            }

        } else {

            context.stroke(
                path,
                with: .color(style.lineColor),
                lineWidth: style.lineWidth
            )
        }
    }

    private static func drawText(
        position: CGPoint,
        value: String,
        style: CGMGraphicStyle,
        scale: CGFloat,
        context: inout GraphicsContext,
        mapPoint: (CGPoint) -> CGPoint
    ) {

        let mapped = mapPoint(position)

        let fontSize = max(
            8,
            min(
                90,
                style.characterHeight * scale
            )
        )

        let base = style.textOrientation.base

        let angle = atan2(
            -base.y,
            base.x
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
            .foregroundColor(style.textColor)

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
        colors: [Color],
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

        guard mappedWidth > 0, mappedHeight > 0 else {
            return
        }

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
                    with: .color(colors[index])
                )

                context.stroke(
                    Path(rect),
                    with: .color(.black),
                    lineWidth: 0.5
                )
            }
        }

        let borderRect = CGRect(
            x: topLeft.x,
            y: topLeft.y,
            width: mappedWidth,
            height: mappedHeight
        )

        context.stroke(
            Path(borderRect),
            with: .color(.black),
            lineWidth: 1
        )
    }

    private static func calculateBounds(
        document: CGMDocument
    ) -> CGRect {

        if let extent = document.vdcExtent {
            return extent
        }

        var allPoints: [CGPoint] = []

        for primitive in document.primitives {

            switch primitive {

            case .polyline(let points, _):
                allPoints.append(contentsOf: points)

            case .polygon(let points, _):
                allPoints.append(contentsOf: points)

            case .rectangle(let rect, _):
                allPoints.append(CGPoint(x: rect.minX, y: rect.minY))
                allPoints.append(CGPoint(x: rect.maxX, y: rect.maxY))

            case .circle(let center, let radius, _):
                allPoints.append(
                    CGPoint(x: center.x - radius, y: center.y - radius)
                )
                allPoints.append(
                    CGPoint(x: center.x + radius, y: center.y + radius)
                )

            case .ellipse(let center, let radiusX, let radiusY, _):
                allPoints.append(
                    CGPoint(x: center.x - radiusX, y: center.y - radiusY)
                )
                allPoints.append(
                    CGPoint(x: center.x + radiusX, y: center.y + radiusY)
                )

            case .text(let position, _, _):
                allPoints.append(position)

            case .circularArc(let center, let radius, _, _, _, _):
                allPoints.append(
                    CGPoint(x: center.x - radius, y: center.y - radius)
                )
                allPoints.append(
                    CGPoint(x: center.x + radius, y: center.y + radius)
                )

            case .cellArray(let origin, let width, let height, _, _, _):
                allPoints.append(origin)
                allPoints.append(
                    CGPoint(
                        x: origin.x + width,
                        y: origin.y + height
                    )
                )
            case .markers(let points, _):
                allPoints.append(contentsOf: points)
                
            case .ellipticalArc(let center, let radiusX, let radiusY, _, _, _, _):
                allPoints.append(
                    CGPoint(
                        x: center.x - radiusX,
                        y: center.y - radiusY
                    )
                )

                allPoints.append(
                    CGPoint(
                        x: center.x + radiusX,
                        y: center.y + radiusY
                    )
                )
            }
        }

        
        guard let first = allPoints.first else {
            return CGRect(
                x: 0,
                y: 0,
                width: 100,
                height: 100
            )
        }

        var minX = first.x
        var minY = first.y
        var maxX = first.x
        var maxY = first.y

        for point in allPoints {
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
    
    private static func drawMarkers(
        points: [CGPoint],
        style: CGMGraphicStyle,
        context: inout GraphicsContext,
        mapPoint: (CGPoint) -> CGPoint
    ) {

        for point in points {

            let mapped = mapPoint(point)
            let size = max(3, min(20, style.markerSize))
            
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
                with: .color(style.lineColor),
                lineWidth: style.lineWidth
            )
        }
    }
}
