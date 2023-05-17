import 'package:flutter/material.dart';

class ImageButton extends StatelessWidget {
  final bool enabled;
  final IconData? icon;
  final Widget? image;
  final double size, radius;
  final double? padding;
  final Color? tint, background;
  final Function()? onClick;

  final StateValue<IconData>? iconState;
  final StateValue<Widget>? imageState;
  final StateValue<Color>? tintState;
  final StateValue<Color>? backgroundState;

  const ImageButton({
    Key? key,
    this.enabled = true,
    this.icon,
    this.image,
    this.size = 24,
    this.radius = 50,
    this.padding,
    this.tint,
    this.background,
    this.onClick,
    this.iconState,
    this.imageState,
    this.tintState,
    this.backgroundState,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var tn = tintState ??
        StateValue<Color?>(
          active: tint,
          inactive: Colors.grey.withOpacity(0.5),
        );
    var bg = backgroundState ??
        StateValue<Color?>(
          active: background ?? Colors.transparent,
          inactive: Colors.grey.withOpacity(0.5),
        );
    var icn = iconState ??
        StateValue<IconData?>(
          active: icon,
          inactive: null,
        );
    var img = imageState ??
        StateValue<Widget?>(
          active: image,
          inactive: null,
        );
    return Material(
      color: bg.detect(enabled),
      borderRadius: BorderRadius.circular(radius),
      child: InkWell(
        borderRadius: BorderRadius.circular(radius),
        onTap: enabled ? onClick : null,
        child: Padding(
          padding: EdgeInsets.all(padding ?? (size / 3)),
          child: img.detect(enabled) ??
              image ??
              Icon(
                icn.detect(enabled),
                color: tn.detect(enabled),
                size: size,
              ),
        ),
      ),
    );
  }
}

class StateValue<T> {
  final T active, inactive;

  const StateValue({
    required this.active,
    T? inactive,
  }) : inactive = inactive ?? active;

  T detect(bool activated) => activated ? active : inactive;
}
