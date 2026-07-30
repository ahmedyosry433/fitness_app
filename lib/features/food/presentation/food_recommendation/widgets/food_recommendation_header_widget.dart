import 'package:fitness/core/values/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class FoodRecommendationHeaderWidget extends StatelessWidget {
  final String title;

  const FoodRecommendationHeaderWidget({
    super.key,
    this.title = 'Food Recommendation',
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: InkWell(
              onTap: () {
                if (context.canPop()) {
                  context.pop();
                }
              },
              borderRadius: BorderRadius.circular(20),
              child: SvgPicture.asset(
                AppIcons.iconsBackOrange,
                width: 32,
                height: 32,
              ),
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              fontFamily: 'BalooThambi2',
            ),
          ),
        ],
      ),
    );
  }
}
