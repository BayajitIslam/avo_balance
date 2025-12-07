import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:template/features/main_screen/screens/diet/diet_screen.dart';

class RebalancingScreen extends StatefulWidget {
  final String action; // 'add_extra' or 'replace_meal'
  final String? mealType; // Optional: which meal to replace

  const RebalancingScreen({super.key, required this.action, this.mealType});

  @override
  State<RebalancingScreen> createState() => _RebalancingScreenState();
}

class _RebalancingScreenState extends State<RebalancingScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _fadeController;
  late AnimationController _rotationController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startRebalancing();
  }

  void _setupAnimations() {
    _pulseController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _fadeController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));

    _rotationController = AnimationController(
      duration: Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();

    _fadeController.forward();
  }

  void _startRebalancing() async {
    await Future.delayed(Duration(seconds: 2));

    if (mounted) {
      Get.offAll(() => DietScreen());

      // Show success message with meal type if available
      String message;
      if (widget.action == 'add_extra') {
        message = 'Meal added as extra successfully!';
      } else {
        message = widget.mealType != null
            ? '${widget.mealType} replaced successfully!'
            : 'Meal replaced successfully!';
      }

      Get.snackbar(
        'Success',
        message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Color(0xFF10B981),
        colorText: Colors.white,
        margin: EdgeInsets.all(16),
        borderRadius: 12,
        duration: Duration(seconds: 3),
        icon: Icon(Icons.check_circle, color: Colors.white),
      );
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _fadeController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFF8FAFC), Color(0xFFEFF6FF), Color(0xFFFEF3F2)],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Animated loading circles
                  _buildLoadingCircles(),

                  SizedBox(height: 40.h),

                  // Main text
                  Text(
                    'Rebalancing your plan',
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1E293B),
                      letterSpacing: -0.5,
                    ),
                  ),

                  SizedBox(height: 12.h),

                  // Subtitle with action details
                  Text(
                    widget.action == 'add_extra'
                        ? 'Adding meal as extra...'
                        : widget.mealType != null
                        ? 'Replacing ${widget.mealType}...'
                        : 'Optimizing your nutrition...',
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF64748B),
                    ),
                  ),

                  SizedBox(height: 40.h),

                  // Animated dots
                  _buildAnimatedDots(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingCircles() {
    return Stack(
      alignment: Alignment.center,
      children: [
        AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _pulseAnimation.value,
              child: Container(
                width: 160.w,
                height: 160.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFFFF6B35).withOpacity(0.1),
                      Color(0xFFFF1B8D).withOpacity(0.1),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
        Container(
          width: 120.w,
          height: 120.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFFF6B35).withOpacity(0.2),
                Color(0xFFFF1B8D).withOpacity(0.2),
              ],
            ),
          ),
        ),
        RotationTransition(
          turns: _rotationController,
          child: Container(
            width: 90.w,
            height: 90.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: SweepGradient(
                colors: [
                  Color(0xFFFF6B35),
                  Color(0xFFFF1B8D),
                  Color(0xFFFF6B35),
                ],
                stops: [0.0, 0.5, 1.0],
              ),
            ),
            child: Container(
              margin: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
            ),
          ),
        ),
        Container(
          width: 70.w,
          height: 70.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFFF6B35), Color(0xFFFF1B8D)],
            ),
            boxShadow: [
              BoxShadow(
                color: Color(0xFFFF1B8D).withOpacity(0.3),
                blurRadius: 20,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Image.asset("assets/icons/icon.png"),
        ),
      ],
    );
  }

  Widget _buildAnimatedDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        return AnimatedBuilder(
          animation: _rotationController,
          builder: (context, child) {
            final delay = index * 0.3;
            final value = (_rotationController.value + delay) % 1.0;
            final opacity = (value < 0.5 ? value * 2 : (1 - value) * 2);

            return Container(
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              width: 8.w,
              height: 8.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    Color(0xFFFF6B35).withOpacity(opacity),
                    Color(0xFFFF1B8D).withOpacity(opacity),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
