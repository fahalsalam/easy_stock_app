import 'package:dotted_border/dotted_border.dart';
import 'package:easy_stock_app/controllers/providers/image_provider/image_provider.dart';
import 'package:easy_stock_app/utils/common_widgets/yesnoAlertbox.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerContainer extends StatefulWidget {
  @override
  State<ImagePickerContainer> createState() => _ImagePickerContainerState();
}

class _ImagePickerContainerState extends State<ImagePickerContainer> {
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    final imagePickerProvider = Provider.of<ImagePickerProvider>(context);

    return GestureDetector(
      onTap: () {
        if (imagePickerProvider.selectedImage == null) {
          showImageSourceActionSheet(context, imagePickerProvider);
        } else {}
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: DottedBorder(
          color: Colors.grey,
          strokeWidth: 2,
          borderType: BorderType.RRect,
          dashPattern: const [6, 3],
          radius: const Radius.circular(12),
          child: Container(
              height: MediaQuery.of(context).size.height *
                  0.25, // Use MediaQuery for responsive sizing
              width: MediaQuery.of(context).size.width * 0.9,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(10),
              ),
              child:
                  Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                Visibility(
                  visible: imagePickerProvider.selectedImage != null,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                                onPressed: () {
                                  yesnoAlertDialog(
                                    context: context,
                                    message: 'Do you want to remove Image?',
                                    screenHeight: screenHeight,
                                    screenWidth: screenWidth,
                                    onNo: () {
                                      Navigator.pop(context);
                                    },
                                    onYes: () {
                                      imagePickerProvider.deleteImage1();
                                      Navigator.pop(context);
                                      showImageSourceActionSheet(
                                          context, imagePickerProvider);
                                    },
                                    buttonYesText: "Yes",
                                    buttonNoText: "No",
                                  );
                                },
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.grey,
                                ))
                          ],
                        ),
                      ),
                      // SizedBox(
                      //   height: screenHeight * 0.05,
                      // ),
                    ],
                  ),
                ),
                Visibility(
                  visible: imagePickerProvider.selectedImage == null,
                  child: SizedBox(
                    height: screenHeight * 0.1,
                  ),
                ),
                imagePickerProvider.isLoading
                    ? SizedBox(
                        height: screenHeight * 0.1,
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        ),
                      )
                    : imagePickerProvider.selectedImage != null
                        ? SizedBox(
                            height: screenHeight * 0.15,
                            width: screenWidth * 0.6,
                            child: Image.file(
                              imagePickerProvider.selectedImage!,
                              fit: BoxFit.contain,
                            ),
                          )
                        : const Center(
                            child: Text(
                              'Tap to select image',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
              ])),
        ),
      ),
    );
  }
}

// Function to show the action sheet to choose between camera and gallery
void showImageSourceActionSheet(
    BuildContext context, ImagePickerProvider provider) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Wrap(
        children: <Widget>[
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text('Pick from Gallery'),
            onTap: () {
              provider.pickImage(ImageSource.gallery, context, 'products');
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text('Capture from Camera'),
            onTap: () {
              provider.pickImage(ImageSource.camera, context,
                  'products'); // Updated to allow image capture
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );
}
