//
//  ResultPopup.swift
//  VICMOVE
//
//  Created by BeyonderLuu on 19/04/2022.
//

import SwiftUI

struct ResultPopup: View {
    @Binding var rewards:Int
    @Binding var isShowPopupResult: Bool
    
    var body: some View {
        ZStack {
            Color(hex: "EBF5F5").opacity(50)
            VStack {
                Text("Result").font(Font.custom("JosefinSans-Bold", size: 20)).foregroundColor(Color(0x222222)).padding()
                VStack {
                    ZStack {
                        Color(hex: "FFFFFF")
                        VStack {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("Max rewards").font(Font.custom("JosefinSans-Bold", size: 20)).foregroundColor(Color(0x222222))
                                    Text("(pieces of VICMOVE box)").font(Font.custom("JosefinSans-Regular", size: 14)).foregroundColor(Color(0x222222))
                                }
                                Spacer()
                                Text("6").font(Font.custom("JosefinSans-Bold", size: 30)).foregroundColor(Color(0x222222))
                            }.frame(width: UIScreen.screenWidth*0.8)
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("Your Lucky point:").font(Font.custom("JosefinSans-Bold", size: 20)).foregroundColor(Color(0x222222))
                                }
                                Spacer()
                                Text("40").font(Font.custom("JosefinSans-Bold", size: 30)).foregroundColor(Color(0x222222))
                            }.frame(width: UIScreen.screenWidth*0.8)
                        }.padding(.leading, 30).padding(.trailing, 30)
                    }.cornerRadius(20)
                }.padding().shadow(color: Color.black.opacity(0.3), radius: 25, x: 0, y: 15)
                VStack {
                    ZStack {
                        Color(hex: "FFFFFF")
                        VStack  (alignment: .leading) {
                            VStack (alignment: .leading) {
                                Text("Comfort").font(Font.custom("JosefinSans-Regular", size: 20)).foregroundColor(Color(0x222222))
                            }
                            ZStack (alignment: .leading) {
                                Rectangle().fill(Color(0xCCDCDC)).frame(width: UIScreen.screenWidth*0.7, height: 6, alignment: .leading).cornerRadius(50).opacity(0.5)
                                Rectangle().fill(Color(0x37C8C3)).frame(width: UIScreen.screenWidth*0.7*0.4, height: 6, alignment: .leading).cornerRadius(50).opacity(0.5)
                            }
                            VStack (alignment: .leading) {
                                Text("20/30").font(Font.custom("JosefinSans-Regular", size: 15)).foregroundColor(Color(0x222222))
                            }
                        }
                    }.cornerRadius(20)
                }.padding().shadow(color: Color.black.opacity(0.3), radius: 25, x: 0, y: 15)
                VStack {
                    ZStack {
                        VStack {
                            CurveSide().fill(Color(hex: "37C8C3"))
                                .frame(height: UIScreen.screenHeight/3)
                        }
                        VStack {
                            Text("Total rewards").font(Font.custom("JosefinSans-Bold", size: 45)).foregroundColor(Color(0xFFFFFF))
                            Text( rewards >= 0 ? String(rewards) : "Loading").font(Font.custom("JosefinSans-Regular", size: 40)).foregroundColor(Color(0xFFFFFF))
                            Text("VICMOVE box pieces").font(Font.custom("JosefinSans-Regular", size: 15)).foregroundColor(Color(0xFFFFFF))
                            Spacer()
                            Button(action: {
                                isShowPopupResult = false
                            }) {
                                Text("COLLECT").font(Font.custom("JosefinSans-Regular", size: 25)).foregroundColor(Color.white)
                                    .padding(20).padding(.horizontal, 20)
                            }.background(Color(0x37C8C3)).cornerRadius(20)
                                .shadow(color: Color.black.opacity(0.5), radius: 25, x: 0, y: 15)
                                .padding()
                            Spacer()
                        }
                        
                    }
                }.padding(.top, 100)
            }
        }
    }
}
