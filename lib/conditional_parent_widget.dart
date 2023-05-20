library conditional_parent_widget;

import 'package:flutter/widgets.dart';

/// {@template conditionalParent}
/// Conditionally wrap a subtree with a parent widget without breaking the code tree.
///
/// - [condition]           controls how/whether the [child] is wrapped.
/// - [child]               the subtree that should always be build.
/// - [parentBuilder]       build this parent with the subtree [child] if [condition] is `true`.
/// - [parentBuilderElse]   build this parent with the subtree [child] if [condition] is `false`.
///                         return [child] if [condition] is `false` and [parentBuilderElse] is null.
///
/// ___________
/// Tree will look like:
/// ```dart
/// return SomeWidget(
///   child: SomeOtherWidget(
///     child: ConditionalParentWidget(
///       condition: shouldIncludeParent,
///       parentBuilder: (Widget child) => SomeParentWidget(child: child),
///       child: Widget1(
///         child: Widget2(
///           child: Widget3(),
///         ),
///       ),
///     ),
///   ),
/// );
/// ```
///
/// ___________
/// Instead of:
/// ```dart
/// Widget child = Widget1(
///   child: Widget2(
///     child: Widget3(),
///   ),
/// );
///
/// return SomeWidget(
///   child: SomeOtherWidget(
///     child: shouldIncludeParent
///       ? SomeParentWidget(child: child)
///       : child
///   ),
/// );
/// ```
/// {@endtemplate}
class ConditionalParentWidget<T> extends StatelessWidget {
  /// {@macro conditionalParent}
  ConditionalParentWidget({
    super.key,
    required this.condition,
    required this.parentBuilder,
    this.parentBuilderElse,
    required this.child,
  }) {
    assert(child is Widget || child is List<Widget>);
  }

  /// The [condition] which controls how/whether the [child] is wrapped.
  final bool condition;

  /// The [child] which should be conditionally wrapped.
  final T child;

  /// Builder to wrap [child] when [condition] is `true`.
  final Widget Function(T child) parentBuilder;

  /// Optional builder to wrap [child] when [condition] is `false`.
  ///
  /// [child] is returned directly when this is `null`.
  final Widget Function(T child)? parentBuilderElse;

  @override
  Widget build(BuildContext context) {
    if (condition) {
      return parentBuilder.call(child);
    } else {
      if (parentBuilderElse != null) {
        return parentBuilderElse!.call(child);
      } else {
        assert(T is Widget,
            "child should be a Widget if parentBuilderElse is null");
        return child as Widget;
      }
    }
  }
}
