import 'dart:ui';

import 'package:flutter/material.dart';

class LoadingBlur extends StatelessWidget {
  final Size size;

  const LoadingBlur({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
      child: Container(
        width: size.width,
        height: size.height,
        decoration: BoxDecoration(color: Colors.grey.shade200.withOpacity(0.5)),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Loading...', style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(
                height: 10,
              ),
              const CircularProgressIndicator()
            ],
          ),
        ),
      ),
    );
  }
}
