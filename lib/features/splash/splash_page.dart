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

  // Phase 1: Logo entrance (scale + fade)
  late Animation<double> _logoScale;
  late Animation<double> _logoFade;

  // Phase 2: Glow ring
  late Animation<double> _glowOpacity;
  late Animation<double> _glowScale;

  // Phase 3: Text reveal
  late Animation<double> _textFade;
  late Animation<Offset> _textSlide;

  // Phase 4: Loading bar
  late Animation<double> _loadingProgress;
  late Animation<double> _loadingFade;

  // Pulse (continuous)
  late Animation<double> _pulseAnimation;

  // Shimmer (continuous)
  late Animation<double> _shimmerAnimation;

  @override
  void initState() {
    super.initState();

    // Set status bar to transparent for immersive feel
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
    // Main orchestrator: 3 seconds total
    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );

    // Pulse controller: loops continuously
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    // Shimmer controller: loops continuously
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    // --- Phase 1: Logo entrance (0% → 35%) ---
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

    // --- Phase 2: Glow ring (20% → 55%) ---
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

    // --- Phase 3: Text reveal (45% → 70%) ---
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

    // --- Phase 4: Loading bar (60% → 100%) ---
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

    // Continuous pulse
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Shimmer sweep
    _shimmerAnimation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _shimmerController, curve: Curves.linear),
    );
  }

  void _startSequence() {
    _mainController.forward();

    // Start pulse loop after logo lands
    Future.delayed(const Duration(milliseconds: 900), () {
      if (mounted) _pulseController.repeat(reverse: true);
    });

    // Start shimmer after text appears
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) _shimmerController.repeat();
    });

    // Navigate after animation completes + brief pause
    Timer(const Duration(milliseconds: 3600), () {
      if (mounted) {
        context.go(Routes.login);
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
                  Color(0xFF181818), // deep charcoal
                  Color(0xFF242424), // main charcoal
                  Color(0xFF2D2D2D), // lighter charcoal
                ],
                stops: [0.0, 0.5, 1.0],
              ),
            ),
            child: Stack(
              children: [
                // Animated background particles
                ..._buildParticles(),

                // Main content
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Glow ring behind logo
                      _buildGlowRing(),

                      const SizedBox(height: 32),

                      // Brand text
                      _buildBrandText(),

                      const SizedBox(height: 48),

                      // Loading bar
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

  /// Builds the logo with glow ring behind it
  Widget _buildGlowRing() {
    return SizedBox(
      width: 200,
      height: 200,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer glow ring
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
                      const Color(0xFFFF4100).withValues(alpha: 0.3),
                      const Color(0xFFFF4100).withValues(alpha: 0.15),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
              ),
            ),
          ),

          // Inner glowing border
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
                    color: const Color(0xFFFF4100).withValues(alpha: 0.4),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFF4100).withValues(alpha: 0.2),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                    BoxShadow(
                      color: const Color(0xFFFF4100).withValues(alpha: 0.10),
                      blurRadius: 40,
                      spreadRadius: 10,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Logo
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

  /// Brand text with shimmer effect
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
                  colors: const [Colors.white, Color(0xFFFF4100), Colors.white],
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

  /// Animated loading bar
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
                        colors: [Color(0xFFFF7A00), Color(0xFFFF4100)],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFF4100).withValues(alpha: 0.5),
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

  /// Subtle floating particles in the background
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

      // Subtle floating motion
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
                  color: const Color(0xFFFF4100).withValues(alpha: 0.3),
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

/// Data class for background particles
class _ParticleData {
  final double x;
  final double y;
  final double size;
  final double maxOpacity;
  final double delay;

  const _ParticleData(this.x, this.y, this.size, this.maxOpacity, this.delay);
}
