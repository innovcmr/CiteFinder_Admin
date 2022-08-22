import 'package:flutter/material.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

// class Loading extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: SpinKitThreeBounce(
//         color: Colors.black,
//         size: 25,
//       ),
//     );
//   }
// }

class LoaderWidget extends StatelessWidget {
  final bool dense;

  LoaderWidget({Key? key, this.dense = false}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: dense ? Get.height : null,
      width: dense ? Get.width : null,
      color: dense ? Colors.white : Colors.transparent,
      child: Center(
        child: CircularProgressIndicator(
            color: dense ? Colors.black : Colors.white),
      ),
    );
  }
}
