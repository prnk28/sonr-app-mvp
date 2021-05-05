import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sonr_app/style/style.dart';
import 'package:sonr_plugin/sonr_plugin.dart';

class SocialUserSearchField extends StatefulWidget {
  final String value;
  final ValueChanged<String> onChanged;
  final Function(SocialUser) onEditingComplete;
  final Iterable<String> autofillHints;
  final Contact_Social_Provider provider;

  factory SocialUserSearchField.medium({
    String value,
    ValueChanged<String> onChanged,
    Function(SocialUser) onEditingComplete,
    Iterable<String> autofillHints,
    Function onSuggestionTap,
  }) {
    return SocialUserSearchField(Contact_Social_Provider.Medium, value: value);
  }

  factory SocialUserSearchField.twitter({
    @required String value,
    ValueChanged<String> onChanged,
    Function(SocialUser) onEditingComplete,
    Iterable<String> autofillHints,
    Function onSuggestionTap,
  }) {
    return SocialUserSearchField(Contact_Social_Provider.Twitter, value: value);
  }

  factory SocialUserSearchField.youtube({
    @required String value,
    ValueChanged<String> onChanged,
    Function(SocialUser) onEditingComplete,
    Iterable<String> autofillHints,
    Function onSuggestionTap,
  }) {
    return SocialUserSearchField(Contact_Social_Provider.YouTube, value: value);
  }

  SocialUserSearchField(
    this.provider, {
    @required this.value,
    this.onChanged,
    this.onEditingComplete,
    this.autofillHints,
  });

  @override
  _SocialUserSearchFieldState createState() => _SocialUserSearchFieldState();
}

class _SocialUserSearchFieldState extends State<SocialUserSearchField> {
  SocialUserSearchResult result;
  SocialUser selectedUser;

  @override
  Widget build(BuildContext context) {
    return ValueBuilder<String>(
      initialValue: widget.value,
      builder: (value, updateFn) {
        return Stack(alignment: Alignment.center, children: [
          Container(
              margin: EdgeInsets.only(left: 8, right: 8, top: 2, bottom: 4),
              decoration: Neumorphic.floating(),
              padding: EdgeInsets.symmetric(vertical: 14, horizontal: 18),
              child: Stack(alignment: Alignment.center, children: [
                Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                      ShaderMask(
                        shaderCallback: (bounds) {
                          return SonrGradients.AmourAmour.createShader(bounds);
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
                          onEditingComplete: () => widget.onEditingComplete(selectedUser),
                          onChanged: (val) async {
                            if (val.isNotEmpty) {
                              var data = await widget.provider.searchUser(val, false);
                              setState(() {
                                selectedUser = data.first;
                                result = data;
                              });
                            }
                          },
                          decoration: InputDecoration.collapsed(hintText: "Search...", hintStyle: TextStyle(color: Colors.black38)),
                        ),
                      ),
                    ])),
              ])),
          Align(
              alignment: Alignment.centerRight,
              child: result != null && result.hasData
                  ? _SocialUserSearchSuggestion(
                      result.first,
                      onSelected: (data) {
                        selectedUser = data;
                      },
                    )
                  : Container())
        ]);
      },
      onUpdate: widget.onChanged,
    );
  }
}

class _SocialUserSearchSuggestion extends StatelessWidget {
  final SocialUser user;
  final Function(SocialUser) onSelected;

  const _SocialUserSearchSuggestion(this.user, {Key key, @required this.onSelected}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Container(
        width: 100,
        height: 100,
        child: PlainButton(
            onPressed: () {
              user.read();
            },
            child: Container(
              child: Image.network(user.pictureLink),
            )),
      ),
    );
  }
}
