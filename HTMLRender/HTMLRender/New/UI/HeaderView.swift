//
//  HeaderView.swift
//  Accordion
//
//  Created by Attili Naga Srinivasu on 19/07/26.
//

import SwiftUI

struct HeaderView: View {
    
    var body: some View {

        HStack(spacing: 20) {

            Image(systemName: "line.3.horizontal")
                .font(.title3)

            Divider()
                .background(.white)

            Text("AIRBUS")
                .font(.headline)
                .fontWeight(.bold)

            Divider()
                .background(.white)

            Text("airnavX")
                .font(.title3)

            Spacer()

            Capsule()
                .fill(.white)
                .frame(width: 260, height: 40)
                .overlay {

                    HStack {

                        Text("BGA - A330 - F-GXLI")
                            .foregroundColor(
                                .airbusBlue
                            )

                        Spacer()

                        Image(systemName: "pencil")
                            .foregroundColor(
                                .airbusBlue
                            )
                    }
                    .padding(.horizontal)
                }
        }
        .padding(.horizontal)
        .frame(height: 60)
        .background(
            Color.airbusBlue
        )
        .foregroundColor(.white)
    }
}


#Preview {
    HeaderView()
}
