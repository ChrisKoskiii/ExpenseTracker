//
//  ScannedImageView.swift
//  ExpenseTracker
//
//  Created by Christopher Koski on 7/31/22.
//

import SwiftUI

//This is the full screen view of the scanned image when tapped

struct ScannedImageView: View {
  let scannedImage: UIImage

    var body: some View {
      
      ZStack {
        Color(.secondarySystemBackground)
        Image(uiImage: scannedImage)
          .resizable()
          .scaledToFit()
          .contextMenu {
            Button(action: {
              UIImageWriteToSavedPhotosAlbum(scannedImage, nil, nil, nil)
            }) {
              HStack {
                Text("Save Image")
                Image(systemName: "square.and.arrow.down.fill")
              }
            }
        }
      }
    }
}

struct ScannedImageView_Previews: PreviewProvider {
    static var previews: some View {
      ScannedImageView(scannedImage: UIImage(systemName: "person")!)
    }
}
