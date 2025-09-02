import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_mate_app/core/theme/color_schemes.dart';
import 'package:movie_mate_app/core/widget/circular_progress_indicator_adaptive.dart';

class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.description,
  });

  final String imageUrl;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.black, Colors.red.shade900],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Stack(
        children: [
          // Background Poster
          Positioned.fill(
            child: Opacity(
              opacity: 0.25,
              child: Image.network(imageUrl, fit: BoxFit.cover),
            ),
          ),

          // Main Content
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: Image.network(imageUrl, height: 250, fit: BoxFit.cover),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Text(
                title,
                textAlign: TextAlign.center,
                style: GoogleFonts.bebasNeue(
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Text(
                  description,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(fontSize: 16),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
