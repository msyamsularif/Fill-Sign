import 'package:flutter/material.dart';

import '../app_theme.dart';

/// This method to display a custom dialog
///
/// [context] to get context from parent
/// [barrierDismissible] The barrierDismissible argument is used to indicate whether tapping on the barrier will dismiss the dialog. It is true by default and can not be null.
/// [child] to display the contents of the dialog
Future<T?> showCustomDialog<T>({
  required BuildContext context,
  bool barrierDismissible = true,
  required Widget child,
}) async {
  return showDialog<T>(
    barrierDismissible: barrierDismissible,
    context: context,
    barrierColor: AppTheme.secoundColor.withOpacity(0.2),
    builder: (context) => WillPopScope(
      onWillPop: () async {
        return barrierDismissible;
      },
      child: AlertDialog(
        contentPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.maxFinite,
              child: ScrollConfiguration(
                behavior: NoGlowBehavior(),
                child: child,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

/// This method to display a selection of existing information
///
/// [context] to get context from parent
/// [barrierDismissible] The barrierDismissible argument is used to indicate whether tapping on the barrier will dismiss the dialog. It is true by default and can not be null.
/// [title] to display the title of the dialog
/// [textTitleAlign] how the text should be aligned horizontally on title.
/// [subTitle] to display the sub title of the dialog
/// [textSubTitleAlign] how the text should be aligned horizontally on sub title.
/// [colorSubtitle] to give color to subtitles text
/// [labelCancel] to display the text of the cancel button
/// [labelOK] to display the text of the OK button
/// [onCancelButtonPressed] to create a function from the cancel button
/// [onOKButtonPressed] to create a function from the OK button
/// [usingCancelButton] to display the cancel button by default it is false
/// [child] to display the contents of the dialog
Future<T?> showInfoDialog<T>({
  required BuildContext context,
  bool barrierDismissible = true,
  String? title,
  TextAlign? textTitleAlign,
  String? subTitle,
  Color? colorSubtitle,
  TextAlign? textSubTitleAlign,
  String labelCancel = 'Cancel',
  String labelOK = 'OK',
  void Function()? onCancelButtonPressed,
  void Function()? onOKButtonPressed,
  bool usingCancelButton = false,
  required Widget child,
}) async {
  return showDialog<T>(
    barrierDismissible: barrierDismissible,
    context: context,
    barrierColor: AppTheme.secoundColor.withOpacity(0.2),
    builder: (context) => WillPopScope(
      onWillPop: () async {
        return barrierDismissible;
      },
      child: AlertDialog(
        contentPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        content: Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (title != null) ...[
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Text(
                    title,
                    textAlign: textTitleAlign ?? TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                (subTitle != null)
                    ? const SizedBox(height: 6.0)
                    : const SizedBox(height: 8.0),
              ],
              if (subTitle != null) ...[
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Text(
                    subTitle,
                    textAlign: textSubTitleAlign ?? TextAlign.center,
                    style: TextStyle(
                      color: colorSubtitle ?? Colors.black,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 8.0),
              ],
              SizedBox(
                width: double.maxFinite,
                child: ScrollConfiguration(
                  behavior: NoGlowBehavior(),
                  child: child,
                ),
              ),
              IntrinsicHeight(
                child: Row(
                  children: [
                    if (usingCancelButton)
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(
                                  color: Theme.of(context).dividerColor),
                              right: BorderSide(
                                  color: Theme.of(context).dividerColor),
                            ),
                          ),
                          child: InkWell(
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(12.0),
                            ),
                            onTap: onCancelButtonPressed ??
                                () => Navigator.of(context).pop(false),
                            child: Padding(
                              padding: const EdgeInsets.all(14.0),
                              child: Text(
                                labelCancel,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(
                              color: Theme.of(context).dividerColor,
                            ),
                          ),
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.only(
                            bottomLeft: usingCancelButton
                                ? Radius.zero
                                : const Radius.circular(12.0),
                            bottomRight: const Radius.circular(12.0),
                          ),
                          onTap: onOKButtonPressed,
                          child: Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: Text(
                              labelOK,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: (onOKButtonPressed != null)
                                    ? AppTheme.secoundColor
                                    : Colors.grey,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class NoGlowBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
