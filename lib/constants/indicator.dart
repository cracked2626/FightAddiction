import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

const dotIndicator = SizedBox(
  height: 25.0,
  child: LoadingIndicator(
      indicatorType: Indicator.ballPulse,

      /// Required, The loading type of the widget
      colors: [Colors.white],

      /// Optional, The color collections
      strokeWidth: 2,

      /// Optional, The stroke of the line, only applicable to widget which contains line
      backgroundColor: Colors.transparent,

      /// Optional, Background of the widget
      pathBackgroundColor: Colors.transparent

      /// Optional, the stroke backgroundColor
      ),
);
SizedBox showDotIndicator({Color? color}) {
  return SizedBox(
    height: 25.0,
    child: LoadingIndicator(
        indicatorType: Indicator.ballPulse,

        /// Required, The loading type of the widget
        colors: [color ?? Colors.white],

        /// Optional, The color collections
        strokeWidth: 2,

        /// Optional, The stroke of the line, only applicable to widget which contains line
        backgroundColor: Colors.transparent,

        /// Optional, Background of the widget
        pathBackgroundColor: Colors.transparent

        /// Optional, the stroke backgroundColor
        ),
  );
}
