import 'package:flutter/material.dart';

class SizeConfig {
  final BuildContext context;

  const SizeConfig(this.context);

  double get imageWidth => MediaQuery.of(context).size.width * 0.8;
  double get playButtonWidth => MediaQuery.of(context).size.width * 0.2;
  double get playButtonIconWidth => MediaQuery.of(context).size.width * 0.1;
  double get skipButtonsWidth => MediaQuery.of(context).size.width * 0.1;
  double get remainingButtonsWidth => MediaQuery.of(context).size.width * 0.05;
}
