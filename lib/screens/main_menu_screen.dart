import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'level_menu_screen.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome to Observation Duty!',
              style: GoogleFonts.vt323(
                fontSize: 26,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Room ',
                    style: GoogleFonts.vt323(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  TextSpan(
                    text: '404',
                    style: GoogleFonts.vt323(
                      fontSize: 18,
                      color: Colors.redAccent,
                      shadows: [
                        Shadow(
                          color: Colors.red.withOpacity(0.8),
                          blurRadius: 10,
                          offset: const Offset(0, 0),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            HoverMenuOption(
              text: "Start Game",
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const LevelMenuScreen()),
                );
              },
            ),
            const SizedBox(height: 20),
            HoverMenuOption(
              text: "Settings",
              onPressed: () {
                _showSettingsDialog(context);
              },
            ),
            const SizedBox(height: 20),
            HoverMenuOption(
              text: "Quit",
              onPressed: () {
                Navigator.of(context).maybePop();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Settings',
          style: GoogleFonts.vt323(),
        ),
        content: Text(
          'Settings screen placeholder here.',
          style: GoogleFonts.vt323(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Close',
              style: GoogleFonts.vt323(),
            ),
          ),
        ],
      ),
    );
  }
}

// Menu with hover effect
class HoverMenuOption extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;

  const HoverMenuOption(
      {super.key, required this.text, required this.onPressed});

  @override
  _HoverMenuOptionState createState() => _HoverMenuOptionState();
}

class _HoverMenuOptionState extends State<HoverMenuOption> {
  bool isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() => isHovering = true);
      },
      onExit: (_) {
        setState(() => isHovering = false);
      },
      child: GestureDetector(
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            border: Border.all(
              color: isHovering ? Colors.greenAccent : Colors.transparent,
              width: 2,
            ),
            boxShadow: isHovering
                ? [
                    BoxShadow(
                      color: Colors.greenAccent.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 6,
                    ),
                  ]
                : [],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            widget.text,
            style: GoogleFonts.vt323(
              fontSize: 20,
              color: isHovering ? Colors.greenAccent : Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
