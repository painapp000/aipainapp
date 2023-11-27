import 'package:flutter/material.dart';

class SimpleModalDialog extends StatefulWidget {
  final String? jsonResponse; 

  const SimpleModalDialog({Key? key, this.jsonResponse}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SimpleModalDialogState createState() => _SimpleModalDialogState();
}

class _SimpleModalDialogState extends State<SimpleModalDialog> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Container(
        constraints: const BoxConstraints(maxHeight: 350),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.jsonResponse != null) //
                RichText(
                  textAlign: TextAlign.justify,
                  text: TextSpan(
                    text: widget.jsonResponse,
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: Colors.black,
                      wordSpacing: 1,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
