import 'package:flutter/material.dart';
import 'package:newsopolis/ui/widgets/card.dart';

class StateCard extends StatelessWidget {
  final String title, content;
  final VoidCallback onDelete;

  // StateCard constructor
  const StateCard(
      {Key? key,
      required this.title,
      required this.content,
      
      required this.onDelete})
      : super(key: key);

  // We create a Stateless widget that contais an AppCard,
  // Passing all the customizable views as parameters
  @override
  Widget build(BuildContext context) {
    Color primaryColor = Theme.of(context).colorScheme.primary;
    return AppCard(
      key: const Key("statusCard"),
      title: title,
      content: Text(
        content,
        style: Theme.of(context).textTheme.bodyText1,
      ),
      // topLeftWidget widget as an Avatar
      
      
      // topRightWidget widget as an IconButton
      topRightWidget: IconButton(
        icon: Icon(
          Icons.close,
          color: primaryColor,
        ),
        onPressed: onDelete,
      ),
    );
  }
}
