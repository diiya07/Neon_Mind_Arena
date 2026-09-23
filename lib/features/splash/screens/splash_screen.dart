import 'dart:async';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:tictactoe/core/constants/app_colors.dart';
import 'package:tictactoe/core/utils/ad_service.dart';
import 'package:tictactoe/core/utils/score_service.dart';
import 'package:tictactoe/firebase_options.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    final startTime = DateTime.now();

    try {
      await Future.wait([
        _requestTrackingPermission(),
        Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        ScoreService().init(),
        AdService.initialize(),
      ]);
    } catch (e) {
      debugPrint('[Splash] Init error: $e');
    }

    // Keep splash animation on screen for at least 2200ms
    final elapsed = DateTime.now().difference(startTime).inMilliseconds;
    final remaining = 2200 - elapsed;
    if (remaining > 0) {
      await Future.delayed(Duration(milliseconds: remaining));
    }

    if (mounted) {
      context.go('/');
    }
  }

  static Future<void> _requestTrackingPermission() async {
    try {
      final TrackingStatus status =
          await AppTrackingTransparency.trackingAuthorizationStatus;
      if (status == TrackingStatus.notDetermined) {
        await Future.delayed(const Duration(milliseconds: 200));
        await AppTrackingTransparency.requestTrackingAuthorization();
      }
    } catch (e) {
      debugPrint('[ATT] Tracking request skipped: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background ambient neon glow
          Center(
            child: Container(
              width: 320,
              height: 320,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.neonPurple.withValues(alpha: 0.25),
                    AppColors.neonCyan.withValues(alpha: 0.12),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),
          )
              .animate(onPlay: (controller) => controller.repeat(reverse: true))
              .scale(
                begin: const Offset(0.85, 0.85),
                end: const Offset(1.15, 1.15),
                duration: 1800.ms,
                curve: Curves.easeInOut,
              ),

          // Main Center Content
          SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(flex: 3),

                  // Glowing App Icon
                  Container(
                    width: 130,
                    height: 130,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.neonCyan.withValues(alpha: 0.4),
                          blurRadius: 30,
                          spreadRadius: 2,
                        ),
                        BoxShadow(
                          color: AppColors.neonPink.withValues(alpha: 0.25),
                          blurRadius: 45,
                          spreadRadius: -4,
                        ),
                      ],
                      border: Border.all(
                        color: AppColors.neonCyan.withValues(alpha: 0.6),
                        width: 2,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(26),
                      child: Image.asset(
                        'assets/images/logo.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 600.ms, curve: Curves.easeOut)
                      .scale(
                        begin: const Offset(0.7, 0.7),
                        end: const Offset(1.0, 1.0),
                        duration: 800.ms,
                        curve: Curves.easeOutBack,
                      )
                      .then()
                      .shimmer(
                        duration: 1200.ms,
                        color: AppColors.neonCyan.withValues(alpha: 0.3),
                      ),

                  const SizedBox(height: 32),

                  // Brand Title
                  Text(
                    'NEON MIND ARENA',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Orbitron',
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 3.5,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: AppColors.neonCyan.withValues(alpha: 0.9),
                          blurRadius: 18,
                        ),
                        Shadow(
                          color: AppColors.neonPurple.withValues(alpha: 0.7),
                          blurRadius: 30,
                        ),
                      ],
                    ),
                  )
                      .animate()
                      .fadeIn(delay: 300.ms, duration: 600.ms)
                      .slideY(begin: 0.25, end: 0, duration: 600.ms, curve: Curves.easeOut),

                  const SizedBox(height: 10),

                  // Subtitle
                  Text(
                    'BRAIN GAMES & STRATEGY',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Orbitron',
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 4.0,
                      color: AppColors.neonPink.withValues(alpha: 0.9),
                      shadows: [
                        Shadow(
                          color: AppColors.neonPink.withValues(alpha: 0.6),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                  )
                      .animate()
                      .fadeIn(delay: 500.ms, duration: 600.ms)
                      .slideY(begin: 0.25, end: 0, duration: 600.ms, curve: Curves.easeOut),

                  const Spacer(flex: 3),

                  // Cyberpunk Loading Bar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 56),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: const SizedBox(
                            height: 4,
                            child: LinearProgressIndicator(
                              backgroundColor: AppColors.surfaceElevated,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.neonCyan,
                              ),
                            ),
                          ),
                        )
                            .animate()
                            .fadeIn(delay: 600.ms, duration: 400.ms),

                        const SizedBox(height: 14),

                        Text(
                          'INITIALIZING ARENA...',
                          style: TextStyle(
                            fontFamily: 'Orbitron',
                            fontSize: 10,
                            letterSpacing: 2.5,
                            color: AppColors.textSecondary.withValues(alpha: 0.7),
                          ),
                        )
                            .animate()
                            .fadeIn(delay: 700.ms, duration: 400.ms),
                      ],
                    ),
                  ),

                  const Spacer(flex: 1),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
