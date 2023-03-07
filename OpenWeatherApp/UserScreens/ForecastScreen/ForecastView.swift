//
//  ForecastView.swift
//  OpenWeatherApp
//
//  Created by Mostafa Elshazly on 07/03/2023.
//

import SwiftUI

struct ForecastView: View {

    private let textFieldHeight = 48.0
    private let textFieldHorizontalPadding = 35.0
    private let iconPadding = 8.0
    private let searchButtonCornerRadius = 25.0
    private let roundedRectangleCornerRadius = 5.0
    private let roundedRectangleLineWidth = 1.5

    @State var query = ""
    @State var isShowingInfoPopup = false

    var body: some View {
        VStack {
            searchBar
            searchButton
        }
        .alert(R.string.localizable.searchInstructions(),
               isPresented: $isShowingInfoPopup,
               actions: {
            Button(R.string.localizable.ok(), role: .cancel, action: {
                print("Tapped OK")
            })
        }, message: {
            Text(R.string.localizable.searchInstructionsMessage())
        })
    }
}

struct ForecastView_Previews: PreviewProvider {
    static var previews: some View {
        ForecastView()
    }
}

// MARK: UI components
extension ForecastView {

    var searchBar: some View {
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
                    print("Tapped map")
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
    }

    var searchButton: some View {
        Button {
            print("Search tapped")
        } label: {
            Text(R.string.localizable.search())
                .padding()
        }
        .foregroundColor(.white)
        .background(Color.accentColor)
        .cornerRadius(searchButtonCornerRadius)
    }
}
