//
//  WeatherSearchButtonStyle.swift
//  OpenWeatherApp
//
//  Created by Mostafa Elshazly on 08/03/2023.
//

import SwiftUI

struct WeatherSearchButtonStyle: ViewModifier {

    private let searchButtonCornerRadius = 25.0

    func body(content: Content) -> some View {
        content
            .padding()
            .foregroundColor(.white)
            .background(Color.accentColor)
            .cornerRadius(searchButtonCornerRadius)
    }
}
