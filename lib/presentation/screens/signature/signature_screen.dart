import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:signature/signature.dart';

import '../../../core/utils/utils.dart';
import '../../app_theme.dart';
import '../signature_detail/signature_detail_screen.dart';

class SignatureScreen extends StatefulWidget {
  const SignatureScreen({Key? key}) : super(key: key);

  @override
  State<SignatureScreen> createState() => _SignatureScreenState();
}

class _SignatureScreenState extends State<SignatureScreen> {
  SignatureController signatureController = SignatureController();

  @override
  void initState() {
    signatureController = SignatureController(
      penStrokeWidth: 3,
      penColor: Colors.black,
    );
    super.initState();
  }

  Future listenController() async {
    signatureController.addListener(() {
      if (signatureController.isNotEmpty || signatureController.isEmpty) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    signatureController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Signature'),
      ),
      body: FutureBuilder(
        future: listenController(),
        builder: (context, snapshot) => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: DottedBorder(
                color: AppTheme.secoundColor,
                borderType: BorderType.RRect,
                radius: const Radius.circular(10),
                dashPattern: const [5, 5, 5, 5, 5, 5],
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Signature(
                      height: (MediaQuery.of(context).orientation ==
                              Orientation.landscape)
                          ? MediaQuery.of(context).size.height * 0.4
                          : 250,
                      width: MediaQuery.of(context).size.width - 32,
                      controller: signatureController,
                      backgroundColor: Colors.transparent,
                    ),
                    if (signatureController.isEmpty) ...[
                      Column(
                        children: [
                          Icon(
                            MdiIcons.drawPen,
                            size: 50,
                            color: AppTheme.secoundColor,
                          ),
                          const SizedBox(height: 15),
                          const Text(
                            "Silahkan gambar tanda tangan digital di sini",
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      )
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            buildButtons(context),
            buildSwapOrientation(),
          ],
        ),
      ),
    );
  }

  Widget buildButtons(BuildContext context) => Container(
        color: AppTheme.secoundColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            buildCheck(context),
            Container(
              height: 50,
              width: 2,
              color: Colors.white,
            ),
            buildClear(),
          ],
        ),
      );

  Widget buildCheck(BuildContext context) => IconButton(
        iconSize: 36,
        icon: const Icon(MdiIcons.checkBold, color: Colors.green),
        onPressed: () async {
          final isLanscape =
              MediaQuery.of(context).orientation == Orientation.landscape;

          if (signatureController.isNotEmpty) {
            final signature = await Utils.exportSignature(
              signatureController: signatureController,
            );

            if (isLanscape) {
              // Set orientation to potrait Up
              SystemChrome.setPreferredOrientations(
                [DeviceOrientation.portraitUp],
              );
            }

            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) =>
                    SignatureDetailScreen(signature: signature),
              ),
            );

            signatureController.clear();
          }
        },
      );

  Widget buildClear() => IconButton(
        iconSize: 36,
        icon: const Icon(MdiIcons.closeThick, color: Colors.red),
        onPressed: () => signatureController.clear(),
      );

  Widget buildSwapOrientation() {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        final newOrientation =
            isPortrait ? Orientation.landscape : Orientation.portrait;

        signatureController.clear();
        Utils.setOrientation(orientation: newOrientation);
      },
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isPortrait
                  ? Icons.screen_lock_portrait
                  : Icons.screen_lock_landscape,
              size: 40,
            ),
            const SizedBox(width: 12),
            const Text(
              'Tap to change signature orientation',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
