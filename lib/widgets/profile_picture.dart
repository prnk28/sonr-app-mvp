import 'dart:async';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:localstorage/localstorage.dart';
import 'package:sonar_frontend/model/profile_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProfilePicture extends StatelessWidget {
  final ProfileModel profile;
  const ProfilePicture({Key key, this.profile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(profile.profile_picture);
    return InkWell(
        onTap: () {
          _uploadImage();
        },
        child: Center(
            child: Padding(
                child: Container(
                    width: 100.0,
                    height: 100.0,
                    decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        image: new DecorationImage(
                            fit: BoxFit.fill,
                            image: profile.profile_picture == null
                                ? AssetImage("assets/images/blank-profile.png")
                                : CachedNetworkImageProvider(profile.profile_picture)))),
                padding: EdgeInsets.only(top: 10))));
  }

  _uploadImage() async {
    // Get the file from gallery
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);
    var _uuid = new Uuid();
    String imageName = _uuid.v4();

    // Create a reference to Location
    StorageReference reference =
        FirebaseStorage.instance.ref().child(imageName + ".png");
    StorageUploadTask uploadTask = reference.putFile(image);
    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;

    // Await Download URL and set
    return _updateUser(await storageTaskSnapshot.ref.getDownloadURL());
  }

  _updateUser(url) {
     // Delete Previous Pic
    if (profile.profile_picture != null) {
      _deleteFireBaseStorageItem(profile.profile_picture);
    }

    // Save new object
    LocalStorage storage = new LocalStorage('sonar_app');
    profile.profile_picture = url;
    print(profile.toJSONEncodable());
    storage.setItem('user_profile', profile.toJSONEncodable());
    return (url);
  }

  _deleteFireBaseStorageItem(String fileUrl) {
    String filePath = fileUrl.replaceAll(
        new RegExp(
            r'https://firebasestorage.googleapis.com/v0/b/sonar-bt10.appspot.com/o/'),
        '');
    filePath = filePath.replaceAll(new RegExp(r'%2F'), '/');
    filePath = filePath.replaceAll(new RegExp(r'(\?alt).*'), '');
    StorageReference storageReferance = FirebaseStorage.instance.ref();

    storageReferance
        .child(filePath)
        .delete()
        .then((_) => print('Successfully deleted $filePath storage item'));
  }
}
