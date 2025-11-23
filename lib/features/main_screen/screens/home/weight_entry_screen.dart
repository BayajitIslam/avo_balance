// screens/weight_entry_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:template/core/constants/app_colors.dart';
import 'package:template/core/themes/app_text_style.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:template/features/main_screen/controllers/navigation_controller.dart';
import 'package:template/features/main_screen/screens/main_screen.dart';
import 'package:template/features/main_screen/widgets/custome_header.dart';
import 'package:template/routes/routes_name.dart';
import 'package:template/widget/custome_button.dart';

class WeightEntryScreen extends StatefulWidget {
  const WeightEntryScreen({super.key});

  @override
  State<WeightEntryScreen> createState() => _WeightEntryScreenState();
}

class _WeightEntryScreenState extends State<WeightEntryScreen>
    with SingleTickerProviderStateMixin {
  bool isKilogram = true;
  double currentWeight = 85.0;
  double animatedWeight = 85.0;
  final TextEditingController weightController = TextEditingController();

  late AnimationController _animationController;
  late Animation<double> _weightAnimation;

  @override
  void initState() {
    super.initState();
    weightController.text = currentWeight.toStringAsFixed(0);

    // Initialize animation controller
    _animationController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );

    _weightAnimation =
        Tween<double>(begin: currentWeight, end: currentWeight).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeInOut,
          ),
        )..addListener(() {
          setState(() {
            animatedWeight = _weightAnimation.value;
          });
        });
  }

  @override
  void dispose() {
    _animationController.dispose();
    weightController.dispose();
    super.dispose();
  }

  void animateToWeight(double targetWeight) {
    _weightAnimation =
        Tween<double>(begin: animatedWeight, end: targetWeight).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeInOut,
          ),
        )..addListener(() {
          setState(() {
            animatedWeight = _weightAnimation.value;
          });
        });

    _animationController.reset();
    _animationController.forward();
  }

  void toggleUnit() {
    setState(() {
      isKilogram = !isKilogram;
      if (isKilogram) {
        currentWeight = currentWeight / 2.20462;
      } else {
        currentWeight = currentWeight * 2.20462;
      }
      weightController.text = currentWeight.toStringAsFixed(0);
      animateToWeight(currentWeight);
    });
  }

  void onTextFieldChanged(String value) {
    if (value.isNotEmpty) {
      final newWeight = double.tryParse(value);
      if (newWeight != null) {
        final maxValue = isKilogram ? 180.0 : 400.0;
        if (newWeight >= 0 && newWeight <= maxValue) {
          currentWeight = newWeight;
          animateToWeight(newWeight);
        }
      }
    }
  }

  void saveWeight() {
    Get.snackbar(
      'Success',
      'Weight saved: ${currentWeight.toStringAsFixed(1)} ${isKilogram ? 'kg' : 'lbs'}',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
    Get.toNamed(RoutesName.home);
    NavigationController controller = Get.find<NavigationController>();

    controller.setCurrentPage(0);
  }

  @override
  Widget build(BuildContext context) {
    return MainScreen(
      child: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 25.h),
            CustomeHeader(title: "Weight"),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20.h),
                    _buildTitleSection(),
                    SizedBox(height: 24.h),
                    Container(
                      padding: EdgeInsets.all(24.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24.r),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0XffCFCFCF),
                            blurRadius: 10,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          _buildUnitToggle(),
                          SizedBox(height: 24.h),
                          _buildGauge(),
                          SizedBox(height: 24.h),
                          _buildWeightInput(),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.h),
                    _buildInfoBox(),
                    SizedBox(height: 24.h),
                    CustomeButton(
                      gradient: AppColors.primaryGradient,
                      onTap: saveWeight,
                      title: 'Save',
                    ),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Enter Your Weight', style: AppTextStyles.s22w7i(fontSize: 20.sp)),
        SizedBox(height: 6.h),
        Text(
          'This will be utilized to adjust your tailored plan?',
          style: AppTextStyles.s14w4i(fontSize: 12.sp),
        ),
      ],
    );
  }

  Widget _buildUnitToggle() {
    return Container(
      height: 48.h,
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(12.r),
      ),
      padding: EdgeInsets.all(6),
      child: Row(
        children: [
          Expanded(
            child: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: InkWell(
                onTap: () {
                  if (!isKilogram) toggleUnit();
                },
                child: Container(
                  decoration: BoxDecoration(
                    gradient: isKilogram ? AppColors.primaryGradient : null,
                    color: isKilogram ? null : Colors.transparent,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Center(
                    child: AnimatedDefaultTextStyle(
                      duration: Duration(milliseconds: 300),
                      style: AppTextStyles.s16w5i(
                        fontweight: FontWeight.w600,
                        color: isKilogram ? Colors.white : Colors.black87,
                      ),
                      child: Text('Kilogram'),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 18),
          Expanded(
            child: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: InkWell(
                onTap: () {
                  if (isKilogram) toggleUnit();
                },
                child: Container(
                  decoration: BoxDecoration(
                    gradient: !isKilogram ? AppColors.primaryGradient : null,
                    color: !isKilogram ? null : Colors.transparent,
                    border: Border.all(color: AppColors.border),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Center(
                    child: AnimatedDefaultTextStyle(
                      duration: Duration(milliseconds: 300),
                      style: AppTextStyles.s16w5i(
                        fontweight: FontWeight.w600,
                        color: !isKilogram ? Colors.white : Colors.black87,
                      ),
                      child: Text('Pounds'),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGauge() {
    final maxValue = isKilogram ? 181.0 : 401.0;

    return Column(
      children: [
        SizedBox(
          height: 280.h,
          child: SfRadialGauge(
            axes: <RadialAxis>[
              RadialAxis(
                minimum: 0,
                maximum: maxValue,
                interval: isKilogram ? 20 : 50,
                startAngle: 180,
                endAngle: 360,
                showLabels: true,
                showTicks: true,
                axisLineStyle: AxisLineStyle(
                  thickness: 0.1,
                  thicknessUnit: GaugeSizeUnit.factor,
                  color: Colors.grey.shade200,
                ),
                majorTickStyle: MajorTickStyle(
                  length: 0.9,
                  thickness: 0,
                  color: Colors.grey.shade400,
                ),
                minorTicksPerInterval: 0,
                minorTickStyle: MinorTickStyle(
                  length: 0.9,
                  thickness: 9,
                  color: Colors.grey.shade300,
                ),
                axisLabelStyle: GaugeTextStyle(
                  fontSize: 14.sp,
                  color: AppColors.black,
                  fontWeight: FontWeight.w400,
                ),
                pointers: <GaugePointer>[
                  NeedlePointer(
                    value: animatedWeight, // Use animated weight
                    needleColor: Color(0xFFE91E63),
                    needleStartWidth: 1,
                    needleEndWidth: 4,
                    needleLength: 0.7,
                    enableAnimation: true, // Enable built-in animation
                    animationDuration: 800, // Animation duration
                    animationType: AnimationType.easeInCirc, // Animation curve
                    knobStyle: KnobStyle(
                      color: Color(0xFFE91E63),
                      borderColor: Colors.white,
                      borderWidth: 0.03,
                      knobRadius: 0.08,
                    ),
                  ),
                ],
                annotations: <GaugeAnnotation>[
                  GaugeAnnotation(
                    widget: AnimatedSwitcher(
                      duration: Duration(milliseconds: 300),
                      transitionBuilder: (child, animation) {
                        return FadeTransition(
                          opacity: animation,
                          child: ScaleTransition(
                            scale: animation,
                            child: child,
                          ),
                        );
                      },
                      child: Text(
                        '${animatedWeight.toStringAsFixed(0)}${isKilogram ? 'kg' : 'lbs'}',
                        key: ValueKey<String>(
                          '${animatedWeight.toStringAsFixed(0)}${isKilogram ? 'kg' : 'lbs'}',
                        ),
                        style: AppTextStyles.s22w7i(fontSize: 20.sp),
                      ),
                    ),
                    angle: 90,
                    positionFactor: 0.6,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWeightInput() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: AppColors.white,
        boxShadow: [
          BoxShadow(color: AppColors.black.withOpacity(0.12), blurRadius: 2),
        ],
      ),
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          SizedBox(width: 13),
          Text('Weight:', style: AppTextStyles.s16w5i()),
          SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: weightController,
              keyboardType: TextInputType.number,
              onChanged: onTextFieldChanged,
              decoration: InputDecoration(
                hintText: 'Enter here',
                hintStyle: AppTextStyles.s14w4i(
                  color: Colors.grey.shade400,
                  fontweight: FontWeight.w500,
                ),
                filled: true,
                fillColor: Colors.grey.shade50,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 12.h,
                ),
              ),
              style: AppTextStyles.s16w5i(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBox() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0XffE8E8E8),
            blurRadius: 5,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.lightbulb_outline, color: Color(0xFFFFA000), size: 22.sp),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              'For accurate measurement, weigh yourself in the morning, on an empty stomach, after using the bathroom.',
              style: AppTextStyles.s14w4i(fontSize: 12.sp),
            ),
          ),
        ],
      ),
    );
  }
}
