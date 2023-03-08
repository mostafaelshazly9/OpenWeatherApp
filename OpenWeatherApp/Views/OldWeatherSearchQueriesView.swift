//
//  OldWeatherSearchQueriesView.swift
//  OpenWeatherApp
//
//  Created by Mostafa Elshazly on 08/03/2023.
//

import SwiftUI

struct OldWeatherSearchQueriesView: View {

    var previousQueries: [String]
    var didSelectQuery: (_ query: String) -> Void

    var body: some View {
        List {
            ForEach(previousQueries, id: \.self) { query in
                Button {
                    didSelectQuery(query)
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
    }
}

struct OldWeatherSearchQueriesView_Previews: PreviewProvider {
    static var previews: some View {
        OldWeatherSearchQueriesView(previousQueries: [], didSelectQuery: { _ in })
    }
}
