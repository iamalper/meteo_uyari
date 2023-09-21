import 'package:flutter/material.dart';

Container warningContainer(
        String errorText, String buttonText, void Function() onButtonPress) =>
    Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.red)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Icon(Icons.error_outline),
          Flexible(
            child: Text(errorText),
          ),
          Flexible(
            child:
                TextButton(onPressed: onButtonPress, child: Text(buttonText)),
          )
        ],
      ),
    );
