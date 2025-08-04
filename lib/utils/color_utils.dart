import 'package:flutter/material.dart';

Color primaryColor(BuildContext context) {
  return Theme.of(context).colorScheme.primary;
}

Color secondaryColor(BuildContext context) {
  return Theme.of(context).colorScheme.secondary;
}

Color tertiaryColor(BuildContext context) {
  return Theme.of(context).colorScheme.tertiary;
}

Color inverseColor(BuildContext context) {
  return Theme.of(context).colorScheme.inversePrimary;
}

Color onPrimaryColor(BuildContext context) {
  return primaryColor(context).computeLuminance() > 0.5
      ? Colors.black
      : Colors.white;
}

Color onSecondaryColor(BuildContext context) {
  return secondaryColor(context).computeLuminance() > 0.5
      ? Colors.black
      : Colors.white;
}

Color invertThemeColor(BuildContext context) {
  return Theme.of(context).colorScheme.onPrimary;
}

Color deleteColor(BuildContext context) {
  return Colors.red.shade900.withValues(alpha: 0.5);
}
