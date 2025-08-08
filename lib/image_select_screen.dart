import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:practice_book/l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as image_lib;

class ImageSelectScreen extends StatefulWidget {
  const ImageSelectScreen({super.key});

  @override
  State<ImageSelectScreen> createState => _ImageSelectScreensState();
}

class _ImageSelectScreensState extends State<ImageSelectScreen> {

  final ImagePicker _picker = ImagePicker();

  Uint8List? _imageBitmap;

  Future<void> _selectImage() async {
    final XFile? imageFile = await _picker.pickImage(source: ImageSource.gallery);

    final imageBitmap = await imageFile?.readAsBytes();
    assert(imageBitmap !=null);
    if (imageBitmap == null) return;

    final image = image_lib.decodeImage(imageBitmap);
    assert(image != null);
    if (image == null) return;
    
    final image_lib.Image resizedImage;
    if (image.width > image.height) {
      resizedImage = image_lib.copyResize(image, width: 500);
    } else {
      resizedImage = image_lib.copyResize(image, height: 500);
    }

    setState(() {
      _imageBitmap = image_lib.encodeBmp(resizedImage);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(l10n.imageSelectScreenTitle),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {},
              child: Text(l10n.imageSelect),
            ),
            ElevatedButton(
              onPressed: () {},
              child: Text(l10n.imageEdit),
            ),
          ],
        ),
      ),
    );
  }
}