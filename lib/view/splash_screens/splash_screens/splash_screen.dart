import 'package:easy_stock_app/utils/constants/images/images.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../controllers/providers/splash_screen_provider/splash_screen_provider.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
  }
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    // Access SplashProvider to trigger navigation after a delay
    final splashProvider = Provider.of<SplashProvider>(context);
    //to navigate after 3 sec
    splashProvider.navigate(context);

    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            height: screenHeight,
            width: screenWidth,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(background_splash_Image),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Centered Logo
          Center(
            child: SizedBox(
              height: screenHeight * 0.253,
              width: screenWidth * 0.9, 
              child: Image.asset(
                easystockLogo,
                fit: BoxFit.cover,filterQuality: FilterQuality.high,
              ),
            ),
          ),
          Positioned(
           bottom:screenHeight*0.3,
           left: screenWidth*0.5,
            child: const CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 8,
            ),
          )
        ],
      ),
    );
  }
}
