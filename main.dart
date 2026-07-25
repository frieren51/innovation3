import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';

void main() {
  runApp(const HealthTechInnovationApp());
}

class HealthTechInnovationApp extends StatelessWidget {
  const HealthTechInnovationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF020617), // Deepest Slate Blue
      ),
      home: const DroneDeliverySlideshowScreen(),
    );
  }
}

class DroneDeliverySlideshowScreen extends StatefulWidget {
  const DroneDeliverySlideshowScreen({super.key});

  @override
  State<DroneDeliverySlideshowScreen> createState() =>
      _DroneDeliverySlideshowScreenState();
}

class _DroneDeliverySlideshowScreenState
    extends State<DroneDeliverySlideshowScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;
  bool _isAutoPlaying = true;

  // Modern Blue Interleaved Sequence (4 Slides, 2 Images)
  final List<Map<String, dynamic>> newsSlides = [
    {
      'type': 'text',
      'tag': 'FUTURE OF HEALTH',
      'date': 'HEALTHCARE TECH',
      'title': 'Is the Threat of Malaria & Remote Health Crises Increasing?',
      'content':
          'In hard-to-reach rural communities across Africa, traditional road transport is often too slow or impassable during extreme weather, creating severe delays for urgent medical supplies.',
      'accentColor': const Color(0xFF38BDF8), // Electric Sky Blue
      'bgGradient': const [
        Color(0xFF0F172A),
        Color(0xFF1E293B),
        Color(0xFF020617),
      ],
    },
    {
      'type': 'image',
      'tag': 'HARDWARE DISPLAY',
      'asset': 'assets/drone_0.png',
      'caption':
          'Exhibit View: A Zipline autonomous drone displayed at the Gates Foundation Future of Health exhibit.',
    },
    {
      'type': 'text',
      'tag': 'INNOVATION AT WORK',
      'date': 'LOGISTICS REVOLUTION',
      'title': 'Life-Saving Supplies Delivered Directly by Air',
      'content':
          'In countries like Ghana and Rwanda, zero-emission, fixed-wing drones fly autonomously to deliver vaccines, drugs, blood plasma, and cold-chain medical supplies directly to rural points of care.',
      'accentColor': const Color(0xFF60A5FA), // Cobalt Royal Blue
      'bgGradient': const [
        Color(0xFF1E3A8A),
        Color(0xFF0F172A),
        Color(0xFF020617),
      ],
    },
    {
      'type': 'image',
      'tag': 'FIELD OPERATION',
      'asset': 'assets/drone_1.png',
      'caption':
          'Field View: Zero-emission fixed-wing drone navigating rural airspaces to complete cold-chain deliveries.',
    },
  ];

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 7), (timer) {
      if (_currentPage < newsSlides.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      if (mounted) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOutCubic,
        );
      }
    });
  }

  void _nextPage() {
    setState(() {
      _timer?.cancel();
      if (_currentPage < newsSlides.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
      if (_isAutoPlaying) _startTimer();
    });
  }

  void _previousPage() {
    setState(() {
      _timer?.cancel();
      if (_currentPage > 0) {
        _currentPage--;
      } else {
        _currentPage = newsSlides.length - 1;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
      if (_isAutoPlaying) _startTimer();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Page Viewer
          PageView.builder(
            controller: _pageController,
            physics: const BouncingScrollPhysics(),
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemCount: newsSlides.length,
            itemBuilder: (context, index) {
              final slide = newsSlides[index];
              if (slide['type'] == 'text') {
                return _buildModernTextSlide(slide);
              } else {
                return _buildModernImageSlide(slide);
              }
            },
          ),

          // 1. Top Modern Blue Progress Bar
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 12.0,
              ),
              child: Row(
                children: List.generate(newsSlides.length, (index) {
                  return Expanded(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      height: 3,
                      margin: const EdgeInsets.symmetric(horizontal: 3.0),
                      decoration: BoxDecoration(
                        color: _currentPage == index
                            ? const Color(0xFF38BDF8)
                            : Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(4),
                        boxShadow: _currentPage == index
                            ? [
                                BoxShadow(
                                  color: const Color(
                                    0xFF38BDF8,
                                  ).withOpacity(0.6),
                                  blurRadius: 8,
                                ),
                              ]
                            : [],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),

          // 2. Navigation Arrows (Left & Right Controls)
          Positioned.fill(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildNavIconButton(
                      icon: Icons.arrow_back_ios_new_rounded,
                      onPressed: _previousPage,
                    ),
                    _buildNavIconButton(
                      icon: Icons.arrow_forward_ios_rounded,
                      onPressed: _nextPage,
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

  // Modern Navigation Button
  Widget _buildNavIconButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF0F172A).withOpacity(0.4),
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color(0xFF38BDF8).withOpacity(0.25),
              width: 1,
            ),
          ),
          child: IconButton(
            iconSize: 20,
            icon: Icon(icon, color: Colors.white.withOpacity(0.9)),
            onPressed: onPressed,
          ),
        ),
      ),
    );
  }

  // Sundar Glassmorphism Text Slide (Blue Theme)
  Widget _buildModernTextSlide(Map<String, dynamic> slide) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: slide['bgGradient'],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              // Header Badge & Date Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: (slide['accentColor'] as Color).withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: (slide['accentColor'] as Color).withOpacity(
                          0.35,
                        ),
                      ),
                    ),
                    child: Text(
                      slide['tag'],
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                        color: slide['accentColor'],
                      ),
                    ),
                  ),
                  Text(
                    slide['date'],
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.8,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              // Glassmorphism Card with subtle Glow
              ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                  child: Container(
                    padding: const EdgeInsets.all(28.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F172A).withOpacity(0.45),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: const Color(0xFF38BDF8).withOpacity(0.2),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF0284C7).withOpacity(0.1),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          slide['title'],
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            height: 1.25,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          slide['content'],
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white.withOpacity(0.85),
                            height: 1.6,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }

  // Fullscreen Image Slide with Dynamic Tag & Overlay
  Widget _buildModernImageSlide(Map<String, dynamic> slide) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Background Image
        Image.network(
          slide['asset'],
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: const Color(0xFF020617),
              child: const Center(
                child: Icon(
                  Icons.broken_image,
                  color: Colors.white30,
                  size: 48,
                ),
              ),
            );
          },
        ),
        // Dark Blue Gradient Vignette Overlay
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.black45, Colors.transparent, Color(0xFF020617)],
              stops: [0.0, 0.45, 1.0],
            ),
          ),
        ),
        // Bottom Caption Card
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 30.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
                    child: Container(
                      padding: const EdgeInsets.all(18.0),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0F172A).withOpacity(0.65),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color(0xFF38BDF8).withOpacity(0.25),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF0284C7).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              slide['tag'], // Fixed dynamic tag lookup
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF38BDF8),
                                letterSpacing: 1.0,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            slide['caption'],
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.white.withOpacity(0.9),
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
