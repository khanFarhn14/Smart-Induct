import 'package:flutter/material.dart';

class Widgets{
  static void showSnackBarForFeedback({required BuildContext cntxt, required String message, required bool isError})
  {
    ScaffoldMessenger.of(cntxt).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        elevation: 0,
        margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        backgroundColor: Colors.black54,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8)
        ),
        content: Row(
          children: [
            isError ? Icon(Icons.error_outline_rounded, color: Colors.red[400],size: 24,):
            Icon(Icons.done, color: Colors.green[400],size: 24,),
            const SizedBox(width: 12,),
            Text(
              message,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal
              ),
              textAlign: TextAlign.start,
            ),
          ],
        ),
        duration: const Duration(milliseconds: 1000),
        action: SnackBarAction
        (
          label: "Ok",
          onPressed: (){},
          textColor: Colors.white,
        ),
      )
    );
  }

    // Loading
  static Widget loading() => const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.black, strokeWidth: 1),);
}