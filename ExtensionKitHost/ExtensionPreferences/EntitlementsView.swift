//
//  EntitlementsView.swift
//  ExtensionKitHost
//
//  Created by Wouter Hennen on 04/12/2022.
//

import SwiftUI
import CodeEditKit

struct EntitlementsView: View {
    var entitlements: [Entitlement]

    var body: some View {
        GroupBox {
            VStack(alignment: .leading) {
                ForEach(Entitlement.allCases, id: \.self) { entitlement in
                    HStack {
                        if entitlements.contains(entitlement) {
                            Image(systemName: "checkmark.circle")
                                .foregroundColor(.green)
                        } else {
                            Image(systemName: "xmark.circle")
                                .foregroundColor(.red)
                        }
                        Text(entitlement.description)
                        Spacer()
                    }
                }

            }

        } label: {
            Text("Entitlements")
                .font(.headline)
                .fontWeight(.semibold)
        }
    }
}

struct EntitlementsView_Previews: PreviewProvider {
    static var previews: some View {
        EntitlementsView(entitlements: [.currentfile])
    }
}
