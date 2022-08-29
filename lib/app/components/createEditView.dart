import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class CreateEditView extends StatefulWidget {
  const CreateEditView({required this.oldContext, Key? key}) : super(key: key);
  final BuildContext oldContext;

  @override
  State<CreateEditView> createState() => _CreateEditViewState();
}

class _CreateEditViewState extends State<CreateEditView> {
  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    bool isChecked = false;
    return SimpleDialog(
      title: Text("mememeeeeeeeeeeeeeeeeeeeeeeeeeeee"),
      children: [],
    );
  }
}
