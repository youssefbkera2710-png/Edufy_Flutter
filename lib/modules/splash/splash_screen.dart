import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:edufy/core/services/notification_handler.dart';
import 'package:edufy/modules/notification/notifications_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_s/responsive_s.dart';

import '../../core/config/user_info.dart';
import '../../core/services/local_storage.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _bgController;
  late final AnimationController _logoController;

  late final Animation<double> _bgScale;
  late final Animation<double> _fade;
  late final Animation<double> _logoScale;

  final AudioPlayer _player = AudioPlayer();

  @override
  void initState() {
    super.initState();

    /// 🌊 Background Zoom Animation
    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    _bgScale = Tween<double>(
      begin: 1.0,
      end: 1.12,
    ).animate(CurvedAnimation(parent: _bgController, curve: Curves.easeOut));

    /// ✨ Logo Animation (Fade + Scale)
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _fade = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _logoController, curve: Curves.easeIn));

    _logoScale = Tween<double>(begin: 0.7, end: 1).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOutBack),
    );

    _bgController.forward();
    _logoController.forward();

    /// 🔊 تشغيل صوت خفيف (اختياري)
    _playSound();

    _navigateToNext();
  }

  Future<void> _playSound() async {
    try {
      await _player.play(AssetSource('sounds/splash.mp3'), volume: 0.3);
    } catch (_) {
      // لو ما في صوت، تجاهل بدون كراش
    }
  }

  void _navigateToNext() {
    Timer(const Duration(seconds: 3), () async {
      LocalStorage storage = LocalStorage();

      bool? onboardingDone = await storage.readBool('onboarding_done');
      String? token = await storage.read('token');
      UserInfo.token = token;
      UserInfo.id = await storage.read('id');
      UserInfo.name = await storage.read('name');
      UserInfo.phone = await storage.read('phone');
      UserInfo.role = await storage.read('role');
      UserInfo.avatar = await storage.read('avatar');
      UserInfo.createdAt = await storage.read('createdAt');
      UserInfo.email = await storage.read('email');

      if (onboardingDone != true) {
        Get.offNamed('/onboarding');
      } else {
        if (token == null) {
          Get.offNamed('/login');
        } else {
          if (NotificationHandler.initialMessage != null) {
            NotificationHandler.initialMessage = null;

            Get.offNamed('/dashboard');

            Future.delayed(const Duration(milliseconds: 300), () {
              Get.to(() => const NotificationsScreen());
            });

            return;
          }
          Get.offNamed('/dashboard');
        }
      }
    });
  }

  @override
  void dispose() {
    _bgController.dispose();
    _logoController.dispose();
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      builder: (sizer) => Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            /// 🌊 Background Zoom
            AnimatedBuilder(
              animation: _bgController,
              builder: (context, child) {
                return Transform.scale(scale: _bgScale.value, child: child);
              },
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/background.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

            /// ✨ Logo Fade + Scale
            Center(
              child: AnimatedBuilder(
                animation: _logoController,
                builder: (context, child) {
                  return Opacity(
                    opacity: _fade.value,
                    child: Transform.scale(
                      scale: _logoScale.value,
                      child: child,
                    ),
                  );
                },
                child: SizedBox(
                  width: sizer.w(300),
                  height: sizer.w(300),
                  child: Image.asset(
                    "assets/images/logo_s.png",
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
