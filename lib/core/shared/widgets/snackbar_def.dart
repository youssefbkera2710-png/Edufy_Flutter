import 'package:flutter/material.dart';
import 'package:get/get.dart';

SnackbarController snackBarDef(
  String title,
  String message, {
  bool isError = false,
}) {
  return Get.snackbar(
    title,
    message,
    snackPosition: SnackPosition.TOP,
    backgroundColor: isError
        ? const Color(0xFF0C4765)
        : const Color(0xFF25BEB2), 
    colorText: Colors.white,
    borderRadius: 15,
    margin: const EdgeInsets.all(15),
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),

    icon: Icon(
      isError ? Icons.error_outline : Icons.school_outlined,
      color: Colors.white,
      size: 28,
    ),

    duration: const Duration(seconds: 3),
    boxShadows: [
      BoxShadow(
        color: Colors.black.withOpacity(0.3),
        blurRadius: 10,
        offset: const Offset(0, 5),
      ),
    ],

    backgroundGradient: LinearGradient(
      colors: isError
          ? [const Color(0xFF942D38), const Color(0xFFC74550)]
          : [Color(0xFF25BEB2), Color(0xFF0C4765)],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    ),

    titleText: Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
    ),
    messageText: Text(
      message,
      style: const TextStyle(color: Colors.white70, fontSize: 14),
    ),
  );
}
