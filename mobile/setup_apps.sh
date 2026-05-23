#!/bin/bash
# Run after Flutter is installed — gets deps for all apps
set -e

APPS=(packages/dormconnect_core student_app staff_app guard_app guardian_app)

for app in "${APPS[@]}"; do
  echo "==> $app"
  (cd "$app" && flutter pub get)
done

echo ""
echo "All dependencies installed."
echo ""
echo "Run an app:"
echo "  cd student_app  && flutter run"
echo "  cd staff_app    && flutter run"
echo "  cd guard_app    && flutter run"
echo "  cd guardian_app && flutter run"
