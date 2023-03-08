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

    @StateObject var viewModel = ForecastVM()
    @State var isShowingInfoPopup = false

    var body: some View {
        VStack {
            if viewModel.isShowingOldRQueries {
                Spacer()
            }
            searchBar
            HStack {
                searchButton
                oldQuerieshButton
            }
            if viewModel.isShowingOldRQueries {
                oldQueries
                Spacer()
            } else {
                if !viewModel.forecasts.isEmpty {
                    forecasts
                }
            }
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
            TextField("", text: $viewModel.query, prompt: Text(R.string.localizable.searchPrompt()))
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
                    viewModel.didTapMapPinIcon()
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
            viewModel.didTapSearchButton()
        } label: {
            Text(R.string.localizable.search())
                .padding()
        }
        .foregroundColor(.white)
        .background(Color.accentColor)
        .cornerRadius(searchButtonCornerRadius)
    }

    var oldQuerieshButton: some View {
        Button {
            viewModel.didTapOldQueriesButton()
        } label: {
            Text(R.string.localizable.showOldQueries())
                .padding()
        }
        .foregroundColor(.white)
        .background(Color.accentColor)
        .cornerRadius(searchButtonCornerRadius)
    }

    var forecasts: some View {
        List {
            ForEach(viewModel.forecasts) { forecast in
                ForecastRow(forecast: forecast)
            }
        }
        .scrollContentBackground(.hidden)
    }

    var oldQueries: some View {
        List {
            ForEach(viewModel.previousQueries, id: \.self) { query in
                Button {
                    viewModel.didSelectQuery(query)
                } label: {
                    HStack {
                        Text(query)
                        Spacer()
                        Image(systemName: R.string.localizable.rewindIcon())
                            .imageScale(.large)
                    }
                }
            }
        }
        .scrollContentBackground(.hidden)
        .frame(height: 300)
    }
}
