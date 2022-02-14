import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/helper/consts.dart';
import '../../../core/utils/utils.dart';

class SignatureDetailScreen extends StatelessWidget {
  final Uint8List signature;

  const SignatureDetailScreen({
    Key? key,
    required this.signature,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const CloseButton(),
        title: const Text('Signature Preview'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              final bool resultStoreSignature =
                  await Utils.storeSignature(signature: signature);

              if (resultStoreSignature) {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setString(keySignature, base64UrlEncode(signature));

                Navigator.of(context)
                  ..pop()
                  ..pop(signature);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Successfully saved signature'),
                    backgroundColor: Colors.green,
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Failed to save signature'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            icon: const Icon(Icons.done),
          ),
        ],
      ),
      body: Center(
        child: Image.memory(
          signature,
          width: double.infinity,
        ),
      ),
    );
  }
}
