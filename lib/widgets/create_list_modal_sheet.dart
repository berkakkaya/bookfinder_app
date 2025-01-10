import "package:bookfinder_app/extensions/theming.dart";
import "package:flutter/material.dart";

class CreateListModalSheet extends StatefulWidget {
  const CreateListModalSheet({
    super.key,
    required this.onSuccess,
  });

  final Function(String listName, bool isPublic) onSuccess;

  @override
  State<CreateListModalSheet> createState() => _CreateListModalSheetState();
}

class _CreateListModalSheetState extends State<CreateListModalSheet> {
  String listName = "";
  bool isPublic = false;

  final textFieldFocusNode = FocusNode();
  String? errorText;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => textFieldFocusNode.requestFocus(),
    );
  }

  @override
  void dispose() {
    textFieldFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 16,
        left: 16,
        right: 16,
        bottom: 16 + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "Yeni Liste Oluştur",
            style: context.theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 32),
          TextField(
            focusNode: textFieldFocusNode,
            onTapOutside: (_) => textFieldFocusNode.unfocus(),
            decoration: InputDecoration(
              labelText: "Liste Adı",
              hintText: "Liste Adı",
              errorText: errorText,
            ),
            textCapitalization: TextCapitalization.words,
            onChanged: (value) {
              setState(() {
                listName = value;
                errorText = value.length < 3 ? "En az 3 karakter olmalı" : null;
              });
            },
          ),
          const SizedBox(height: 16),
          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            value: isPublic,
            onChanged: (value) {
              setState(() {
                isPublic = value!;
              });
            },
            controlAffinity: ListTileControlAffinity.leading,
            title: Text("Listeyi herkese açık yap"),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: listName.length < 3
                ? null
                : () => widget.onSuccess(listName, isPublic),
            child: Text("Oluştur"),
          ),
        ],
      ),
    );
  }
}
