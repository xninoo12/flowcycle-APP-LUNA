import 'package:flutter/material.dart';
import 'cycle_data_controller.dart';

/// Inherited scope providing reactive access to [CycleDataController] across the widget tree.
class AppScope extends InheritedNotifier<CycleDataController> {
  const AppScope({
    super.key,
    required CycleDataController controller,
    required super.child,
  }) : super(notifier: controller);

  /// Access the nearest [CycleDataController] in the widget tree,
  /// falling back gracefully to the singleton instance if none is found.
  static CycleDataController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppScope>();
    return scope?.notifier ?? CycleDataController.instance;
  }

  /// Optional lookup of [CycleDataController], falling back to singleton.
  static CycleDataController maybeOf(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppScope>();
    return scope?.notifier ?? CycleDataController.instance;
  }

  /// Access the controller without registering a rebuild dependency.
  static CycleDataController read(BuildContext context) {
    final scope = context.getInheritedWidgetOfExactType<AppScope>();
    return scope?.notifier ?? CycleDataController.instance;
  }
}
