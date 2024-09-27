import 'package:flutter/material.dart';
import 'package:movies/core/image_url/image_url.dart';
import 'package:movies/core/models/movie_genres_model/movie_genres_model.dart';
import 'package:movies/core/themes/app_themes.dart';
import 'package:movies/core/widgets/cust_cached_network_image.dart';

class GenreCard extends StatelessWidget {
  final MovieGenre movieGenre;
  final VoidCallback onGenreCardClick;
  final List<String>? imageUrl;

  const GenreCard(
      {super.key,
      required this.movieGenre,
      this.imageUrl,
      required this.onGenreCardClick});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Size size = MediaQuery.of(context).size;
    return InkWell(
      splashColor: Colors.transparent,
      onTap: () {
        onGenreCardClick();
      },
      child: Container(
        decoration: BoxDecoration(
            color: AppThemes.darkSecondaryColor,
            borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: imageUrl == null
                      ? Image.asset(
                          "assets/images/movie_genres.jpg",
                          fit: BoxFit.fill,
                          width: size.width * 0.43,
                    height: (size.width * 0.25) * (190 / 125),
                        )
                      : SizedBox(
                          width: size.width * 0.43,
                          height: (size.width * 0.26) * (190 / 125),
                          child: Stack(
                            children: [
                              Positioned(
                                top: 0,
                                right: 5,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: CustCachedNetworkImage(
                                      fit: BoxFit.fill,
                                      width: size.width * 0.25,
                                      height: (size.width * 0.25) * (190 / 125),
                                      imagePath:
                                          ImageUrl.getFullUrl(imageUrl![1])),
                                ),
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: CustCachedNetworkImage(
                                    fit: BoxFit.fill,
                                    width: size.width * 0.25,
                                    height: (size.width * 0.25) * (190 / 125),
                                    imagePath:
                                        ImageUrl.getFullUrl(imageUrl![0])),
                              ),
                            ],
                          ),
                        )),
            ),
            Expanded(
              child: Center(
                child: Text(
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  movieGenre.name ?? "",
                  style: theme.textTheme.labelMedium,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
