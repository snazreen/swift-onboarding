import SwiftUI

struct FeaturedHero: View {
    let movie: Movie

    var body: some View {
        Color.clear
            .frame(height: 360)
            .overlay {
                AsyncImage(url: movie.backdropURL) { image in
                    image.resizable().scaledToFill()
                } placeholder: {
                    Color.gray.opacity(0.3)
                }
            }
            .clipped()
            .overlay {
                LinearGradient(colors: [.clear, .black], startPoint: .center, endPoint: .bottom)
            }
            .overlay(alignment: .bottomLeading) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("FEATURED TODAY")
                        .font(.caption.bold())
                        .foregroundStyle(.cyan)
                    Text(movie.title)
                        .font(.largeTitle.bold())
                }
                .padding()
            }
    }
}

struct PosterCard: View {
    let movie: Movie

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            AsyncImage(url: movie.posterURL) { image in
                image.resizable().scaledToFill()
            } placeholder: {
                Color.gray.opacity(0.3)
            }
            .frame(width: 140, height: 210)
            .clipShape(.rect(cornerRadius: 8))

            Text(movie.title)
                .font(.footnote)
                .lineLimit(1)
                .frame(width: 140, alignment: .leading)
        }
    }
}