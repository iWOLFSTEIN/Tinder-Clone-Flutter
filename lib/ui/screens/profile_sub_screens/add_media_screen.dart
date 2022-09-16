import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tinder_app_flutter/ui/screens/profile_sub_screens/media_preview_screen.dart';
import 'package:tinder_app_flutter/util/constants.dart';

class AddMediaScreen extends StatefulWidget {
  AddMediaScreen({Key? key}) : super(key: key);
  static String id = '';

  @override
  State<AddMediaScreen> createState() => _AddMediaScreenState();
}

class _AddMediaScreenState extends State<AddMediaScreen> {
  final picker = ImagePicker();
  List<XFile>? imageFileList;

  Future<void> onImageButtonPressed() async {
    try {
      await picker.pickMultiImage().then((value) {
        setState(() {
          imageFileList = value;
        });
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MediaPreviewScreen(
                    imageFileList: imageFileList,
                  )),
        );
        return null;
      });
      // setState(() {
      //   imageFileList = pickedFileList;
      // });
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kSecondaryColor,
        shadowColor: kSecondaryColor,
        title: Text('Add Media'),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Center(
                child: Text(
                  'Add your photos',
                  style: Theme.of(context).textTheme.headline2,
                ),
              ),
              Text(
                'Select any 6 images',
                style: Theme.of(context).textTheme.headline5,
              ),
              GestureDetector(
                onTap: onImageButtonPressed,
                child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 70, vertical: 73),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: kSecondaryColor)),
                    height: height * 0.3,
                    width: width * 0.6,
                    child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: kGrey),
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                        ))),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
