//
//  BaseWeatherSearchView.swift
//  OpenWeatherApp
//
//  Created by Mostafa Elshazly on 08/03/2023.
//

import SwiftUI

struct BaseWeatherSearchView<ViewModel, Content>: View where ViewModel: WeatherSearchVMProtocol, Content: View {

    @StateObject var viewModel: ViewModel

    var upper: () -> Content?
    var lower: () -> Content?

    init(viewModel: ViewModel,
         @ViewBuilder upper: @escaping () -> Content? = { nil },
         @ViewBuilder lower: @escaping () -> Content? = { nil }) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.upper = upper
        self.lower = lower
    }

    var body: some View {
        VStack {
            if viewModel.isShowingOldQueries {
                Spacer()
            }
            WeatherQueryField(didTapMapPinIcon: viewModel.didTapMapPinIcon, query: $viewModel.query)
            HStack {
                searchButton
                oldQuerieshButton
            }
            if viewModel.isShowingOldQueries {
                OldWeatherSearchQueriesView(previousQueries: viewModel.previousQueries,
                                            didSelectQuery: viewModel.didSelectQuery(_:))
                Spacer()
            } else {
                if !viewModel.results.isEmpty {
                    lower()
                }
            }
        }
        .onAppear {
            viewModel.viewDidAppear()
        }
    }}

struct BaseWeatherSearchView_Previews: PreviewProvider {
    static var previews: some View {
        BaseWeatherSearchView<ForecastVM, EmptyView>(viewModel: ForecastVM())
    }
}

// MARK: UI components
extension BaseWeatherSearchView {

    var searchButton: some View {
        Button {
            viewModel.didTapSearchButton()
        } label: {
            Text(R.string.localizable.search())
        }
        .modifier(WeatherSearchButtonStyle())
    }

    var oldQuerieshButton: some View {
        Button {
            viewModel.didTapOldQueriesButton()
        } label: {
            Text(R.string.localizable.showOldQueries())
        }
        .modifier(WeatherSearchButtonStyle())
    }
}
