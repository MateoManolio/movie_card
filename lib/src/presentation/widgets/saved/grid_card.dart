import 'package:flutter/material.dart';

import '../../../config/route/app_routes.dart';
import '../../../core/util/notification_service.dart';
import '../../../core/util/ui_consts.dart';
import '../../../domain/entity/movie.dart';
import '../../navigation/movie_details_args.dart';
import '../shared/cache_image.dart';
import '../shared/custom_card.dart';

class GridCard extends StatefulWidget {
  final Movie movie;
  final Function(Movie) setLastMovie;
  final Function(Movie) updateMovie;

  const GridCard({
    required this.setLastMovie,
    required this.updateMovie,
    required this.movie,
    super.key,
  });

  @override
  State<GridCard> createState() => _GridCardState();
}

class _GridCardState extends State<GridCard> {
  static const double posterRadius = 8;
  static const double spacePosterButtons = 4;
  static const double avatarColorOpacity = 0.5;
  static const double padding = 7;
  late final NotificationService notificationService;

  @override
  void initState() {
    notificationService = NotificationService();
    notificationService.initializePlatformNotifications();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: CustomCard(
        child: Column(
          children: <Widget>[
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  Routes.movieDetailsRouteName,
                  arguments: MovieDetailsArguments(
                    movie: widget.movie,
                    setLastMovie: widget.setLastMovie,
                    backdropTag: '',
                    posterTag: widget.movie.posterName,
                    updateMovie: widget.updateMovie,
                  ),
                );
              },
              child: Hero(
                tag: widget.movie.posterName,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(posterRadius),
                    topRight: Radius.circular(posterRadius),
                  ),
                  child: CacheImage(
                    url: widget.movie.assetsPosterPath,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: spacePosterButtons,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                InkWell(
                  onTap: () => setState(() {
                    widget.movie.toggleLiked();
                    widget.updateMovie(widget.movie);
                  }),
                  child: CircleAvatar(
                    radius: 15,
                    backgroundColor:
                        colors.secondary.withOpacity(avatarColorOpacity),
                    child: Icon(
                      widget.movie.liked
                          ? Icons.favorite
                          : Icons.favorite_border_rounded,
                      color: widget.movie.liked
                          ? Colors.redAccent
                          : Colors.white70,
                      size: 20,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () => setState(() {
                    widget.movie.toggleSaved();
                    widget.updateMovie(widget.movie);
                  }),
                  child: CircleAvatar(
                    radius: 15,
                    backgroundColor:
                        colors.secondary.withOpacity(avatarColorOpacity),
                    child: Icon(
                      widget.movie.saved
                          ? Icons.bookmark
                          : Icons.bookmark_border,
                      color: widget.movie.saved
                          ? Colors.lightBlueAccent
                          : Colors.white70,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        padding: padding,
      ),
    );
  }
}