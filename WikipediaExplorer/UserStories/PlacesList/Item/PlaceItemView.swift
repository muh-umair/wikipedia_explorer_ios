//
//  PlaceItemView.swift
//  WikipediaExplorer
//

import SwiftUI

/// Place list row view
struct PlaceItemView: View {
    let place: PlaceItem
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(place.name)
                    .font(.body)
                
                Text(place.formattedCoordinates)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.blue)
        }
        .accessibilityElement()
        .accessibilityIdentifier(AccessibilityIdentifier.item)
        .contentShape(Rectangle())
        .padding([.vertical], LayoutConstant.verticalPadding)
    }
}

// MARK: - Constants
extension PlaceItemView {
    enum LayoutConstant {
        static let verticalPadding: CGFloat = 2
    }
    
    enum AccessibilityIdentifier {
        static let item: String = "PlaceItem"
    }
}

// MARK: - Previews
struct PlaceItemView_Previews: PreviewProvider {
    static var previews: some View {
        PlaceItemView(place: .mock)
            .previewLayout(.sizeThatFits)
            .previewDevice(.none)
    }
}
