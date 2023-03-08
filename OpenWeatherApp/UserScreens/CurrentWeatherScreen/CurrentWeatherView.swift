//
//  CurrentWeatherView.swift
//  OpenWeatherApp
//
//  Created by Mostafa Elshazly on 08/03/2023.
//

import SwiftUI

struct CurrentWeatherView: View {

    @StateObject var viewModel = CurrentWeatherVM()

    var body: some View {
        BaseWeatherSearchView<CurrentWeatherVM, AnyView>(viewModel: viewModel)
    }
}

struct CurrentWeatherView_Previews: PreviewProvider {
    static var previews: some View {
        CurrentWeatherView()
    }
}
