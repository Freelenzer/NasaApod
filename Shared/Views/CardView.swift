import Foundation
import SwiftUI

struct CardView: View {
    @Binding
    var apod: APOD
    @Binding var hero: Bool

    var body: some View {
        ZStack(alignment: .topTrailing) {
            Color(UIColor.secondarySystemGroupedBackground)
            GeometryReader { geometry in
                VStack {
                    AsyncImageView(url: self.apod.thumbnail_url ?? self.apod.url)
                        .frame(width: geometry.size.width, height: self.apod.expand ? 350 : 250)
                        .clipped()
                        // 500 for disabling the drag for scrollview...
                        .simultaneousGesture(DragGesture(minimumDistance: hero ? 0 : 500).onChanged { _ in
                        })
                    ScrollView(showsIndicators: false) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(apod.getPrettyDate())
                                    .font(.headline)
                                    .foregroundColor(.secondary)
                                Text(apod.title)
                                    .font(.title2)
                                    .fontWeight(.black)
                                    .foregroundColor(.primary)
                                    .lineLimit(3)

                                if self.apod.expand {
                                    if let copyright = apod.copyright {
                                        Text("© " + copyright.uppercased())
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                    Spacer()
                                    Text(self.apod.explanation)
                                    Spacer(minLength: 120)
                                }
                            }.padding(.horizontal)
                            Spacer()
                        }
                    }
                }
            }
            if self.apod.expand {
                Button(action: {
                    withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.8, blendDuration: 0)) {
                        self.apod.expand.toggle()
                        self.hero.toggle()
                    }
                }) {
                    Image(systemName: "xmark")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.black.opacity(0.8))
                        .clipShape(Circle())
                }
                .padding(.top, UIApplication
                    .shared
                    .connectedScenes
                    .flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
                    .first { $0.isKeyWindow }?.safeAreaInsets.top)
            }

        }.cornerRadius(self.apod.expand ? 0 : 10)
            .overlay(
                RoundedRectangle(cornerRadius: self.apod.expand ? 0 : 10)
                    .stroke(Color(.sRGB, red: 150/255, green: 150/255, blue: 150/255, opacity: 0.3), lineWidth: 1.5)
            )
            .padding(self.apod.expand ? [] : [.top, .horizontal])
    }
}

struct CardView_Previews: PreviewProvider {
    @State static var hero: Bool = true
    @State static var apod = APOD(title: "Earendel: A Star in the Early Universe", explanation: "Typically, the International Space Station is visible only at night.  Slowly drifting across the night sky as it orbits the Earth, the International Space Station (ISS) can be seen as a bright spot several times a year from many locations.  The ISS is then visible only just after sunset or just before sunrise because it shines by reflected sunlight -- once the ISS enters the Earth's shadow, it will drop out of sight. The only occasion when the ISS is visible during the day is when it passes right in front of the Sun. Then, it passes so quickly that only cameras taking short exposures can visually freeze the ISS's silhouette onto the background Sun. The featured picture did exactly that -- it is actually a series of images taken earlier this month from Beijing, China with perfect timing.  This image series was later combined with separate images taken at nearly the same time but highlighting the texture and activity on the busy Sun. The solar activity included numerous gaseous prominences seen around the edge, highlighted in red, filaments seen against the Sun's face, and a dark sunspot.", date: "2022-04-18", url: "https://apod.nasa.gov/apod/image/2204/M24_APOD_GabrielRodriguesSantosAPOD1100.jpg", copyright: "Gabriel Rodrigues Santos", expand: true)
    static var previews: some View {
        CardView(apod: $apod, hero: $hero)
    }
}
