//
//  ForecastView.swift
//  OpenWeatherApp
//
//  Created by Mostafa Elshazly on 07/03/2023.
//

import SwiftUI

struct ForecastView: View {

    @State var query = ""
    @State var isShowingInfoPopup = false

    var body: some View {
        VStack {
            searchBar
            searchButton
        }
        .alert("Search instructions",
               isPresented: $isShowingInfoPopup,
               actions: {
            Button("OK", role: .cancel, action: {
                print("Tapped OK")
            })
        }, message: {
            Text("""
You can search for your current location by tapping the map pin icon on the left, alternatively, you can search for a city, a zip code or by latitude / longitude as follows:

city: london
zip code: 12345
lat/lon: 12,34.567
""")
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
            TextField("", text: $query, prompt: Text("Enter city, zip code or lat/lon"))
                .frame(height: 48)
                .padding(EdgeInsets(top: 0, leading: 35, bottom: 0, trailing: 35))
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(lineWidth: 1.5)
                )
                .multilineTextAlignment(.center)
            HStack {
                Button {
                    print("Tapped map")
                } label: {
                    Image(systemName: "mappin.and.ellipse")
                        .imageScale(.large)
                }
                .padding(.leading, 8.0)
                Spacer()
                Button {
                    isShowingInfoPopup = true
                } label: {
                    Image(systemName: "questionmark.circle.fill")
                        .imageScale(.large)
                }
                .padding(.trailing, 8.0)
            }
        }
        .padding()
    }

    var searchButton: some View {
        Button {
            print("Search tapped")
        } label: {
            Text("Search")
                .padding()
        }
        .foregroundColor(.white)
        .background(Color.accentColor)
        .cornerRadius(25)
    }
}
