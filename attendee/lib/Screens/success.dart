import 'package:attendee/constants.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class entrySuccessful extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool success = true;
    showToast(
        'Marked as Present!', Colors.black, Colors.green, Toast.LENGTH_LONG);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: Text(
          'Success',
          style: TextStyle(color: Colors.lightGreen),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Stack(alignment: Alignment.center, children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                    image: NetworkImage(
                      'https://i.pinimg.com/originals/70/a5/52/70a552e8e955049c8587b2d7606cd6a6.gif',
                    ),
                    fit: BoxFit.cover),
              ),
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 18.0),
          //   child: Text('Success full marked as present!'),
          // ),
        ]),
        // child: Column(
        //   children: <Widget>[
        //     //Image.asset('assets/images/Payment_Successful.gif')
        //     Image.network(
        //         'https://i.pinimg.com/originals/70/a5/52/70a552e8e955049c8587b2d7606cd6a6.gif'),
        //   ],
        // ),
      ),
    );
    //   body: Image.network(
    //     'https://i.pinimg.com/originals/70/a5/52/70a552e8e955049c8587b2d7606cd6a6.gif',
    //     fit: BoxFit.cover,
    //     loadingBuilder: (BuildContext context, Widget child,
    //         ImageChunkEvent loadingProgress) {
    //       if (loadingProgress == null) {
    //         success = false;
    //         return child;
    //       }
    //       return Center(
    //         child: CircularProgressIndicator(
    //           value: loadingProgress.expectedTotalBytes != null
    //               ? loadingProgress.cumulativeBytesLoaded /
    //                   loadingProgress.expectedTotalBytes
    //               : null,
    //         ),
    //       );
    //     },
    //   ),
    // );
    // if (success)
    //   showToast(
    //       'Marked as Present!', Colors.black, Colors.green, Toast.LENGTH_LONG);
  }
}
