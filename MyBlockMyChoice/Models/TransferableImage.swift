//
//  TransferableImage.swift
//  MyBlockMyChoice
//
//  Created by Itsuki on 2026/01/17.
//

import SwiftUI
import UniformTypeIdentifiers

struct TransferableImage: Transferable {
    let uiImage: UIImage

    enum TransferError: Error {
        case importFailed
    }

    static var transferRepresentation: some TransferRepresentation {
        DataRepresentation(importedContentType: .image) { data in
            guard let uiImage = UIImage(data: data) else {
                throw TransferError.importFailed
            }
            return TransferableImage(uiImage: uiImage)
        }
    }
}
