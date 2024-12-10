import "package:bookfinder_app/consts/colors.dart";
import "package:bookfinder_app/consts/custom_icons.dart";
import "package:bookfinder_app/extensions/snackbars.dart";
import "package:bookfinder_app/extensions/theming.dart";
import "package:bookfinder_app/models/api_response.dart";
import "package:bookfinder_app/services/api/api_recommendations_subservice.dart";
import "package:bookfinder_app/services/api/api_service_auth.dart";
import "package:flutter/material.dart";

class ExploreTab extends StatefulWidget {
  const ExploreTab({super.key});

  @override
  State<ExploreTab> createState() => _ExploreTabState();
}

class _ExploreTabState extends State<ExploreTab> {
  List<Map<String, dynamic>> recommendations = [];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getRecommendations();
    });
  }

  @override
  Widget build(BuildContext context) {
    final Widget innerChild = switch (recommendations.isEmpty) {
      true => Center(child: CircularProgressIndicator()),
      false => Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Spacer(),
            Expanded(
              flex: 10,
              child: AspectRatio(
                aspectRatio: 2 / 3,
                child: _getImageUrl(recommendations.first) != null
                    ? Image.network(
                        _getImageUrl(recommendations.first)!,
                        fit: BoxFit.fitHeight,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null ||
                              loadingProgress.expectedTotalBytes == null) {
                            return child;
                          }

                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!,
                            ),
                          );
                        },
                      )
                    : Container(color: colorGray),
              ),
            ),
            Spacer(),
            SizedBox(height: 32),
            Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getTitle(recommendations.first),
                        style: context.theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 8),
                      Text(
                        _getAuthor(recommendations.first),
                        style: context.theme.textTheme.titleMedium?.copyWith(
                          color: colorGray,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 16),
                IconButton(
                  onPressed: getNextRecommendation,
                  color: colorBlack,
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shape: CircleBorder(),
                    side: BorderSide(
                      color: colorBlack,
                      width: 2,
                    ),
                    padding: EdgeInsets.all(12),
                  ),
                  icon: Icon(CustomIcons.heartPlusOutlineRounded),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              _getDescription(recommendations.first) ??
                  "Kitap açıklaması alınamadı.",
              style: context.theme.textTheme.bodyMedium?.copyWith(
                color: colorGray,
              ),
              maxLines: 3,
            ),
          ],
        ),
    };

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(32),
        child: innerChild,
      ),
    );
  }

  String? _getImageUrl(dynamic data) {
    try {
      return data["volumeInfo"]["imageLinks"]["thumbnail"];
    } catch (e) {
      return null;
    }
  }

  String _getTitle(dynamic data) {
    return data["volumeInfo"]["title"];
  }

  String _getAuthor(dynamic data) {
    try {
      return data["volumeInfo"]["authors"][0];
    } catch (e) {
      return "Yazar alınamadı";
    }
  }

  String? _getDescription(dynamic data) {
    try {
      return data["volumeInfo"]["description"];
    } catch (e) {
      return null;
    }
  }

  Future<void> getRecommendations() async {
    final result = await ApiServiceAuth.reqWithAuthCheck(
      (authHeader) => ApiRecommendationsSubservice.getRecommendations(
        authHeader: authHeader,
      ),
    );

    if (result.status != ResponseStatus.ok) {
      if (mounted) {
        context.showSnackbar(
          "Öneriler getirilirken bir hata meydana geldi.",
          type: SnackbarType.error,
        );
      }

      return;
    }

    if (mounted) {
      setState(() {
        recommendations.addAll(result.data!);
      });
    }
  }

  Future<void> getNextRecommendation() async {
    setState(() {
      recommendations.removeAt(0);
    });

    if (recommendations.length < 3) {
      getRecommendations();
    }
  }
}
