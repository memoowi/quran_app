import 'package:flutter/material.dart';

class ScrollButton extends StatefulWidget {
  final VoidCallback onPressed;
  final ScrollController scrollController;

  const ScrollButton({
    super.key,
    required this.onPressed,
    required this.scrollController,
  });

  @override
  _ScrollButtonState createState() => _ScrollButtonState();
}

class _ScrollButtonState extends State<ScrollButton> {
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(() {
      setState(() {
        _visible = widget.scrollController.offset > 50;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: _visible,
      child: FloatingActionButton(
        onPressed: widget.onPressed,
        shape: CircleBorder(),
        elevation: 5.0,
        child: Icon(Icons.arrow_upward),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        splashColor: Colors.green,
      ),
    );
  }
}
