// ignore_for_file: use_key_in_widget_constructors, unused_element

import 'package:easy_stock_app/controllers/providers/signIn_provider/signin_provider.dart';
import 'package:easy_stock_app/utils/constants/colors/colors.dart';
import 'package:easy_stock_app/utils/constants/images/images.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  String appVersion = '';
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _getAppVersion();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _getAppVersion() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      setState(() {
        appVersion = packageInfo.version;
      });
    } catch (e) {
      setState(() {
        appVersion = 'Unknown version';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return ChangeNotifierProvider(
      create: (_) => SignInProvider(),
      child: Scaffold(
        body: Form(
          key: _formKey,
          child: Stack(
            children: [
              // Original background image with overlay
              Container(
                height: screenHeight,
                width: screenWidth,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(common_backgroundImage),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Colors.black54,
                      BlendMode.darken,
                    ),
                  ),
                ),
              ),

              // Animated content
              FadeTransition(
                opacity: _fadeAnimation,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: screenHeight * 0.08,
                    horizontal: screenWidth * 0.08,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Modern Sign In header
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 20,
                          ),
                          decoration: BoxDecoration(
                            //  color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            // border: Border.all(
                            //   color: Colors.white.withOpacity(0.2),
                            //   width: 1,
                            // ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // App Name
                              Text(
                                'Easy Stock',
                                style: TextStyle(
                                  fontSize: screenHeight * 0.032,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                  letterSpacing: 1.5,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black.withOpacity(0.3),
                                      offset: const Offset(0, 2),
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                              ),
                              // const SizedBox(height: 8),
                              // Divider
                              // Container(
                              //   width: 100,
                              //   height: 2,
                              //   decoration: BoxDecoration(
                              //     gradient: LinearGradient(
                              //       colors: [
                              //         primaryColor,
                              //         primaryColor.withOpacity(0.5),
                              //       ],
                              //     ),
                              //     borderRadius: BorderRadius.circular(2),
                              //   ),
                              // ),
                              // const SizedBox(height: 12),
                              // Sign In Text
                              // Row(
                              //   mainAxisSize: MainAxisSize.min,
                              //   children: [
                              //     Icon(
                              //       Icons.login_rounded,
                              //       size: 24,
                              //       color: Colors.white.withOpacity(0.9),
                              //     ),
                              //     const SizedBox(width: 8),
                              //     Text(
                              //       'Welcome Back',
                              //       style: TextStyle(
                              //         fontSize: screenHeight * 0.022,
                              //         fontWeight: FontWeight.w500,
                              //         color: Colors.white.withOpacity(0.9),
                              //         letterSpacing: 1,
                              //       ),
                              //     ),
                              //   ],
                              // ),
                            ],
                          ),
                        ),
                        // SizedBox(height: screenHeight * 0.04),

                        // Modern form container
                        Container(
                          padding: const EdgeInsets.all(25),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.2),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            children: [
                              // Tenant Name field
                              Consumer<SignInProvider>(
                                builder: (context, provider, child) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: Colors.white.withOpacity(0.2),
                                      ),
                                    ),
                                    child: TextFormField(
                                      cursorColor: primaryColor,
                                      controller: provider.usernameController,
                                      style:
                                          const TextStyle(color: Colors.white),
                                      decoration: InputDecoration(
                                        hintText: 'Tenant Name',
                                        hintStyle: TextStyle(
                                          color: Colors.white.withOpacity(0.6),
                                        ),
                                        border: InputBorder.none,
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                          horizontal: 20,
                                          vertical: 15,
                                        ),
                                        prefixIcon: Icon(
                                          Icons.business,
                                          color: Colors.white.withOpacity(0.6),
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter your username';
                                        }
                                        return null;
                                      },
                                    ),
                                  );
                                },
                              ),
                              SizedBox(height: screenHeight * 0.02),

                              // User Code field
                              Consumer<SignInProvider>(
                                builder: (context, provider, child) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: Colors.white.withOpacity(0.2),
                                      ),
                                    ),
                                    child: TextFormField(
                                      cursorColor: primaryColor,
                                      controller: provider.userCodeController,
                                      style:
                                          const TextStyle(color: Colors.white),
                                      decoration: InputDecoration(
                                        hintText: 'User Code',
                                        hintStyle: TextStyle(
                                          color: Colors.white.withOpacity(0.6),
                                        ),
                                        border: InputBorder.none,
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                          horizontal: 20,
                                          vertical: 15,
                                        ),
                                        prefixIcon: Icon(
                                          Icons.person_outline,
                                          color: Colors.white.withOpacity(0.6),
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter your user code';
                                        }
                                        return null;
                                      },
                                    ),
                                  );
                                },
                              ),
                              SizedBox(height: screenHeight * 0.02),

                              // Password field
                              _buildPasswordField(context),
                              SizedBox(height: screenHeight * 0.012),

                              // Remember me with modern design
                              Row(
                                children: [
                                  Consumer<SignInProvider>(
                                    builder: (context, provider, child) {
                                      return Container(
                                        // decoration: BoxDecoration(
                                        // color: Colors.white.withOpacity(0.1),
                                        // borderRadius:
                                        //     BorderRadius.circular(6),
                                        // border: Border.all(
                                        //   color:
                                        //       Colors.white.withOpacity(0.2),
                                        // ),
                                        // ),
                                        child: Checkbox(
                                          activeColor: primaryColor,
                                          checkColor: Colors.white,
                                          value: provider.isRemembered,
                                          onChanged: (bool? value) {
                                            provider.toggleRememberMe(
                                                value ?? false);
                                          },
                                        ),
                                      );
                                    },
                                  ),
                                  Text(
                                    'Remember me?',
                                    style: TextStyle(
                                      fontSize: screenHeight * 0.015,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: screenHeight * 0.012),

                              // Login button with modern design
                              _buildLoginButton(context),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Version text with modern design
              Positioned(
                bottom: screenHeight * 0.032,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                        // color: Colors.black.withOpacity(0.3),
                        // borderRadius: BorderRadius.circular(20),
                        // border: Border.all(
                        //   color: Colors.white.withOpacity(0.1),
                        // ),
                        ),
                    child: Text(
                      'Version: $appVersion',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Modern Password Field
  Widget _buildPasswordField(BuildContext context) {
    return Consumer<SignInProvider>(
      builder: (context, provider, child) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
            ),
          ),
          child: TextFormField(
            cursorColor: primaryColor,
            controller: provider.passwordController,
            obscureText: provider.obscureText,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Password',
              hintStyle: TextStyle(
                color: Colors.white.withOpacity(0.6),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 15,
              ),
              border: InputBorder.none,
              prefixIcon: Icon(
                Icons.lock_outline,
                color: Colors.white.withOpacity(0.6),
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  provider.obscureText
                      ? Icons.visibility_off
                      : Icons.visibility,
                  color: Colors.white.withOpacity(0.6),
                ),
                onPressed: provider.togglePasswordVisibility,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              return null;
            },
          ),
        );
      },
    );
  }

  // Modern Login Button
  Widget _buildLoginButton(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return Consumer<SignInProvider>(
      builder: (context, provider, child) {
        return GestureDetector(
          onTap: provider.isLoading
              ? null
              : () async {
                  if (_formKey.currentState!.validate()) {
                    await provider.signIn(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please Enter All Fields')),
                    );
                  }
                },
          child: Container(
            height: screenHeight * 0.06,
            width: screenWidth * 0.9,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  primaryColor,
                  primaryColor.withOpacity(0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: provider.isLoading
                  ? const CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 3,
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Login",
                          style: TextStyle(
                            fontSize: screenHeight * 0.025,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 1.5,
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                        ),
                      ],
                    ),
            ),
          ),
        );
      },
    );
  }
}
