//
//  WeatherQueryField.swift
//  OpenWeatherApp
//
//  Created by Mostafa Elshazly on 08/03/2023.
//

import SwiftUI

struct WeatherQueryField: View {

    private let textFieldHeight = 48.0
    private let textFieldHorizontalPadding = 35.0
    private let iconPadding = 8.0
    private let searchButtonCornerRadius = 25.0
    private let roundedRectangleCornerRadius = 5.0
    private let roundedRectangleLineWidth = 1.5

    var didTapMapPinIcon: () -> Void
    @Binding var query: String
    @State var isShowingInfoPopup = false

    var body: some View {
        ZStack {
            TextField("", text: $query, prompt: Text(R.string.localizable.searchPrompt()))
                .frame(height: textFieldHeight)
                .padding(EdgeInsets(top: .zero,
                                    leading: textFieldHorizontalPadding,
                                    bottom: .zero,
                                    trailing: textFieldHorizontalPadding))
                .overlay(
                    RoundedRectangle(cornerRadius: roundedRectangleCornerRadius)
                        .stroke(lineWidth: roundedRectangleLineWidth)
                )
                .multilineTextAlignment(.center)
            HStack {
                Button {
                    didTapMapPinIcon()
                } label: {
                    Image(systemName: R.string.localizable.mapIcon())
                        .imageScale(.large)
                }
                .padding(.leading, iconPadding)
                Spacer()
                Button {
                    isShowingInfoPopup = true
                } label: {
                    Image(systemName: R.string.localizable.questionmarkIcon())
                        .imageScale(.large)
                }
                .padding(.trailing, iconPadding)
            }
        }
        .padding()
        .alert(R.string.localizable.searchInstructions(),
               isPresented: $isShowingInfoPopup,
               actions: {
            Button(R.string.localizable.ok(), role: .cancel, action: {
            })
        }, message: {
            Text(R.string.localizable.searchInstructionsMessage())
        })
    }
}

struct WeatherQueryField_Previews: PreviewProvider {
    @State static var query = ""
    static var previews: some View {
        WeatherQueryField(didTapMapPinIcon: {  }, query: $query)
    }
}
