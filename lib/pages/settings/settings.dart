import 'package:card_settings/card_settings.dart';
import 'package:sonr_app/style/style.dart';

class SettingsPage extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    String title = "Spheria";
    String author = "Cody Leet";
    String url = "http://www.codyleet.com/spheria";
    return SonrScaffold(
      appBar: DetailAppBar(
        onPressed: () {
          Get.back();
        },
        title: "Settings",
        isClose: true,
      ),
      body: Form(
        key: _formKey,
        child: _SettingsCardTheme(
          child: CardSettings(
              divider: Divider(
                color: AppTheme.DividerColor,
              ),
              //cardless: true,
              showMaterialonIOS: true,
              children: <CardSettingsSection>[
                CardSettingsSection(
                  header: CardSettingsHeader(
                    label: 'Favorite Book',
                  ),
                  children: <CardSettingsWidget>[
                    CardSettingsText(
                      label: 'Title',
                      labelAlign: TextAlign.left,
                      contentAlign: TextAlign.right,
                      initialValue: title,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Title is required.';
                      },
                      onSaved: (value) => title = value ?? "",
                    ),
                    CardSettingsText(
                      label: 'Author',
                      labelAlign: TextAlign.left,
                      contentAlign: TextAlign.right,
                      initialValue: author,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Author is required.';
                      },
                      onSaved: (value) => author = value ?? "",
                    ),
                    CardSettingsText(
                      label: 'URL',
                      initialValue: url,
                      labelAlign: TextAlign.left,
                      contentAlign: TextAlign.right,
                      validator: (value) {
                        if (!value!.contains('http:')) return 'Must be a valid website.';
                      },
                      onSaved: (value) => url = value ?? "",
                    ),
                  ],
                ),
              ]),
        ),
      ),
    );
  }
}

class _SettingsCardTheme extends StatelessWidget {
  final Widget child;

  const _SettingsCardTheme({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
        data: ThemeData(
          cardTheme: CardTheme(
            elevation: 10,
            shadowColor: Get.isDarkMode ? Colors.black.withOpacity(0.4) : Color(0xffD4D7E0).withOpacity(0.75),
            shape: Get.isDarkMode
                ? null
                : RoundedRectangleBorder(
                    side: BorderSide(color: AppTheme.BackgroundColor, width: 1),
                    borderRadius: BorderRadius.circular(20),
                  ),
          ),
          secondaryHeaderColor: Colors.transparent, // card header background
          cardColor: AppTheme.ForegroundColor, // card field background
          textTheme: TextTheme(
            button: TextStyle(color: Colors.deepPurple[900]), // button text
            subtitle1: DisplayTextStyle.Light.style(color: AppTheme.GreyColor), // input text
            headline6: DisplayTextStyle.Section.style(color: AppTheme.ItemColor), // card header text
          ),
          primaryTextTheme: TextTheme(
            headline6: TextStyle(color: Colors.lightBlue[50]), // app header text
          ),
          inputDecorationTheme: InputDecorationTheme(
            labelStyle: DisplayTextStyle.Subheading.style(color: AppTheme.ItemColor, fontSize: 20), // style for labels
          ),
        ),
        child: child);
  }
}
