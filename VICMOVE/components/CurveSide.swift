//
//  CurveSide.swift
//  VICMOVE
//
//  Created by BeyonderLuu on 14/04/2022.
//

import SwiftUI

struct CurveSide: Shape {
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addQuadCurve(to: CGPoint(x: 0, y: 0), control: CGPoint(x: rect.midX, y: rect.minY - 150))
        return path
    }
}

struct CurveSide_Previews: PreviewProvider {
    static var previews: some View {
        CurveSide()
    }
}
