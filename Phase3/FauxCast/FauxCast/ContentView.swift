import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = HomeViewModel()

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    if let featured = viewModel.movies.first {
                        NavigationLink {
                            MovieDetailView(movie: featured, viewModel: viewModel)
                        } label: {
                            FeaturedHero(movie: featured)
                        }
                        .buttonStyle(.plain)
                    }

                    Text("Trending Now")
                        .font(.title2.bold())
                        .padding(.horizontal)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(viewModel.movies) { movie in
                                NavigationLink {
                                    MovieDetailView(movie: movie, viewModel: viewModel)
                                } label: {
                                    PosterCard(movie: movie)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .navigationTitle("MAX")
            .toolbarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    CastButton(viewModel: viewModel)
                }
            }
        }
        .preferredColorScheme(.dark)
        .task { await viewModel.loadMovies() }
    }
}

#Preview {
    ContentView()
}
