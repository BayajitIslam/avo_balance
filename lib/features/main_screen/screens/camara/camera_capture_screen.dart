// screens/camera_capture_screen.dart
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:template/core/constants/app_colors.dart';
import 'package:template/features/main_screen/screens/camara/image_preview_screen.dart';

class CameraCaptureScreen extends StatefulWidget {
  final String mealType;

  const CameraCaptureScreen({super.key, required this.mealType});

  @override
  State<CameraCaptureScreen> createState() => _CameraCaptureScreenState();
}

class _CameraCaptureScreenState extends State<CameraCaptureScreen> {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  bool _isLoading = true;
  bool _isFlashOn = false;
  int _currentCameraIndex = 0;
  File? _lastImage;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _loadLastImage();
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras!.isNotEmpty) {
        await _setupCamera(_currentCameraIndex);
      }
    } catch (e) {
      print('Error initializing camera: $e');
    }
  }

  Future<void> _setupCamera(int cameraIndex) async {
    if (_controller != null) {
      await _controller!.dispose();
    }

    _controller = CameraController(
      _cameras![cameraIndex],
      ResolutionPreset.high,
      enableAudio: false,
    );

    try {
      await _controller!.initialize();
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error setting up camera: $e');
    }
  }

  Future<void> _loadLastImage() async {
    // Load last captured image from gallery
    // This is placeholder - implement based on your needs
  }

  Future<void> _toggleFlash() async {
    if (_controller == null) return;

    try {
      if (_isFlashOn) {
        await _controller!.setFlashMode(FlashMode.off);
      } else {
        await _controller!.setFlashMode(FlashMode.torch);
      }
      setState(() {
        _isFlashOn = !_isFlashOn;
      });
    } catch (e) {
      print('Error toggling flash: $e');
    }
  }

  Future<void> _flipCamera() async {
    if (_cameras == null || _cameras!.length < 2) return;

    _currentCameraIndex = (_currentCameraIndex + 1) % _cameras!.length;
    setState(() {
      _isLoading = true;
    });
    await _setupCamera(_currentCameraIndex);
  }

  Future<void> _capturePhoto() async {
    if (_controller == null || !_controller!.value.isInitialized) return;

    try {
      final XFile photo = await _controller!.takePicture();

      // Show preview screen
      final result = await Get.to(
        () => ImagePreviewScreen(
          image: File(photo.path),
          mealType: widget.mealType,
        ),
        transition: Transition.fadeIn,
      );

      // Handle result
      if (result == 'retake') {
        // User wants to retake - stay on camera screen
        return;
      } else if (result != null && result is File) {
        // User submitted - return the image
        Get.back(result: result);
      }
      // If result is null, user closed preview - stay on camera
    } catch (e) {
      print('Error capturing photo: $e');
      Get.snackbar('Error', 'Failed to capture photo');
    }
  }

  Future<void> _pickFromGallery() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (image != null) {
        Get.back(result: File(image.path));
      }
    } catch (e) {
      print('Error picking from gallery: $e');
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: Colors.white))
          : Stack(
              children: [
                // Camera Preview with Top Padding
                Positioned(
                  top: 120.h, // Top padding
                  left: 0,
                  right: 0,
                  bottom: 220.h, // Space for bottom controls
                  child: ClipRRect(
                    child:
                        _controller != null && _controller!.value.isInitialized
                        ? CameraPreview(_controller!)
                        : Center(
                            child: Text(
                              'Camera not available',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                  ),
                ),

                // Top Bar (Over Camera)
                Positioned(
                  top: 25.h,
                  left: 0,
                  right: 0,
                  child: SafeArea(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 16.h,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Close Button
                          InkWell(
                            onTap: () => Get.back(),
                            child: Container(
                              padding: EdgeInsets.all(8.w),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.3),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 28.sp,
                              ),
                            ),
                          ),

                          // Flash Toggle
                          InkWell(
                            onTap: _toggleFlash,
                            child: Container(
                              padding: EdgeInsets.all(8.w),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.3),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                _isFlashOn ? Icons.flash_on : Icons.flash_off,
                                color: Colors.white,
                                size: 28.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Bottom Controls
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.only(
                      left: 38.w,
                      right: 38.w,
                      top: 32.h,
                      bottom: 40.h,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(32.r),
                        topRight: Radius.circular(32.r),
                      ),
                      color: AppColors.white,
                    ),
                    child: SafeArea(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Gallery Preview
                          GestureDetector(
                            onTap: _pickFromGallery,
                            child: Container(
                              width: 40.w,
                              height: 40.h,
                              decoration: BoxDecoration(
                                color: const Color(0xffF4F4F4),
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: _lastImage != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(8.r),
                                      child: Image.file(
                                        _lastImage!,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : ShaderMask(
                                      blendMode: BlendMode.srcIn,
                                      shaderCallback: (bounds) => AppColors
                                          .secondaryGradient
                                          .createShader(bounds),
                                      child: Icon(
                                        Icons.photo_library,
                                        color: Colors.black,
                                        size: 18.sp,
                                      ),
                                    ),
                            ),
                          ),

                          // Capture Button
                          GestureDetector(
                            onTap: _capturePhoto,
                            child: Container(
                              width: 72.w,
                              height: 72.h,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 4,
                                ),
                              ),
                              child: Image.asset(
                                "assets/icons/captureimage.png",
                              ),
                            ),
                          ),

                          // Flip Camera
                          GestureDetector(
                            onTap: _flipCamera,
                            child: Container(
                              width: 40.w,
                              height: 40.w,
                              decoration: BoxDecoration(
                                color: const Color(0xffF4F4F4),
                                shape: BoxShape.circle,
                              ),
                              child: Image.asset('assets/icons/flip.png'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
