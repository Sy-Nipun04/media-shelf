import 'package:flutter/material.dart';

class StarRating extends StatelessWidget {
  final int? rating; // can be null
  final int maxRating;
  final ValueChanged<int?> onRatingChanged;
  final double size;
  final Color filledColor;
  final Color unfilledColor;
  final bool allowClear; // toggle to allow unselecting

  const StarRating({
    required this.rating,
    required this.onRatingChanged,
    this.maxRating = 5,
    this.size = 20,
    this.filledColor = Colors.orange,
    this.unfilledColor = Colors.grey,
    this.allowClear = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(maxRating, (index) {
        final starIndex = index + 1;
        return GestureDetector(
          onTap: () {
            if (allowClear && rating == starIndex) {
              onRatingChanged(null); // clear rating if tapped again
            } else {
              onRatingChanged(starIndex); // set new rating
            }
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                starIndex <= (rating ?? 0) ? Icons.star : Icons.star_border,
                color: starIndex <= (rating ?? 0) ? filledColor : unfilledColor,
                size: size,
              ),
            ],
          ),
        );
      }),
    );
  }
}
