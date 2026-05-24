import 'package:flutter/material.dart';

// Global navigator key shared between GoRouter and FCM handler.
// GoRouter uses it as its root navigator key so that navigatorKey.currentState
// resolves to the correct Navigator for imperative pushes from background handlers.
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
