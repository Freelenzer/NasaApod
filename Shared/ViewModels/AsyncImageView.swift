import SwiftUI

struct AsyncImageView: View {
    @StateObject private var loader: ImageLoader

    init(url: String) {
        _loader = StateObject(wrappedValue: ImageLoader(url: URL(string: url)!))
    }

    var body: some View {
        content
            .onAppear(perform: loader.load)
    }

    private var content: some View {
        Group {
            if let image = loader.image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else {
                ProgressView()
            }
        }
    }
}
