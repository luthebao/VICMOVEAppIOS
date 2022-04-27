//
//  SpeedCircle.swift
//  VICMOVE
//
//  Created by BeyonderLuu on 19/04/2022.
//

import SwiftUI
import CoreMotion

struct SpeedCircle: View {
    @Binding var minSpeed: Float
    @Binding var maxSpeed: Float
    @Binding var stepsCount: CMPedometerData
    @Binding var activityType: String
    
    var body: some View {
        ZStack {
            Circle().trim(from: 0.5, to: 1.0)
                .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round, lineJoin: .round))
                .opacity(0.3)
                .foregroundColor(Color(0x9CC6C6))
            
            // range speed
            Circle().trim(from: CGFloat(((minSpeed*180)/40)/360) + 0.5, to: CGFloat(((maxSpeed*180)/40)/360) + 0.5)
                .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round, lineJoin: .round))
                .opacity(0.2)
                .foregroundColor(Color(0x4B37C8))
            
            //CGFloat(((CGFloat(self.stepsCount.averageActivePace?.floatValue ?? 0.0)*3.6*180)/40)/360) + 0.5
            // speed
            Circle()
                .trim(from: CGFloat(((CGFloat(stepsCount.currentPace?.floatValue ?? 0.0)*3.6*180)/40)/360) + 0.5,
                      to: CGFloat(((CGFloat(stepsCount.currentPace?.floatValue ?? 0.0)*3.6*180)/40)/360) + 0.5001
                )
                .stroke(style: StrokeStyle(lineWidth: 20.0, lineCap: .round, lineJoin: .round))
                .foregroundColor(Color(0x37C8C3))
            
            VStack{
                Text(String(format:"%.2f", ((stepsCount.currentPace?.floatValue) ?? Float(0.0)) * 3.6) )
                    .font(Font.system(size: 44)).bold().foregroundColor(Color.init(hex: "314058"))
                Text("(Speed required: \(String(minSpeed))-\(String(maxSpeed)) km/h)")
                    .font(Font.system(size: 15))
                    .foregroundColor(Color.init(hex: "32E1A0"))
                
                Text(activityType).bold().foregroundColor(Color.init(hex: "32E1A0"))
                
            }
            .padding(.top, UIScreen.screenWidth*(-0.2))
        }
    }
}
