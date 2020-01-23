import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sonar_app/widgets/widgets.dart';
import 'package:sonar_app/blocs/blocs.dart';

class Direction extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Weather'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () async{
              BlocProvider.of<HomeBloc>(context)
                    .add(GetDirection(accelerometerValues: <double>[]));
            },
          )
        ],
      ),
      body: Center(
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state is DirectionZero) {
              return Center(child: Text('Please Select a Location'));
            }
            if (state is DirectionReceive) {
              return Center(child: CircularProgressIndicator());
            }
            if (state is DirectionSend) {
              final weather = state.direction;

              return ListView(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 100.0),
                    child: Center(
                      child:Text(state.direction.degrees.toString())
                    ),
                  ),
                  Center(
                    child:Text(state.direction.antipodalDegrees.toString())
                  ),
                ],
              );
            }
            if (state is DirectionError) {
              return Text(
                'Something went wrong!',
                style: TextStyle(color: Colors.red),
              );
            }
          },
        ),
      ),
    );
  }
}