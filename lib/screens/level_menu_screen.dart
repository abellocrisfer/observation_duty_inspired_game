import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'game_screen.dart';

class LevelMenuScreen extends StatelessWidget {
  const LevelMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Choose a LEVEL to Explore',
              style: GoogleFonts.vt323(
                fontSize: 26,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            HoverMenuOption(
              text: "Easy Mode",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const GameScreen(level: 'Easy')),
                );
              },
            ),
            const SizedBox(height: 20),
            HoverMenuOption(
              text: "Normal Mode",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const GameScreen(level: 'Normal')),
                );
              },
            ),
            const SizedBox(height: 20),
            HoverMenuOption(
              text: "Difficult Mode",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const GameScreen(level: 'Difficult')),
                );
              },
            ),
            const SizedBox(height: 20),
            HoverMenuOption(
              text: "Hell Mode",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const GameScreen(level: 'Hell')),
                );
              },
            ),
          ],
        ),
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
            borderRadius: BorderRadius.circular(4),
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
