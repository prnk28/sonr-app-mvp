import 'package:sonar_app/screens/screens.dart';

class DetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Setup App Bar
      appBar: AppBar(
          title: Text('Detail Screen'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context, false),
          )),
      // Setup Body
      body: Center(
        child: RaisedButton(
          child: Text('Transfer screen'),
          onPressed: () {
            Navigator.pushNamed(context, '/second');
          },
        ),
      ),
    );
  }
}
