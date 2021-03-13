/*
 * Created Date: 2/16/21 11:06 PM
 * Author: Ahmed S.Omer
 *
 * Copyright (c) 2021 SafePass
 *
 */

import 'dart:async';

import 'package:flutter/material.dart';

/// A button that animates between state changes.
/// Progress state is just a small circle with a progress indicator inside
/// Error state is a vibrating error animation
/// Normal state is the button itself
class ProgressButton extends StatefulWidget {
  final VoidCallback onPressed;
  final Widget child;
  final Color backgroundColor;
  final Color progressColor;
  final double cornersRadius;
  final ProgressButtonController controller;

  ProgressButton(
      {Key key,
      @required this.onPressed,
      this.child,
      this.backgroundColor,
      this.progressColor,
      this.cornersRadius,
      @required this.controller})
      : super(key: key);

  @override
  _ProgressButtonState createState() => _ProgressButtonState();
}

enum ProgressButtonState { inProgress, error, normal }

class _ProgressButtonState extends State<ProgressButton>
    with TickerProviderStateMixin {
  AnimationController _errorAnimationController;
  AnimationController _progressAnimationController;
  Animation<Offset> _errorAnimation;
  Animation<BorderRadius> _borderAnimation;
  Animation<double> _widthAnimation;

  double get buttonWidth => _widthAnimation.value ?? 0;
  BorderRadius get borderRadius =>
      _borderAnimation.value ?? BorderRadius.circular(12);

  Color get backgroundColor =>
      widget.backgroundColor ?? Theme.of(context).primaryColor;

  Color get progressColor => widget.progressColor ?? Colors.white;

  Widget get child => widget.child ?? Container();

  ProgressButtonState _currentState = ProgressButtonState.normal;
  ProgressButtonState _oldState = ProgressButtonState.normal;

  StreamSubscription<ProgressButtonState> _stateSubscription;

  @override
  void initState() {
    super.initState();
    _stateSubscription = widget.controller.stateChanges.listen((event) {
      print('state changed $event');
      setButtonState(event);
    });
    _errorAnimationController = new AnimationController(
        vsync: this, duration: Duration(milliseconds: 400));

    _progressAnimationController = new AnimationController(
        vsync: this, duration: Duration(milliseconds: 200));

    // Define errorAnimation sequence
    _errorAnimation = TweenSequence<Offset>([
      TweenSequenceItem<Offset>(
          tween: Tween(begin: Offset(0, 0), end: Offset(0.03, 0)), weight: 1),
      TweenSequenceItem<Offset>(
          tween: Tween(begin: Offset(0.03, 0), end: Offset(-0.03, 0)),
          weight: 2),
      TweenSequenceItem<Offset>(
          tween: Tween(begin: Offset(-0.03, 0), end: Offset(0.03, 0)),
          weight: 2),
      TweenSequenceItem<Offset>(
          tween: Tween(begin: Offset(0.03, 0), end: Offset(-0.03, 0)),
          weight: 2),
      TweenSequenceItem<Offset>(
          tween: Tween(begin: Offset(-0.03, 0), end: Offset(0, 0)), weight: 1)
    ]).animate(CurvedAnimation(
      parent: _errorAnimationController,
      curve: Curves.linear,
    ));
  }

  @override
  void didUpdateWidget(ProgressButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    // React to state changes by comparing old and new state
    if (_oldState != ProgressButtonState.error &&
        _currentState == ProgressButtonState.error) {
      _errorAnimationController.reset();
      _errorAnimationController.forward();
    }
    if (_oldState != ProgressButtonState.inProgress &&
        _currentState == ProgressButtonState.inProgress) {
      _progressAnimationController.stop();
      _progressAnimationController.forward();
    }
    if (_oldState == ProgressButtonState.inProgress &&
        _currentState != ProgressButtonState.inProgress) {
      _progressAnimationController.stop();
      _progressAnimationController.reverse();
    }
  }

  /// A utility function to check whether an animation is running
  bool isAnimationRunning(AnimationController controller) {
    return !controller.isCompleted && !controller.isDismissed;
  }

  @override
  Widget build(BuildContext context) {
    return getErrorAnimatedBuilder();
  }

  void setButtonState(ProgressButtonState newState) {
    setState(() {
      _oldState = _currentState;
      _currentState = newState;
    });
  }

  AnimatedBuilder getErrorAnimatedBuilder() {
    return AnimatedBuilder(
        animation: _errorAnimationController,
        builder: (context, child) {
          return SlideTransition(
              position: _errorAnimation,
              child: LayoutBuilder(builder: getProgressAnimatedBuilder));
        });
  }

  AnimatedBuilder getProgressAnimatedBuilder(
      BuildContext context, BoxConstraints constraints) {
    var buttonHeight = constraints.maxHeight;
    var iButtonWidth = constraints.maxWidth;
    // If there is no constraint on height, we should constrain it
    if (buttonHeight == double.infinity) buttonHeight = 56;
    if (iButtonWidth == double.infinity) iButtonWidth = 200;

    // These animation configurations can be tweaked to have
    // however you like it
    _borderAnimation = BorderRadiusTween(
            begin: BorderRadius.circular(widget.cornersRadius ?? 12),
            end: BorderRadius.circular(buttonHeight / 2))
        .animate(CurvedAnimation(
            parent: _progressAnimationController, curve: Curves.linear));

    _widthAnimation = Tween<double>(
      begin: iButtonWidth,
      end: buttonHeight, // Circular progress must be contained in a square
    ).animate(CurvedAnimation(
      parent: _progressAnimationController,
      curve: Curves.linear,
    ));

    Widget buttonContent;

    if (_currentState != ProgressButtonState.inProgress) {
      buttonContent = child;
    } else if (_currentState == ProgressButtonState.inProgress) {
      buttonContent = SizedBox(
          height: buttonHeight,
          width: buttonHeight, // needs to be a square container
          child: Padding(
            padding: EdgeInsets.all(8),
            child: CircularProgressIndicator(
              valueColor:
                  AlwaysStoppedAnimation<Color>(progressColor ?? Colors.white),
              strokeWidth: 3,
            ),
          ));
    }

    return AnimatedBuilder(
      animation: _progressAnimationController,
      builder: (context, child) {
        return InkWell(
            onTap: widget.onPressed,
            borderRadius: borderRadius,
            // this fixes the ripple effect
            child: Center(
              child: Ink(
                width: buttonWidth,
                height: buttonHeight,
                decoration: BoxDecoration(
                  borderRadius: borderRadius,
                  color: backgroundColor,
                ),
                child: Center(child: buttonContent),
              ),
            ));
      },
    );
  }

  @override
  void dispose() {
    _stateSubscription.cancel();
    _errorAnimationController.dispose();
    _progressAnimationController.dispose();
    super.dispose();
  }
}

class ProgressButtonController {
  Stream<ProgressButtonState> get stateChanges async* {
    yield* _controller.stream;
  }

  final _controller = StreamController<ProgressButtonState>();
  void setButtonState(ProgressButtonState state) {
    _controller.add(state);
  }
}
