import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:movie_card/src/config/secrets/env.dart';
import 'package:movie_card/src/core/util/data_state.dart';
import 'package:movie_card/src/core/util/enums.dart';
import 'package:movie_card/src/core/util/strings.dart';
import 'package:movie_card/src/data/datasource/remote/api_repository.dart';
import 'package:movie_card/src/domain/entity/genre.dart';
import 'package:movie_card/src/domain/entity/movie.dart';

class MockClient extends Mock implements http.Client {}

void main() {
  final String apiKeyUri = '?api_key=${Env.apiKey}';
  group(
    'Genres tests',
    () {
      late APIRepository apiRepository;
      late MockClient mockClient;
      setUp(
        () {
          mockClient = MockClient();
          apiRepository = APIRepository(client: mockClient);
        },
      );

      test(
        'Load Genres - Success',
        () async {
          when(
            () => mockClient.get(
              Uri.parse(
                genresMoviesUri + Env.apiKey,
              ),
            ),
          ).thenAnswer(
            (_) => Future.value(
              http.Response('{"genres": []}', 200),
            ),
          );

          final DataState<List<Genre>> result =
              await apiRepository.loadGenres();

          expect(result, isNotNull);
          expect(result.state, Status.success);
          expect(result.data, isA<List<Genre>>());
        },
      );

      test(
        'Load Genres - Failure',
        () async {
          when(
            () => mockClient.get(
              Uri.parse(
                genresMoviesUri + apiKeyUri,
              ),
            ),
          ).thenAnswer(
            (_) async => Future.value(
              http.Response('{"error": "Something went wrong"}', 500),
            ),
          );

          final DataState<List<Genre>> result =
              await apiRepository.loadGenres();

          expect(result, isNotNull);
          expect(result.state, Status.error);
        },
      );
    },
  );

  group(
    'Movies by type tests',
    () {
      late APIRepository apiRepository;
      late MockClient mockClient;

      setUp(
        () {
          mockClient = MockClient();
          apiRepository = APIRepository(client: mockClient);
        },
      );

      test(
        'Load Movies - Success',
        () async {
          when(
            () => mockClient.get(
              Uri.parse(
                moviesDetailsUri + APIRepository.popular + apiKeyUri,
              ),
            ),
          ).thenAnswer(
            (_) => Future.value(
              http.Response('{"results": []}', 200),
            ),
          );

          final DataState<List<Movie>> result =
              await apiRepository.loadMoviesByType(Endpoint.popular);

          expect(result, isNotNull);
          expect(result.state, Status.success);
          expect(result.data, isA<List<Movie>>());
        },
      );

      test(
        'Load Movies - Failure',
        () async {
          when(
            () => mockClient.get(
              Uri.parse(
                moviesDetailsUri + APIRepository.popular + apiKeyUri,
              ),
            ),
          ).thenAnswer(
            (_) async => Future.value(
              http.Response('{"error": "Something went wrong"}', 500),
            ),
          );

          final DataState<List<Movie>> result =
              await apiRepository.loadMoviesByType(Endpoint.popular);

          expect(result, isNotNull);
          expect(result.state, Status.error);
        },
      );
    },
  );
}
