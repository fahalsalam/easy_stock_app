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

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();

    String appVersion = '';

  @override
  void initState() {
    super.initState();
    _getAppVersion();
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
              // Background Image with blur effect for modern style
              Container(
                height: screenHeight,
                width: screenWidth,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(common_backgroundImage),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                        Colors.black54,
                        BlendMode
                            .darken), // Adding a dark overlay for better text contrast
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: screenHeight * 0.08,
                  horizontal: screenWidth * 0.08,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Title with a larger, bold font
                      Text(
                        'Sign In',
                        style: TextStyle(
                          fontSize: screenHeight * 0.04,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 1.5, // Modern spacing between letters
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.04),

                      // Username Text Field
                      Consumer<SignInProvider>(
                        builder: (context, provider, child) {
                          return Container(
                            height: screenHeight * 0.06,
                            width: screenWidth * 0.98,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12)),
                            child: TextFormField(
                              controller: provider.usernameController,
                              decoration: const InputDecoration(
                                hintText: 'Tenant Name',
                                border: InputBorder.none,
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 16),
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

                      // User Code Text Field
                      Consumer<SignInProvider>(
                        builder: (context, provider, child) {
                          return Container(
                            height: screenHeight * 0.06,
                            width: screenWidth * 0.98,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12)),
                            child: TextFormField(
                              controller: provider.userCodeController,
                              decoration: const InputDecoration(
                                hintText: 'User Code',
                                border: InputBorder.none,
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 16),
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

                      _buildPasswordField(context),
                      SizedBox(height: screenHeight * 0.035),
                      Row(
                        children: [
                          Consumer<SignInProvider>(
                            builder: (context, provider, child) {
                              return Checkbox(
                                activeColor: primaryColor,
                                checkColor: Colors.black,
                                value: provider.isRemembered,
                                onChanged: (bool? value) {
                                  provider.toggleRememberMe(value ?? false);
                                },
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
                      SizedBox(height: screenHeight * 0.0081),
                      // Login Button with gradient and shadow for modern design
                      _buildLoginButton(context),

                      SizedBox(height: screenHeight * 0.01),
                    ],
                  ),
                ),
              ),
              Positioned(
                  bottom: screenHeight * 0.02,
                  left: 0,
                  right: 0,
                  child:  Center(
                    child: Text(
                      'Version: $appVersion',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  // Widget to build text fields with icons
  Widget _buildTextFieldWithIcon(BuildContext context,
      {required String hintText,
      required IconData icon,
      required TextEditingController controller,
      required String validatorMessage}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle:
              TextStyle(color: Colors.grey[600]), // Subtle placeholder color
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          prefixIcon:
              Icon(icon, color: Colors.orange[700]), // Icon at the start
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return validatorMessage;
          }
          return null;
        },
      ),
    );
  }

  // Widget for the password field with an icon and toggle visibility
  Widget _buildPasswordField(BuildContext context) {
    return Consumer<SignInProvider>(
      builder: (context, provider, child) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: TextFormField(
            controller: provider.passwordController,
            obscureText: provider.obscureText,
            decoration: InputDecoration(
              hintText: 'Password',
              hintStyle: TextStyle(color: Colors.grey[600]),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
              border: InputBorder.none,
              prefixIcon: Icon(Icons.lock,
                  color: Colors.orange[700]), // Lock icon at the start
              suffixIcon: IconButton(
                icon: Icon(
                  provider.obscureText
                      ? Icons.visibility_off
                      : Icons.visibility,
                  color: Colors.grey[700],
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

  // Login Button widget
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
                colors: [Colors.orange[600]!, Colors.orange[400]!],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.orangeAccent.withOpacity(0.4),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Center(
              child: provider.isLoading
                  ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                  : Text(
                      "Login",
                      style: TextStyle(
                        fontSize: screenHeight * 0.025,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.0, // Modern look for text
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }
}
