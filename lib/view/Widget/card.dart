import 'package:flutter/material.dart';

class ReusableCard extends StatelessWidget {
  final String label;
  final String backgroundAsset; // New property for the background image
  final double textTop;
  final double textLeft;
  final Function()? onTap; // Function to be executed on tap

  const ReusableCard({super.key,
    required this.label,
    required this.backgroundAsset, // Specify the background image asset
    this.textTop = 0.00,
    this.textLeft = 0.20,
    this.onTap, // Function to be executed on tap
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: GestureDetector(
        onTap: onTap, // Execute the onTap function when tapped
        child: Container(
          height: 150,
          width: 220,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/Game/BG.png"), // Use the specified background image
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                top: MediaQuery.of(context).size.height * textTop,
                left: MediaQuery.of(context).size.height * textLeft,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Text(
                    label,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              Positioned(child: Image.network(backgroundAsset),),
            ],
          ),
        ),
      ),
    );
  }
}
