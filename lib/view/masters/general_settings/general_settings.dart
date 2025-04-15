import 'package:easy_stock_app/controllers/providers/masters_provider/general_settings_provider/general_Setting_provider.dart';
import 'package:easy_stock_app/services/api_services/masters/general_settings/validity_post.dart';
import 'package:easy_stock_app/utils/common_widgets/yesnoAlertbox.dart';
import 'package:easy_stock_app/utils/constants/colors/colors.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:easy_stock_app/utils/common_widgets/background_image_widget.dart';
import 'package:easy_stock_app/utils/common_widgets/custom_appbar.dart';
import 'package:easy_stock_app/utils/constants/images/images.dart';
import 'package:easy_stock_app/view/masters/item_master/add_item/add_item_widget/gradient_button.dart';
import 'package:provider/provider.dart';

class GeneralSettingsPage extends StatefulWidget {
  const GeneralSettingsPage({super.key});

  @override
  State<GeneralSettingsPage> createState() => _GeneralSettingsPageState();
}

class _GeneralSettingsPageState extends State<GeneralSettingsPage> {
  Duration? _selectedTime;
  Timer? _timer;
  Duration? _remainingTime;
  bool isLoading = true;
  Future<void> _pickTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            primaryColor: primaryColor, // Set the primary color
            hintColor: primaryColor, // Set the hint color
            buttonTheme:
                const ButtonThemeData(textTheme: ButtonTextTheme.primary),
            colorScheme: const ColorScheme.dark(
              primary:
                  primaryColor, // Set the primary color for the ColorScheme
              secondary: primaryColor, // Secondary color
              background: Colors.black, // Background color
              surface: Colors.black, // Surface color
              onSurface: Colors.white, // Text color on surface
              onPrimary: Colors.black, // Text color on primary button
              onSecondary: Colors.black, // Text color on secondary button
            ),
          ),
          child: MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child!,
          ),
        );
      },
    );

    if (picked != null) {
      setState(() {
        // Convert TimeOfDay to Duration (in seconds)
        _selectedTime = Duration(hours: picked.hour, minutes: picked.minute);
        _remainingTime = _selectedTime; // Set the initial remaining time
      });
    }
  }

  // Start Countdown Timer
  void _startTimer() {
    if (_selectedTime == null) return;

    setState(() {
      _remainingTime = _selectedTime;
    });

    _timer?.cancel(); // Cancel any existing timer
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime != null && _remainingTime! > Duration.zero) {
          _remainingTime = _remainingTime! - const Duration(seconds: 1);
        } else {
          _timer?.cancel(); // Stop timer when it reaches zero
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Time is up!')),
          );
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

// @override
// void initState() {
//   super.initState();
//   WidgetsBinding.instance.addPostFrameCallback((_) {
//     Provider.of<GeneralSettingProvider>(context, listen: false)
//         .getGeneralSettingsApi()
//         .then((_) {

//       final timeInMinutes = Provider.of<GeneralSettingProvider>(context, listen: false).time;
//       if (timeInMinutes != 0) {
//         _selectedTime = Duration(minutes: timeInMinutes);
//       } else {
//         _selectedTime = null; // Handle null case if necessary
//       }
//       isLoading=false;
//     });
//   });
// }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Provider.of<GeneralSettingProvider>(context, listen: false)
          .getGeneralSettingsApi()
          .then((_) {
        final timeInMinutes =
            Provider.of<GeneralSettingProvider>(context, listen: false).time;

        if (timeInMinutes != 0) {
          setState(() {
            _selectedTime = Duration(minutes: timeInMinutes);
          });
        }
        setState(() {
          isLoading = false;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    final generalSettingsProvider =
        Provider.of<GeneralSettingProvider>(context);
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          BackgroundImageWidget(image: common_backgroundImage),
          Positioned(
            top: screenHeight * 0.06,
            left: screenWidth * 0.02,
            right: screenWidth * 0.02,
            child: CustomAppBar(txt: "General Settings"),
          ),
          Positioned(
            top: screenHeight * 0.15,
            left: 15,
            right: 15,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: isLoading
                  ? SizedBox(
                      width: 50,
                      height: 50,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Display Selected Time
                        Row(
                          children: [
                            Text(
                              _selectedTime != null
                                  ? "Selected Duration: ${_selectedTime?.inHours}h ${_selectedTime!.inMinutes % 60}m"
                                  : "Order Editing Validity",
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600),
                            ),
                            const Spacer(),
                            Visibility(
                              visible: _selectedTime != null,
                              child: gradientElevatedButton(
                                child: const Center(
                                  child: Text(
                                    "Save",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  yesnoAlertDialog(
                                      context: context,
                                      message: 'Do you want to Save?',
                                      screenHeight: screenHeight,
                                      screenWidth: screenWidth,
                                      onYes: () {
                                        generalSettingsProvider
                                            .postGenaralsettingsApi(
                                                _selectedTime!.inMinutes,
                                                context);
                                        Navigator.pop(context);
                                        // Navigator.pop(context);
                                      },
                                      onNo: () {
                                        Navigator.pop(context);
                                      },
                                      buttonYesText: 'Yes',
                                      buttonNoText: 'No');
                                },
                                width: screenWidth * 0.23,
                                height: screenHeight * 0.04,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                        // Gradient Circular Picker
                        Center(
                          child: Container(
                            width: screenWidth * 0.6, // Diameter of the circle
                            height: screenWidth * 0.6,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [
                                  Colors.black,
                                  Colors.grey.shade900,
                                  Colors.grey.shade800,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              border:
                                  Border.all(width: 0.3, color: Colors.grey),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _selectedTime == null
                                    ? IconButton(
                                        onPressed: () {
                                          _pickTime(context);
                                        },
                                        icon: const Icon(
                                          Icons.add,
                                          color: primaryColor,
                                          size: 55,
                                        ),
                                      )
                                    : Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          // Show Selected Time Inside the Circle
                                          Text(
                                            _selectedTime != null
                                                ? " ${_selectedTime?.inHours}h ${_selectedTime!.inMinutes % 60}m"
                                                : "",
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 18),
                                            textAlign: TextAlign.center,
                                          ),
                                          const SizedBox(height: 10),
                                          // Reset or Change Button
                                          IconButton(
                                            onPressed: () {
                                              _pickTime(context);
                                            },
                                            icon: const Icon(
                                              Icons.edit,
                                              color: primaryColor,
                                              size: 35,
                                            ),
                                          ),
                                        ],
                                      ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
