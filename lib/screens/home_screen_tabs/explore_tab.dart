import "package:bookfinder_app/consts/colors.dart";
import "package:bookfinder_app/consts/custom_icons.dart";
import "package:bookfinder_app/extensions/snackbars.dart";
import "package:bookfinder_app/extensions/theming.dart";
import "package:bookfinder_app/models/api_response.dart";
import "package:bookfinder_app/models/bookdata_models.dart";
import "package:bookfinder_app/services/api/api_service_provider.dart";
import "package:bookfinder_app/utils/auth_utils.dart" as auth_utils;
import "package:flutter/material.dart";

class ExploreTab extends StatefulWidget {
  const ExploreTab({super.key});

  @override
  State<ExploreTab> createState() => _ExploreTabState();
}

class _ExploreTabState extends State<ExploreTab> {
  List<BookRecommendation> recommendations = [];

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
                child: Image.network(
                  recommendations.first.thumbnailUrl,
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
                ),
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
                        recommendations.first.title,
                        style: context.theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 8),
                      Text(
                        recommendations.first.authors.join(", "),
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
              recommendations.first.description ??
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

  Future<void> getRecommendations() async {
    final result = await auth_utils.withAuth(
      (authHeader) => ApiServiceProvider.i.recommendations.getRecommendations(
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
