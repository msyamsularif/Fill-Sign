import 'dart:typed_data';

import 'package:fill_and_sign/core/utils/utils.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

Future<Uint8List> readNetworkImage(String imageUrl) async {
  final ByteData data =
      await NetworkAssetBundle(Uri.parse(imageUrl)).load(imageUrl);
  final Uint8List bytes = data.buffer.asUint8List();
  return bytes;
}

void main() {
  const String urlImg =
      'https://1.bp.blogspot.com/-6BN5_W0csSI/YXgMHLjSVqI/AAAAAAAANa0/yDOaJGk-_LsD220pRF9_155qDLakpSoPACLcBGAsYHQ/w1200-h630-p-k-no-nu/ttd-singkatan-tanda-tangan.webp';
  group('Testing Utils', () {
    test('Test Store Signature to gallery should return true', () async {
      final signature = await readNetworkImage(urlImg);

      final result = await Utils.storeSignature(
        signature: signature,
      );

      expect(result, true);
    });
  });
}
