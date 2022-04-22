import Combine
import Foundation
import SwiftUI

class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    private let url: URL?

    init(url: URL?) {
        self.url = url
    }

    private var cancellable: AnyCancellable?

    func load() {
        if let url = url {
            cancellable = URLSession.shared.dataTaskPublisher(for: url)
                .map { UIImage(data: $0.data) }
                .replaceError(with: nil)
                .receive(on: DispatchQueue.main)
                .sink { [weak self] in self?.image = $0 }
        }
    }

    func cancel() {
        cancellable?.cancel()
    }

    deinit {
        cancel()
    }
}
