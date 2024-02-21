import 'package:flutter/material.dart';

class CustomeCon extends StatelessWidget {
  final String imageAsset;
  final VoidCallback onTap;

  CustomeCon({Key? key, required this.imageAsset, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 33,
        width: 33,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(imageAsset),
          ),
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
