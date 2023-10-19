import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rive/math.dart';
import 'package:rive/rive.dart';

import 'rive_color_component.dart';

class RiveColorModifier extends LeafRenderObjectWidget {
  final Artboard artboard;
  final BoxFit fit;
  final Alignment alignment;
  final List<RiveColorComponent> components;

  const RiveColorModifier({
    super.key,
    required this.artboard,
    this.fit = BoxFit.contain,
    this.alignment = Alignment.center,
    this.components = const [],
  });

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RiveCustomRenderObject(artboard as RuntimeArtboard)
      ..artboard = artboard
      ..fit = fit
      ..alignment = alignment
      ..components = components;
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant RiveCustomRenderObject renderObject) {
    renderObject
      ..artboard = artboard
      ..fit = fit
      ..alignment = alignment
      ..components = components;
  }

  @override
  void didUnmountRenderObject(covariant RiveCustomRenderObject renderObject) {
    renderObject.dispose();
  }
}

/// Create a custom Rive render object to tap into the draw method.
class RiveCustomRenderObject extends RiveRenderObject {
  List<RiveColorComponent> _components = [];

  RiveCustomRenderObject(super.artboard);
  List<RiveColorComponent> get components => _components;

  set components(List<RiveColorComponent> value) {
    if (listEquals(_components, value)) {
      return;
    }
    _components = value;

    for (final component in _components) {
      component.shape = artboard.objects.firstWhereOrNull(
        (element) => element is Shape && element.name == component.shapeName,
      ) as Shape?;

      if (component.shape != null) {
        component.fill = component.shape!.fills
            .firstWhereOrNull((element) => element.name == component.fillName);
        if (component.fill == null) {
          throw Exception('Could not find fill named: ${component.fillName}');
        }
      } else {
        throw Exception('Could not find shape named: ${component.shapeName}');
      }
    }
    markNeedsPaint();
  }

  @override
  void draw(Canvas canvas, Mat2D viewTransform) {
    for (final component in _components) {
      if (component.fill == null) return;

      component.fill!.paint.color =
          component.color.withAlpha(component.fill!.paint.color.alpha);
    }

    super.draw(canvas, viewTransform);
  }
}
