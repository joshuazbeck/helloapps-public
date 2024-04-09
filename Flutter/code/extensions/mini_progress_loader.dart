import 'package:flutter/material.dart';

extension MiniProgressLoader on CircularProgressIndicator {
  Widget mini() {
    return const SizedBox(
      height: 20.0,
      width: 20.0,
      child: Center(child: CircularProgressIndicator()),
    );
  }
}
