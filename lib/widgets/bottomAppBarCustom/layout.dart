import 'package:flutter/material.dart';

class AnchoredOverlay extends StatelessWidget {
  final bool showOverlay;
  final Widget Function(BuildContext, Offset anchor) overlayBuilder;
  final Widget child;

  const AnchoredOverlay({super.key, 
    required this.showOverlay,
    required this.overlayBuilder,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return OverlayBuilder(
            showOverlay: showOverlay,
            overlayBuilder: (BuildContext overlayContext) {
              RenderBox box = context.findRenderObject() as RenderBox;
              final center = box.size.center(box.localToGlobal(const Offset(0.0, 0.0)));

              return overlayBuilder(overlayContext, center);
            },
            child: child,
          );
        }
      ),
    );
  }
}

class OverlayBuilder extends StatefulWidget {
  final bool showOverlay;
  final Function(BuildContext) overlayBuilder;
  final Widget child;

  const OverlayBuilder({super.key, 
    this.showOverlay = false,
    required this.overlayBuilder,
    required this.child,
  });

  @override
  _OverlayBuilderState createState() => _OverlayBuilderState();
}

class _OverlayBuilderState extends State<OverlayBuilder> {
  late OverlayEntry overlayEntry;

  @override
  void initState() {
    super.initState();

    if (widget.showOverlay) {
    //  WidgetsBinding.instance.addPostFrameCallback((_) => showOverlay());
    }
  }

  @override
  void didUpdateWidget(OverlayBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
   // WidgetsBinding.instance.addPostFrameCallback((_) => syncWidgetAndOverlay());
  }

  @override
  void reassemble() {
    super.reassemble();
   // WidgetsBinding.instance.addPostFrameCallback((_) => syncWidgetAndOverlay());
  }

  @override
  void dispose() {
    if (isShowingOverlay()) {
      hideOverlay();
    }
    super.dispose();
  }

  bool isShowingOverlay() => overlayEntry != null;

  void showOverlay() {
    overlayEntry = OverlayEntry(
      builder: (BuildContext context) {
        // Get the offset from the overlayBuilder
        final offset = widget.overlayBuilder(context);

        // Now use the CenterAbout widget to display the overlay at the given offset
        return CenterAbout(
          //position: offset, // Pass the correct position
          child: Material(
            color: Colors.transparent, // Ensure transparency of overlay
            child: Container(
              padding: const EdgeInsets.all(20),
              color: const Color.fromARGB(255, 16, 10, 62),
              child: const Text(
                "This is an overlay",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        );
      },
    );
    addToOverlay(overlayEntry);
  }

  void addToOverlay(OverlayEntry entry) {
    Overlay.of(context).insert(entry);
  }

  void hideOverlay() {
    overlayEntry.remove();
  }

  // void syncWidgetAndOverlay() {
  //   if (isShowingOverlay() && !widget.showOverlay) {
  //     hideOverlay();
  //   } else if (!isShowingOverlay() && widget.showOverlay) {
  //     showOverlay();
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

class CenterAbout extends StatelessWidget {
  // final Offset position;
  final Widget child;

  const CenterAbout({super.key, 
    // required this.position,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      // top: position.dy,
      // left: position.dx,
      child: FractionalTranslation(
        translation: const Offset(-0.5, -0.5), // Centers the child around the position
        child: child,
      ),
    );
  }
}