//
//  Running.swift
//  VICMOVE
//
//  Created by BeyonderLuu on 12/04/2022.
//

import SwiftUI
import UIKit
import CoreMotion
import Foundation

struct NavigationConfigurator: UIViewControllerRepresentable {
    var configure: (UINavigationController) -> Void = { _ in }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<NavigationConfigurator>) -> UIViewController {
        UIViewController()
    }
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<NavigationConfigurator>) {
        if let nc = uiViewController.navigationController {
            self.configure(nc)
        }
    }
    
}

extension Date {
    var formattedDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.string(from: self)
    }
}

struct AppUtils {
    
    private static let userDefaults = UserDefaults.standard
    static private let kStartDate = "start_date"
    
    static func getFormattedDate(_ date: Date?) -> String {
        
        guard let date = date else {
            return ""
        }
        
        return date.formattedDate
    }
    
    
    
    static func saveStartDate(_ date: Date) {
        userDefaults.set(date, forKey: kStartDate)
    }
    
    static func getStartDate() -> Date? {
        return userDefaults.object(forKey: kStartDate) as? Date
    }
    
    static func clearUserData() {
        userDefaults.removeObject(forKey: kStartDate)
    }
}


struct Running: View {
    
    //    Timmer section
    @State private var timeRunning = false
    @State private var isShowPopupResult = false
    
    let timer = Timer.publish(every: 1.0, on: .main, in: .common).autoconnect()
    @State private var currentDate: Date = Date()
    var dateFormatter: DateFormatter {
        let formetter = DateFormatter()
        formetter.timeStyle = .medium
        return formetter
    }
    
    @State private var timeRemaining: String = "05:00"
    @State private var futureDate: Date = Calendar.current.date(byAdding: .minute, value: 5, to: Date()) ?? Date()
    
    func resetRemainTime() {
        futureDate = Calendar.current.date(byAdding: .minute, value: 5, to: Date()) ?? Date()
    }
    
    func updateRemain() {
        let remainning = Calendar.current.dateComponents([.minute, .second], from: Date(), to: futureDate)
        let minute = remainning.minute ?? 0
        let second = remainning.second ?? 0
        if (minute <= 0 && second <= 0)
        {
            timeRunning = false
            resetRemainTime()
            isShowPopupResult = true
        }
        timeRemaining = "\(String(format: "%02d", minute)):\(String(format: "%02d", second))"
        
    }
    //    end timer section
    
    
    
    let activityManager = CMMotionActivityManager()
    let pedometer = CMPedometer()
    
    @State private var isStarted = false
    @State private var startDate: Date? = nil
    @State private var endDate: Date? = nil
    @State private var activityType: String = ""
    
    
    @State private var stepsCount: CMPedometerData = CMPedometerData()
    
    @State private var NumbTab: Int = 0
    @State private var minSpeed: Float = 1.0
    @State private var maxSpeed: Float = 8.0
    @State private var rewards: Int = -1
    
    func setNumbTab(numb: Int) {
        self.NumbTab = numb
    }
    
    init() {
        let coloredAppearance = UINavigationBarAppearance()
        coloredAppearance.configureWithOpaqueBackground()
        coloredAppearance.backgroundColor = UIColor(Color(0xEBF5F5))
        UINavigationBar.appearance().standardAppearance = coloredAppearance
        UINavigationBar.appearance().compactAppearance = coloredAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = coloredAppearance
        onStop()
        resetRemainTime()
        isShowPopupResult = false
        rewards = -1
    }
    
    var body: some View {
        VStack {
            VStack {
                VStack {
                    VStack {
                        VStack {}.frame(height: 20)
                        ZStack {
//                            SpeedCircle(minSpeed: $minSpeed, maxSpeed: $maxSpeed, stepsCount: $stepsCount, activityType: $activityType)
                            ZStack {
                                Circle().trim(from: 0.5, to: 1.0)
                                    .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round, lineJoin: .round))
                                    .opacity(0.3)
                                    .foregroundColor(Color(0x9CC6C6))

                                // range speed
                                Circle().trim(from: CGFloat(((self.minSpeed*180)/40)/360) + 0.5, to: CGFloat(((self.maxSpeed*180)/40)/360) + 0.5)
                                    .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round, lineJoin: .round))
                                    .opacity(0.2)
                                    .foregroundColor(Color(0x4B37C8))

                                //CGFloat(((CGFloat(self.stepsCount.averageActivePace?.floatValue ?? 0.0)*3.6*180)/40)/360) + 0.5
                                // speed
                                Circle()
                                    .trim(from: CGFloat(((CGFloat(self.stepsCount.currentPace?.floatValue ?? 0.0)*3.6*180)/40)/360) + 0.5,
                                          to: CGFloat(((CGFloat(self.stepsCount.currentPace?.floatValue ?? 0.0)*3.6*180)/40)/360) + 0.5001
                                    )
                                    .stroke(style: StrokeStyle(lineWidth: 20.0, lineCap: .round, lineJoin: .round))
                                    .foregroundColor(Color(0x37C8C3))

                                VStack{
                                    Text(String(format:"%.2f", ((self.stepsCount.currentPace?.floatValue) ?? Float(0.0)) * 3.6) )
                                        .font(Font.system(size: 44)).bold().foregroundColor(Color.init(hex: "314058"))
                                    Text("(Speed required: \(String(self.minSpeed))-\(String(self.maxSpeed)) km/h)")
                                        .font(Font.system(size: 15))
                                        .foregroundColor(Color.init(hex: "32E1A0"))

                                    Text(self.activityType).bold().foregroundColor(Color.init(hex: "32E1A0"))

                                }
                                .padding(.top, UIScreen.screenWidth*(-0.2))
                            }
                            VStack {
                                VStack {}.frame(height: UIScreen.screenWidth/2)
                                VStack {
                                    HStack {
                                        Spacer()
                                        VStack {
                                            Text(self.timeRemaining).font(Font.custom("JosefinSans-Regular", size: 20)).foregroundColor(Color(0x222222))
                                                .onReceive(timer) { _ in
                                                    if (timeRunning){
                                                        updateRemain()
                                                    } else {
                                                        timeRemaining = "05:00"
                                                        self.onReward()
                                                        self.onStop()
                                                    }
                                                }
                                            Image("watch")
                                        }.frame(width: UIScreen.screenWidth/3)
                                        Spacer()
                                        VStack {
                                            Text(String(format:"%.2f", (self.stepsCount.distance?.floatValue ?? 0.0)*0.001)).font(Font.custom("JosefinSans-Bold", size: 46)).foregroundColor(Color(0x37C8C3))
                                            Text("Kilometers").font(Font.custom("JosefinSans-Regular", size: 20)).foregroundColor(Color(0x222222))
                                        }.frame(width: UIScreen.screenWidth/3)
                                        Spacer()
                                        VStack {
                                            Text(String(stepsCount.numberOfSteps.intValue)).font(Font.custom("JosefinSans-Regular", size: 20)).foregroundColor(Color(0x222222))
                                            Image("foot")
                                        }.frame(width: UIScreen.screenWidth/3)
                                        Spacer()
                                    }
                                }
                            }
                        }.frame(width: UIScreen.screenWidth*0.75, height: UIScreen.screenWidth*0.75)

                        Spacer()
                        
                        VStack {
                            ZStack {
                                VStack {
                                    Color(hex: "FFFFFF")
                                }.opacity(0.5)
                                VStack {
                                    Spacer()
                                    HStack {
                                        VStack (alignment: .center) {
                                            Image("energy").padding(.bottom, -25)
                                        }
                                        VStack  (alignment: .leading) {
                                            VStack (alignment: .leading) {
                                                Text("Energy").font(Font.custom("JosefinSans-Regular", size: 20)).foregroundColor(Color(0x222222))
                                            }
                                            ZStack (alignment: .leading) {
                                                Rectangle().fill(Color(0xCCDCDC)).frame(width: UIScreen.screenWidth*0.4, height: 6, alignment: .leading).cornerRadius(50).opacity(0.5)
                                                Rectangle().fill(Color(0x37C8C3)).frame(width: UIScreen.screenWidth*0.4*0.4, height: 6, alignment: .leading).cornerRadius(50).opacity(0.5)
                                            }
                                            VStack (alignment: .leading) {
                                                Text("10/30").font(Font.custom("JosefinSans-Regular", size: 15)).foregroundColor(Color(0x222222))
                                            }
                                        }
                                        Spacer()
                                    }.background(Color(0xFFFFFF)).cornerRadius(20)
                                        .padding(.leading, 30).padding(.trailing, 30)
                                        .shadow(color: Color.black.opacity(0.3), radius: 25, x: 0, y: 15)
                                    Spacer()
                                    HStack {
                                        Spacer()
                                        Button(action: {
                                            if self.isStarted {
                                                self.onStop()
                                                timeRemaining = "05:00"
                                                timeRunning = false
                                                isShowPopupResult = true
                                            } else {
                                                self.onStart()
                                                self.resetRemainTime()
                                                timeRemaining = "05:00"
                                                timeRunning = true
                                            }
                                        }) {
                                            Text("\(isStarted ? "STOP" : "START")").font(Font.custom("JosefinSans-Regular", size: 25)).foregroundColor(Color.white)
                                                .padding(20).padding(.horizontal, 20)
                                        }.background(Color(0x37C8C3)).cornerRadius(15).shadow(color: Color.black.opacity(0.3), radius: 25, x: 0, y: 15)
                                        Spacer()
                                    }
                                    Spacer()
                                }
                            }
                        }.frame(height: UIScreen.screenWidth*0.75).cornerRadius(50)
                    }
                }
                .onAppear {
                    guard let previousStartDate = AppUtils.getStartDate() else {
                        return
                    }
                    self.onStart(previousStartDate: previousStartDate)
                    self.updateStepsCount()
                }
                .popover(isPresented: $isShowPopupResult) {
                    ResultPopup(rewards: $rewards, isShowPopupResult: $isShowPopupResult)
                }.cornerRadius(50)
                
            }.background(Color(0xEBF5F5))
        }.background(Color(0xEBF5F5))
            .navigationBarItems(trailing:
                                    HStack {
                Button(action: {
                    setNumbTab(numb: 0)
                    self.minSpeed = 1
                    self.maxSpeed = 8
                }) {
                    Text("Walking").font(Font.custom("JosefinSans-Regular", size: 20)).foregroundColor(self.NumbTab == 0 ? Color(0x222222) : Color(0xBFBFBF))
                    
                }
                
                Button(action: {
                    setNumbTab(numb: 1)
                    self.minSpeed = 8
                    self.maxSpeed = 20
                }) {
                    Text("Running").font(Font.custom("JosefinSans-Regular", size: 20)).foregroundColor(self.NumbTab == 1 ? Color(0x222222) : Color(0xBFBFBF))
                    
                }
                
                Button(action: {
                    setNumbTab(numb: 2)
                    self.minSpeed = 15
                    self.maxSpeed = 30
                }) {
                    Text("Cycling").font(Font.custom("JosefinSans-Regular", size: 20)).foregroundColor(self.NumbTab == 2 ? Color(0x222222) : Color(0xBFBFBF))
                    
                }
            })
            .edgesIgnoringSafeArea([.bottom])
    }
    
    func onStart(previousStartDate: Date? = nil) {
        isStarted = true
        rewards = -1
        if previousStartDate != nil {
            startDate = previousStartDate
        } else {
            startDate = Date()
            AppUtils.saveStartDate(startDate!)
        }
        endDate = nil
        activityType = ""
        stepsCount = CMPedometerData()
        checkAuthorizationStatus()
        startUpdating()
    }
    
    func onStop() {
        timeRunning = false
        isStarted = false
        endDate = Date()
        stopUpdating()
        updateStepsCount()
        AppUtils.clearUserData()
        if (rewards < 0) {
            rewards = 0
        }
    }
    
    func onReward() {
        if (rewards < 0) {
            rewards = Int.random(in: 1...3)
        }
    }
    
    func startUpdating() {
        if CMMotionActivityManager.isActivityAvailable() {
            startTrackingActivityType()
        } else {
            activityType = "Not available"
        }
        
        if CMPedometer.isStepCountingAvailable() {
            startCountingSteps()
        } else {
            stepsCount = CMPedometerData()
        }
    }
    
    func checkAuthorizationStatus() {
        switch CMMotionActivityManager.authorizationStatus() {
        case CMAuthorizationStatus.denied:
            print("Not available")
            onStop()
            activityType = "Not available"
            stepsCount = CMPedometerData()
        default: break
        }
    }
    
    func stopUpdating() {
        activityManager.stopActivityUpdates()
        pedometer.stopUpdates()
        pedometer.stopEventUpdates()
    }
    
    func on(error: Error) {
        print(error)
    }
    
    func updateStepsCount() {
        guard let startDate = startDate else { return }
        var toDate = Date()
        if endDate != nil {
            toDate = endDate!
        }
        pedometer.queryPedometerData(from: startDate, to: toDate) { (data, error) in
            if let error = error {
                self.on(error: error)
            } else if let pedometerData = data {
                //                print(pedometerData)
                self.stepsCount = pedometerData
            }
        }
    }
    
    func startTrackingActivityType() {
        activityManager.startActivityUpdates(to: OperationQueue.main) { activity in
            guard let activity = activity else { return }
            if activity.walking {
                self.activityType = "Walking"
            } else if activity.stationary {
                self.activityType = "Stationary"
            } else if activity.running {
                self.activityType = "Running"
            } else if activity.automotive {
                self.activityType = "Car"
            } else if activity.cycling {
                self.activityType = "Cycling"
            }
        }
    }
    
    func startCountingSteps() {
        guard let startDate = startDate else { return }
        pedometer.startUpdates(from: startDate) { pedometerData, error in
            guard let pedometerData = pedometerData, error == nil else { return }
            //            print("startCountingSteps")
            //            print(pedometerData)
            
            self.stepsCount = pedometerData
        }
    }
}

struct Running_Previews: PreviewProvider {
    static var previews: some View {
        Running()
    }
}
