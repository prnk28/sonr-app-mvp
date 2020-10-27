part of 'home.dart';

class ImageGrid extends StatelessWidget {
  final double itemHeight = (screenSize.height - kToolbarHeight - 24) / 4;
  final double itemWidth = screenSize.width / 4;

  // Build Widget
  @override
  Widget build(BuildContext context) {
    // Load Files
    context.getBloc(BlocType.Data).add(UserGetAllFiles());
    // Build View
    return BlocBuilder<DataBloc, DataState>(
        // Set Build Requirements
        buildWhen: (previous, current) {
      if (current is UserLoadedFilesSuccess) {
        return true;
      } else if (current is UserLoadedFilesFailure) {
        return true;
      }
      return false;
    }, builder: (context, state) {
      // User Files View
      if (state is UserLoadedFilesSuccess) {
        return GridView.count(
            primary: false,
            padding: const EdgeInsets.all(20),
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            crossAxisCount: 2,
            // // Change Size With This
            // childAspectRatio: (itemWidth / itemHeight),
            children: _buildImageCards(state.files));
      }
      // No Files View
      else if (state is UserLoadedFilesFailure) {
        return Center(child: Text("No User Files"));
      }
      // Arbitrary View
      else {
        return Center(child: Text("Mega Hellope"));
      }
    });
  }

  _buildImageCards(List<Metadata> files) {
    // Initialize
    List<Widget> cards = new List<Widget>();
    int current = 1;

    // Iterate Through Files
    files.forEach((metadata) {
      // Get Color
      var variant = (current % 10) + 1;
      Color color;

      // Set Initial Color
      if (variant == 1) {
        color = Colors.red[50];
      }
      // Set Middle Color
      else if (variant == 6) {
        color = Colors.red;
      }
      // Set Rest
      else {
        color = Colors.red[(variant - 1) * 100];
      }

      // Generate Cell
      var card = new ImageCard(metadata, color);

      // Add Cell to List
      cards.add(card);

      // Increase count
      current += 1;
    });

    // Return Cells
    return cards;
  }
}
