import 'package:fitness/core/theme/app_colors.dart';
import 'dart:async';
import 'dart:math' as math;

import 'package:fitness/core/routes/routes.dart';
import 'package:fitness/core/values/app_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:fitness/core/languages/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _pulseController;
  late AnimationController _shimmerController;

  late Animation<double> _logoScale;
  late Animation<double> _logoFade;

  late Animation<double> _glowOpacity;
  late Animation<double> _glowScale;

  late Animation<double> _textFade;
  late Animation<Offset> _textSlide;

  late Animation<double> _loadingProgress;
  late Animation<double> _loadingFade;

  late Animation<double> _pulseAnimation;

  late Animation<double> _shimmerAnimation;

  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    _setupAnimations();
    _startSequence();
  }

  void _setupAnimations() {
    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _logoScale = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.0, 0.35, curve: Curves.elasticOut),
      ),
    );

    _logoFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.0, 0.20, curve: Curves.easeOut),
      ),
    );

    _glowOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.20, 0.55, curve: Curves.easeInOut),
      ),
    );

    _glowScale = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.20, 0.55, curve: Curves.easeOutBack),
      ),
    );

    _textFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.45, 0.70, curve: Curves.easeOut),
      ),
    );

    _textSlide = Tween<Offset>(begin: const Offset(0, 0.4), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _mainController,
            curve: const Interval(0.45, 0.70, curve: Curves.easeOutCubic),
          ),
        );

    _loadingProgress = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.60, 1.0, curve: Curves.easeInOut),
      ),
    );

    _loadingFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.55, 0.65, curve: Curves.easeOut),
      ),
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _shimmerAnimation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _shimmerController, curve: Curves.linear),
    );
  }

  void _startSequence() {
    _mainController.forward();

    Future.delayed(const Duration(milliseconds: 900), () {
      if (mounted) _pulseController.repeat(reverse: true);
    });

    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) _shimmerController.repeat();
    });

    Timer(const Duration(milliseconds: 3600), () {
      if (mounted) {
        context.go(Routes.onBoard);
      }
    });
  }

  @override
  void dispose() {
    _mainController.dispose();
    _pulseController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: Listenable.merge([
          _mainController,
          _pulseController,
          _shimmerController,
        ]),
        builder: (context, _) {
          return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF181818),
                  Color(0xFF242424),
                  Color(0xFF2D2D2D),
                ],
                stops: [0.0, 0.5, 1.0],
              ),
            ),
            child: Stack(
              children: [
                ..._buildParticles(),

                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildGlowRing(),

                      const SizedBox(height: 32),

                      _buildBrandText(),

                      const SizedBox(height: 48),

                      _buildLoadingBar(),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildGlowRing() {
    return SizedBox(
      width: 200,
      height: 200,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Transform.scale(
            scale: _glowScale.value * _pulseAnimation.value,
            child: Opacity(
              opacity: _glowOpacity.value * 0.6,
              child: Container(
                width: 190,
                height: 190,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.primaryOrangeDark.withValues(alpha: 0.3),
                      AppColors.primaryOrangeDark.withValues(alpha: 0.15),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
              ),
            ),
          ),

          Transform.scale(
            scale: _glowScale.value,
            child: Opacity(
              opacity: _glowOpacity.value * 0.8,
              child: Container(
                width: 165,
                height: 165,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.primaryOrangeDark.withValues(alpha: 0.4),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryOrangeDark.withValues(alpha: 0.2),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                    BoxShadow(
                      color: AppColors.primaryOrangeDark.withValues(alpha: 0.10),
                      blurRadius: 40,
                      spreadRadius: 10,
                    ),
                  ],
                ),
              ),
            ),
          ),

          Transform.scale(
            scale: _logoScale.value,
            child: Opacity(
              opacity: _logoFade.value,
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.4),
                      blurRadius: 30,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(28),
                  child: Image.asset(
                    AppImages.imagesIcLauncher,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBrandText() {
    return SlideTransition(
      position: _textSlide,
      child: FadeTransition(
        opacity: _textFade,
        child: Column(
          children: [
            ShaderMask(
              shaderCallback: (bounds) {
                return LinearGradient(
                  colors: const [Colors.white, AppColors.primaryOrangeDark, Colors.white],
                  stops: [
                    (_shimmerAnimation.value - 0.3).clamp(0.0, 1.0),
                    _shimmerAnimation.value.clamp(0.0, 1.0),
                    (_shimmerAnimation.value + 0.3).clamp(0.0, 1.0),
                  ],
                ).createShader(bounds);
              },
              child: Text(
                LocaleKeys.splash_title.tr(),
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: 6,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              LocaleKeys.splash_subtitle.tr(),
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: Colors.white.withValues(alpha: 0.5),
                letterSpacing: 3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingBar() {
    return FadeTransition(
      opacity: _loadingFade,
      child: SizedBox(
        width: 200,
        child: Column(
          children: [
            Container(
              height: 3,
              width: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                color: Colors.white.withValues(alpha: 0.1),
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: FractionallySizedBox(
                  widthFactor: _loadingProgress.value,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      gradient: const LinearGradient(
                        colors: [AppColors.primaryOrangeLight, AppColors.primaryOrangeDark],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryOrangeDark.withValues(alpha: 0.5),
                          blurRadius: 8,
                          offset: const Offset(0, 0),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildParticles() {
    final particles = <_ParticleData>[
      _ParticleData(0.15, 0.20, 4, 0.3, 0.0),
      _ParticleData(0.80, 0.15, 3, 0.2, 0.3),
      _ParticleData(0.25, 0.75, 5, 0.25, 0.5),
      _ParticleData(0.70, 0.65, 3.5, 0.15, 0.7),
      _ParticleData(0.50, 0.40, 4.5, 0.2, 0.2),
      _ParticleData(0.90, 0.80, 3, 0.3, 0.4),
      _ParticleData(0.10, 0.50, 2.5, 0.15, 0.6),
      _ParticleData(0.60, 0.90, 3.5, 0.2, 0.8),
    ];

    return particles.map((p) {
      final progress = _mainController.value;
      final adjustedProgress = ((progress - p.delay) / (1.0 - p.delay)).clamp(
        0.0,
        1.0,
      );
      final opacity = adjustedProgress * p.maxOpacity;

      final floatY =
          math.sin((_pulseController.value + p.delay) * math.pi * 2) * 8;

      return Positioned(
        left: MediaQuery.of(context).size.width * p.x,
        top: MediaQuery.of(context).size.height * p.y + floatY,
        child: Opacity(
          opacity: opacity,
          child: Container(
            width: p.size,
            height: p.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryOrangeDark.withValues(alpha: 0.3),
                  blurRadius: p.size * 3,
                ),
              ],
            ),
          ),
        ),
      );
    }).toList();
  }
}

class _ParticleData {
  final double x;
  final double y;
  final double size;
  final double maxOpacity;
  final double delay;

  const _ParticleData(this.x, this.y, this.size, this.maxOpacity, this.delay);
}
