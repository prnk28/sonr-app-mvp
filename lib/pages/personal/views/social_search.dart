import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sonr_app/style/style.dart';
import 'package:sonr_plugin/sonr_plugin.dart';

class SocialUserSearchField extends StatefulWidget {
  final String? value;
  final ValueChanged<String>? onChanged;
  final Function(Contact_Social)? onEditingComplete;
  final Iterable<String>? autofillHints;
  final Contact_Social_Media? provider;

  factory SocialUserSearchField.medium({
    String? value,
    ValueChanged<String>? onChanged,
    Iterable<String>? autofillHints,
    Function? onSuggestionTap,
  }) {
    return SocialUserSearchField(Contact_Social_Media.Medium, value: value);
  }

  factory SocialUserSearchField.twitter({
    required String value,
    ValueChanged<String>? onChanged,
    Iterable<String>? autofillHints,
    Function? onSuggestionTap,
  }) {
    return SocialUserSearchField(Contact_Social_Media.Twitter, value: value);
  }

  factory SocialUserSearchField.youtube({
    required String value,
    ValueChanged<String>? onChanged,
    Iterable<String>? autofillHints,
    Function? onSuggestionTap,
  }) {
    return SocialUserSearchField(Contact_Social_Media.YouTube, value: value);
  }

  SocialUserSearchField(
    this.provider, {
    required this.value,
    this.onChanged,
    this.onEditingComplete,
    this.autofillHints,
  });

  @override
  _SocialUserSearchFieldState createState() => _SocialUserSearchFieldState();
}

class _SocialUserSearchFieldState extends State<SocialUserSearchField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(alignment: Alignment.center, children: [
        BoxContainer(
            margin: EdgeInsets.only(left: 8, right: 8, top: 2, bottom: 4),
            padding: EdgeInsets.symmetric(vertical: 14, horizontal: 18),
            child: Stack(alignment: Alignment.center, children: [
              Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                    ShaderMask(
                      shaderCallback: (bounds) {
                        return DesignGradients.AmourAmour.createShader(bounds);
                      },
                      child: Icon(
                        Icons.search,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                    Container(
                      height: 20,
                      width: Get.width - 40,
                      padding: const EdgeInsets.only(left: 4.0),
                      child: TextField(
                        showCursor: false,
                        autofocus: true,
                        onChanged: (val) async {},
                        decoration: InputDecoration.collapsed(hintText: "Search...", hintStyle: TextStyle(color: Colors.black38)),
                      ),
                    ),
                  ])),
            ])),
        Align(alignment: Alignment.centerRight, child: Container())
      ]),
    );
  }
}
