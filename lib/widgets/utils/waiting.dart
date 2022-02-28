
import 'package:flutter/material.dart';


class SrWaitingScreen extends StatefulWidget {
  @override
  _SrWaitingScreenState createState() => _SrWaitingScreenState();
}

class _SrWaitingScreenState extends State<SrWaitingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body: Expanded(
      //     child: Center(
      //       child: CircularProgressIndicator(),
      //     )
      // ),
    );
  }
}


class SrWaitingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.1,),
        CircularProgressIndicator(),
        SizedBox(height: MediaQuery.of(context).size.height * 0.1,),
      ],
    );
  }
}
