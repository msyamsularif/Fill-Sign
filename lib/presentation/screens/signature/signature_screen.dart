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
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

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
                      height: !isPortrait
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
                            "Please draw a digital signature here",
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
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: isPortrait
                    ? MainAxisAlignment.spaceBetween
                    : MainAxisAlignment.end,
                children: [
                  ButtonAction(
                    title: 'Rotate',
                    icon: isPortrait
                        ? Icons.screen_lock_portrait
                        : Icons.screen_lock_landscape,
                    onPressed: () {
                      final newOrientation = isPortrait
                          ? Orientation.landscape
                          : Orientation.portrait;

                      signatureController.clear();
                      Utils.setOrientation(orientation: newOrientation);
                    },
                  ),
                  if (!isPortrait) ...[
                    const SizedBox(width: 10),
                  ],
                  ButtonAction(
                    title: 'Clear',
                    icon: MdiIcons.broom,
                    onPressed: () => signatureController.clear(),
                  ),
                  if (!isPortrait) ...[
                    const SizedBox(width: 10),
                  ],
                  ButtonAction(
                    title: 'Done',
                    icon: MdiIcons.checkboxMarkedCircleOutline,
                    onPressed: () async {
                      final isLanscape = MediaQuery.of(context).orientation ==
                          Orientation.landscape;

                      if (signatureController.isNotEmpty) {
                        final signature = await Utils.exportSignature(
                          signatureController: signatureController,
                          penColor: Colors.grey[900]!,
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
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      // bottomNavigationBar: SafeArea(
      //   child: Column(
      //     mainAxisSize: MainAxisSize.min,
      //     mainAxisAlignment: MainAxisAlignment.end,
      //     children: [
      //       buildButtons(context),
      //       buildSwapOrientation(),
      //     ],
      //   ),
      // ),
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

class ButtonAction extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onPressed;

  const ButtonAction({
    Key? key,
    required this.title,
    required this.icon,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        primary: AppTheme.secoundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Row(
        children: [
          Icon(icon),
          const SizedBox(width: 5),
          Text(
            title,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
