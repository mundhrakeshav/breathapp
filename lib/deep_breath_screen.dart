import 'package:flutter/material.dart';
import 'dart:math';

class DeepBreathScreen extends StatefulWidget {
  const DeepBreathScreen({super.key});

  @override
  State<DeepBreathScreen> createState() => _DeepBreathScreenState();
}

class _DeepBreathScreenState extends State<DeepBreathScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _sizeAnimation;
  late Animation<Color?> _colorAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _opacityAnimation;
  late Animation<double> _scaleAnimation;

  String _breathText = 'Breathe In'; // Initial text
  int _selectedAnimation = 0; // Randomly selected animation

  @override
  void initState() {
    super.initState();

    // Randomly select an animation (0 to 9)
    _selectedAnimation = Random().nextInt(10);

    // Initialize animation controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15), // Total animation duration
    );

    // Initialize all animations with default values
    _sizeAnimation = Tween<double>(begin: 100, end: 100).animate(_controller);
    _colorAnimation =
        ColorTween(begin: Colors.blue, end: Colors.blue).animate(_controller);
    _rotationAnimation = Tween<double>(begin: 0, end: 0).animate(_controller);
    _slideAnimation = Tween<Offset>(begin: Offset.zero, end: Offset.zero)
        .animate(_controller);
    _opacityAnimation = Tween<double>(begin: 1, end: 1).animate(_controller);
    _scaleAnimation = Tween<double>(begin: 1, end: 1).animate(_controller);

    // Define animations based on the selected animation
    switch (_selectedAnimation) {
      case 0:
        // Animation 1: Circle grows and changes color
        _sizeAnimation = Tween<double>(begin: 100, end: 250).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Curves.easeInOut,
          ),
        );
        _colorAnimation = ColorTween(
          begin: Colors.lightBlue[200],
          end: Colors.lightGreen[200],
        ).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Curves.easeInOut,
          ),
        );
        break;
      case 1:
        // Animation 2: Circle rotates and changes color
        _sizeAnimation = Tween<double>(begin: 100, end: 200).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Curves.easeInOut,
          ),
        );
        _colorAnimation = ColorTween(
          begin: Colors.purple[200],
          end: Colors.pink[200],
        ).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Curves.easeInOut,
          ),
        );
        _rotationAnimation = Tween<double>(begin: 0, end: 2 * pi).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Curves.easeInOut,
          ),
        );
        break;
      case 2:
        // Animation 3: Circle pulses and changes color
        _sizeAnimation = TweenSequence<double>([
          TweenSequenceItem(tween: Tween(begin: 100, end: 250), weight: 50),
          TweenSequenceItem(tween: Tween(begin: 250, end: 100), weight: 50),
        ]).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Curves.easeInOut,
          ),
        );
        _colorAnimation = ColorTween(
          begin: Colors.orange[200],
          end: Colors.yellow[200],
        ).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Curves.easeInOut,
          ),
        );
        break;
      case 3:
        // Animation 4: Circle slides horizontally and changes color
        _sizeAnimation = Tween<double>(begin: 100, end: 200).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Curves.easeInOut,
          ),
        );
        _colorAnimation = ColorTween(
          begin: Colors.teal[200],
          end: Colors.cyan[200],
        ).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Curves.easeInOut,
          ),
        );
        _slideAnimation = Tween<Offset>(
          begin: const Offset(-1, 0), // Start from the left
          end: const Offset(1, 0), // Move to the right
        ).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Curves.easeInOut,
          ),
        );
        break;
      case 4:
        // Animation 5: Fade in and out
        _opacityAnimation = TweenSequence<double>([
          TweenSequenceItem(tween: Tween(begin: 0, end: 1), weight: 50),
          TweenSequenceItem(tween: Tween(begin: 1, end: 0), weight: 50),
        ]).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Curves.easeInOut,
          ),
        );
        break;
      case 5:
        // Animation 6: Scale up and down
        _scaleAnimation = TweenSequence<double>([
          TweenSequenceItem(tween: Tween(begin: 1, end: 1.5), weight: 50),
          TweenSequenceItem(tween: Tween(begin: 1.5, end: 1), weight: 50),
        ]).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Curves.easeInOut,
          ),
        );
        break;
      case 6:
        // Animation 7: Screen slide from left to right
        _slideAnimation = Tween<Offset>(
          begin: const Offset(-1, 0), // Start from the left
          end: const Offset(0, 0), // Move to the center
        ).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Curves.easeInOut,
          ),
        );
        break;
      case 7:
        // Animation 8: Splash effect with scaling and fading
        _scaleAnimation = Tween<double>(begin: 0, end: 1).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Curves.easeInOut,
          ),
        );
        _opacityAnimation = Tween<double>(begin: 0, end: 1).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Curves.easeInOut,
          ),
        );
        break;
      case 8:
        // Animation 9: Bouncing effect
        _sizeAnimation = TweenSequence<double>([
          TweenSequenceItem(tween: Tween(begin: 100, end: 250), weight: 50),
          TweenSequenceItem(tween: Tween(begin: 250, end: 100), weight: 50),
        ]).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Curves.bounceOut,
          ),
        );
        break;
      case 9:
        // Animation 10: Rotating and scaling
        _rotationAnimation = Tween<double>(begin: 0, end: 2 * pi).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Curves.easeInOut,
          ),
        );
        _scaleAnimation = Tween<double>(begin: 1, end: 1.5).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Curves.easeInOut,
          ),
        );
        break;
    }

    // Start the animation
    _controller.forward();

    // Update text dynamically
    _updateBreathText();
  }

  void _updateBreathText() {
    // Breathe In (0-2 seconds)
    Future.delayed(const Duration(seconds: 0), () {
      setState(() {
        _breathText = 'Breathe In';
      });
    });

    // Hold (2-4 seconds)
    Future.delayed(const Duration(seconds: 5), () {
      setState(() {
        _breathText = 'Hold';
      });
    });

    // Breathe Out (4-6 seconds)
    Future.delayed(const Duration(seconds: 10), () {
      setState(() {
        _breathText = 'Breathe Out';
      });
    });

    // Close the screen after 6 seconds
    Future.delayed(const Duration(seconds: 15), () {
      Navigator.pop(context);
    });
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose the controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50], // Light blue background
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Text above the animation
            Text(
              _breathText, // Dynamic text
              style: const TextStyle(
                color: Colors.blue,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20), // Spacing

            // Animation
            Flexible(
              // Use Flexible to avoid overflow
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  switch (_selectedAnimation) {
                    case 0:
                    case 1:
                    case 2:
                    case 3:
                    case 8:
                      // Circle-based animations
                      return Transform.translate(
                        offset: _selectedAnimation == 3
                            ? _slideAnimation.value * 100
                            : Offset.zero, // Slide animation
                        child: Transform.rotate(
                          angle: _selectedAnimation == 1
                              ? _rotationAnimation.value
                              : 0, // Rotation animation
                          child: Container(
                            width: _sizeAnimation.value, // Animated width
                            height: _sizeAnimation.value, // Animated height
                            decoration: BoxDecoration(
                              color: _colorAnimation.value, // Animated color
                              shape: BoxShape.circle, // Circle shape
                            ),
                            child: Center(
                              child: Icon(
                                Icons
                                    .self_improvement, // Icon stays in the same place
                                color: Colors.white,
                                size: _sizeAnimation.value *
                                    0.2, // Scale icon size with circle
                              ),
                            ),
                          ),
                        ),
                      );
                    case 4:
                      // Fade in and out
                      return Opacity(
                        opacity: _opacityAnimation.value,
                        child: const Icon(
                          Icons.self_improvement,
                          size: 100,
                          color: Colors.blue,
                        ),
                      );
                    case 5:
                      // Scale up and down
                      return Transform.scale(
                        scale: _scaleAnimation.value,
                        child: const Icon(
                          Icons.self_improvement,
                          size: 100,
                          color: Colors.blue,
                        ),
                      );
                    case 6:
                      // Screen slide from left to right
                      return SlideTransition(
                        position: _slideAnimation,
                        child: const Icon(
                          Icons.self_improvement,
                          size: 100,
                          color: Colors.blue,
                        ),
                      );
                    case 7:
                      // Splash effect with scaling and fading
                      return Opacity(
                        opacity: _opacityAnimation.value,
                        child: Transform.scale(
                          scale: _scaleAnimation.value,
                          child: const Icon(
                            Icons.self_improvement,
                            size: 100,
                            color: Colors.blue,
                          ),
                        ),
                      );
                    case 9:
                      // Rotating and scaling
                      return Transform.rotate(
                        angle: _rotationAnimation.value,
                        child: Transform.scale(
                          scale: _scaleAnimation.value,
                          child: const Icon(
                            Icons.self_improvement,
                            size: 100,
                            color: Colors.blue,
                          ),
                        ),
                      );
                    default:
                      return const SizedBox.shrink();
                  }
                },
              ),
            ),
            const SizedBox(height: 20), // Spacing

            // Instruction text below the animation
            const Text(
              'Take a deep breath...', // Instruction
              style: TextStyle(
                fontSize: 18,
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
