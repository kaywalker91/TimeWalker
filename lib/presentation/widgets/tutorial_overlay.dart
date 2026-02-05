import 'package:flutter/material.dart';
import 'package:time_walker/core/themes/app_colors.dart';

class TutorialOverlay extends StatefulWidget {
  final Widget child;
  final String message;
  final VoidCallback onDismiss;
  final Alignment alignment;

  const TutorialOverlay({
    super.key,
    required this.child,
    required this.message,
    required this.onDismiss,
    this.alignment = Alignment.center,
  });

  @override
  State<TutorialOverlay> createState() => _TutorialOverlayState();
}

class _TutorialOverlayState extends State<TutorialOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600))
      ..repeat(reverse: true);
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Highlighted Child
        widget.child,

        // Overlay Message and Finger
        Positioned.fill(
          child: GestureDetector(
            onTap: widget.onDismiss,
            behavior: HitTestBehavior.translucent,
            child: Container(
              color: AppColors.black54, // Dim background
              child: Stack(
                children: [
                  // Hole Puncher effect (simplified: just overlaying child on top for now)
                  // In a real advanced tutorial, we'd use CustomPainter with BlendMode.clear
                  
                  Align(
                    alignment: widget.alignment,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Message Bubble
                        Container(
                          padding: const EdgeInsets.all(16),
                          margin: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.black26,
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Text(
                            widget.message,
                            style: const TextStyle(
                              color: AppColors.black87,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 10),
                        // Animated Finger Icon
                        ScaleTransition(
                          scale: _scaleAnimation,
                          child: const Icon(
                            Icons.touch_app,
                            size: 60,
                            color: AppColors.amber,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
