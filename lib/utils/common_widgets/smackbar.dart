// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';



void showSnackBar(
    BuildContext context, String txt, String title, Color titleColor) {
  // Get the screen width and height for responsiveness
  final screenWidth = MediaQuery.of(context).size.width;
  final screenHeight = MediaQuery.of(context).size.height;

  // Get the overlay
  final overlay = Overlay.of(context);

  // Declare the overlayEntry
  late OverlayEntry overlayEntry;

  // Create the overlay entry for the snackbar
  overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      top: screenHeight * 0.06, // Position it at the top
      left: screenWidth * 0.05, // 5% from the left
      right: screenWidth * 0.05, // 5% from the right
      child: Material(
        color: Colors.transparent,
        child: Container(
          height: screenHeight * 0.07,
          width: screenWidth * 0.8,
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.05,
            vertical: screenHeight * 0.002,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: screenWidth * 0.67,
                child: Center(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: screenWidth * 0.04,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              SizedBox(width: screenWidth * 0.01),
              IconButton(
                onPressed: () {
                  overlayEntry.remove(); // Dismiss the overlay
                },
                icon: const Icon(
                  Icons.close,
                  color: Colors.black,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );

  // Insert the overlay entry
  overlay.insert(overlayEntry);

  // Remove the overlay entry after a delay
  Future.delayed(const Duration(seconds: 2), () {
    overlayEntry.remove();
  });
}













void showSnackBarWithsub(
    BuildContext context, String txt, String title, Color titleColor) {
  // Get the screen width and height for responsiveness
  final screenWidth = MediaQuery.of(context).size.width;
  final screenHeight = MediaQuery.of(context).size.height;

  // Declare overlayEntry here
  late OverlayEntry overlayEntry;

  // Create the overlay entry for the snackbar
  overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      top: screenHeight * 0.06, // Position it at the top (10% of screen height)
      left: screenWidth * 0.05, // 5% from the left
      right: screenWidth * 0.05, // 5% from the right
      child: Material(
        color: Colors.transparent,
        child: Container(
          height: screenHeight * 0.09,
          width: screenWidth * 0.8,
          padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.05, // 5% of screen width
              vertical: screenHeight * 0.002 // 2% of screen height
              ),
          decoration: BoxDecoration(
           color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: screenWidth*0.67,
                    child: Center(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: screenWidth * 0.04, // Responsive font size
                          fontWeight: FontWeight.w500,
                          color: Colors.red,
                        ),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  SizedBox(width: screenWidth*0.01,),
                  IconButton(
                    onPressed: () {
                      overlayEntry.remove(); // Dismiss the overlay
                    },
                    icon: const Icon(
                      Icons.close,
                      color: Colors.black,
                      size: 20,
                    ),
                  )
                ],
              ),Text(
                        txt,
                        style: TextStyle(
                          fontSize: screenWidth * 0.033, // Responsive font size
                          fontWeight: FontWeight.w500,
                          color: Colors.black
                        ),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
            ],
          ),
        ),
      ),
    ),
  );

  // Insert the overlay entry
  final overlay = Overlay.of(context);
  overlay.insert(overlayEntry);

  // Remove the overlay entry after a duration if it hasn't been dismissed
  Future.delayed(const Duration(seconds: 2), () {
    overlayEntry.remove();
  });
}









