import 'package:flutter/material.dart';

class ImageCheckBox extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final String checkDescription;

  ImageCheckBox({Key key,
    @required this.value,
    @required this.onChanged,
    @required this.checkDescription}) : super(key: key);

  @override
  _ImageCheckBoxState createState() => _ImageCheckBoxState();
}

class _ImageCheckBoxState extends State<ImageCheckBox> {
  bool checkedIcon;

  Widget getIcon() {
    if (!checkedIcon)
      return Icon(Icons.check_box_outline_blank);
    else
      return Icon(Icons.check_box);
  }

  @override
  void initState() {
    super.initState();
    checkedIcon = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        IconButton(
          icon: getIcon(),
          onPressed: () {
            setState(() {
              checkedIcon = !checkedIcon;
            });
          },
        ),
        SizedBox(width: 5),
        Text('${widget.checkDescription}')
      ],
    );
  }
}