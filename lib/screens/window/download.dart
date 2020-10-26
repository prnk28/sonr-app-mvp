part of 'window.dart';

Widget buildProgressView(BuildContext context) {
  return Column(
    children: [
      // Top Right Close/Cancel Button
      Align(
          alignment: Alignment.topRight,
          child: GestureDetector(
              onTap: () {
                // Pop Window
                Navigator.pop(context);
              },
              child: Padding(
                  padding: EdgeInsets.only(top: 10, right: 10),
                  child: Icon(
                    Icons.close_rounded,
                    size: 35,
                    color: Colors.grey[700],
                  )))),
      BlocBuilder<ProgressCubit, double>(
          cubit: context.getCubit(CubitType.Progress),
          builder: (context, state) {
            return Column(children: [
              NeumorphicProgress(percent: state),
              Divider(),
            ]);
          })
    ],
  );
}

Widget buildCompleteView(BuildContext context, NodeTransferSuccess state,
    void Function() onWindowTransferComplete) {
  if (onWindowTransferComplete != null) onWindowTransferComplete();
  return Column(
    children: [
      // Top Right Close/Cancel Button
      Align(
          alignment: Alignment.topRight,
          child: GestureDetector(
              onTap: () {
                // Pop Window
                Navigator.pop(context);
              },
              child: Padding(
                  padding: EdgeInsets.only(top: 10, right: 10),
                  child: Icon(
                    Icons.close_rounded,
                    size: 35,
                    color: Colors.grey[700],
                  )))),
      Image.file(state.file.raw)
    ],
  );
}
