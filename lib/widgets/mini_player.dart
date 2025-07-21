import 'package:flutter/material.dart';

class MiniPlayer extends StatefulWidget {
  final double minHeight;
  final double maxHeight;
  final Widget Function(double height, double percentage) builder;
  const MiniPlayer({
    super.key,
    required this.minHeight,
    required this.maxHeight,
    required this.builder,
  });

  @override
  State<MiniPlayer> createState() => _MiniPlayerState();
}

class _MiniPlayerState extends State<MiniPlayer>
    with SingleTickerProviderStateMixin {
  late double _height;
  late AnimationController _controller;
  late Animation<double> _animation;
  double _startDragHeight = 0;
  double _dragHeight = 0;

  @override
  void initState() {
    super.initState();
    _height = widget.minHeight;

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  void _animateTo(double targetHeight) {
    _animation =
        Tween(begin: _height, end: targetHeight).animate(
          CurvedAnimation(parent: _controller, curve: Curves.easeOut),
        )..addListener(() {
          setState(() {
            _height = _animation.value;
          });
        });

    _controller.forward(from: 0);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final percentage =
        (_height - widget.minHeight) / (widget.maxHeight - widget.minHeight);
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: GestureDetector(
        onPanStart: (details) {
          _startDragHeight = _height;
        },
        onPanUpdate: (details) {
          setState(() {
            _dragHeight = _startDragHeight - details.delta.dy;
            _height = _dragHeight.clamp(0.0, widget.maxHeight);
          });
        },
        onPanEnd: (details) {
          if (_height < widget.minHeight * 0.5) {
            _animateTo(0);
          } else if (_height > widget.maxHeight * 0.6) {
            _animateTo(widget.maxHeight);
          } else {
            _animateTo(widget.minHeight);
          }
        },
        child: Material(
          elevation: 10,
          color: Theme.of(context).canvasColor,
          child: SizedBox(
            height: _height,
            child: widget.builder(_height, percentage),
          ),
        ),
      ),
    );
  }
}
