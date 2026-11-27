import SwiftUI

struct MovieDetailView: View {
    let movie: Movie
    @ObservedObject var viewModel: HomeViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Color.clear
                    .aspectRatio(16 / 9, contentMode: .fit)
                    .overlay {
                        AsyncImage(url: movie.backdropURL) { image in
                            image.resizable().scaledToFill()
                        } placeholder: {
                            Color.gray.opacity(0.3)
                        }
                    }
                    .clipped()
                    .overlay {
                        if viewModel.playingMovie?.id == movie.id, let device = viewModel.connectedDevice {
                            CastOverlay(text: "Playing on \(device.name)")
                        } else {
                            Button {
                                viewModel.play(movie)
                            } label: {
                                Image(systemName: "play.circle.fill")
                                    .font(.system(size: 64))
                                    .foregroundStyle(.white)
                            }
                            .buttonStyle(.plain)
                        }
                    }

                Text(movie.title)
                    .font(.title.bold())
                    .padding(.horizontal)

                Text(movie.overview)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal)
            }
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                CastButton(viewModel: viewModel)
            }
        }
    }
}

private struct CastOverlay: View {
    let text: String

    var body: some View {
        ZStack {
            Color.black.opacity(0.6)
            VStack(spacing: 8) {
                Image(systemName: "tv.badge.wifi")
                    .symbolVariant(.fill)
                    .font(.system(size: 56))
                    .foregroundStyle(.blue)
                Text(text)
                    .font(.headline)
                    .foregroundStyle(.white)
            }
        }
    }
}