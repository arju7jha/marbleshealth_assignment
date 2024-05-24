import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'Data/savaDataDisplay.dart';


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Widget> components = [];
  List<Widget> savedData = [];
  bool initialComponentVisible = true;

  @override
  void initState() {
    super.initState();
    components.add(DynamicComponent(key: UniqueKey(), onRemove: removeComponent, onDone: saveData));
  }

  void addComponent() {
    setState(() {
      components.add(DynamicComponent(key: UniqueKey(), onRemove: removeComponent, onDone: saveData));
    });
  }

  void removeComponent(Key key) {
    setState(() {
      components.removeWhere((element) => element.key == key);
    });
  }

  void saveData(String labelText, String infoText, bool required) {
    setState(() {
      if (initialComponentVisible) {
        initialComponentVisible = false;
        components.clear();
      }
      savedData.add(SavedDataDisplay(labelText: labelText, infoText: infoText, required: required));
    });
  }

  void handleSubmit() {
    // Handle form submission logic here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dynamic Form'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: handleSubmit,
          ),
        ],
      ),
      body: Padding(
        padding: kIsWeb
            ? const EdgeInsets.symmetric(horizontal: 48.0, vertical: 16.0) // Web padding
            : const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0), // Mobile padding
        child: Column(

          children: [
            Expanded(
              child: ListView(
                children: [
                  ...savedData,
                  ...components,
                ],
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: addComponent,
              child: Text('ADD'),
            ),
          ],
        ),
      ),
    );
  }
}

class DynamicComponent extends StatefulWidget {
  final Function(Key) onRemove;
  final Function(String, String, bool) onDone;

  DynamicComponent({required Key key, required this.onRemove, required this.onDone}) : super(key: key);

  @override
  _DynamicComponentState createState() => _DynamicComponentState();
}

class _DynamicComponentState extends State<DynamicComponent> {
  bool isChecked = false;
  String labelText = '';
  String infoText = '';
  bool required = false;
  bool readOnly = false;
  bool hidden = false;
  final _labelController = TextEditingController();
  final _infoTextController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _labelController.dispose();
    _infoTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Row(
                children: [
                  Checkbox(
                    value: isChecked,
                    onChanged: (bool? value) {
                      setState(() {
                        isChecked = value!;
                      });
                    },
                  ),
                  Text('Checkbox'),
                  Spacer(),
                  ElevatedButton(
                    onPressed: () => widget.onRemove(widget.key!),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white, // Background color
                    ),
                    child: Text(
                      'Remove',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        widget.onDone(labelText, infoText, required);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue, // Background color
                    ),
                    child: Text('Done'),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: Text.rich(
                  TextSpan(
                    text: 'Label',
                    children: required ? [TextSpan(text: '*', style: TextStyle(color: Colors.red))] : [],
                  ),
                ),
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: _labelController,
                decoration: InputDecoration(
                  hintText: 'Enter label',
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black12),
                  ),
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.all(8.0),
                  fillColor: Colors.white,
                  filled: true,
                ),
                onChanged: (value) {
                  setState(() {
                    labelText = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Label is required';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: Text('Info-Text'),
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: _infoTextController,
                decoration: InputDecoration(
                  hintText: 'Enter info-text',
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black12),
                  ),
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.all(8.0),
                  fillColor: Colors.white,
                  filled: true,
                ),
                onChanged: (value) {
                  setState(() {
                    infoText = value;
                  });
                },
              ),
              SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: Text('Settings'),
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Checkbox(
                    value: required,
                    onChanged: (bool? value) {
                      setState(() {
                        required = value!;
                      });
                    },
                  ),
                  Text('Required'),
                  Checkbox(
                    value: readOnly,
                    onChanged: (bool? value) {
                      setState(() {
                        readOnly = value!;
                      });
                    },
                  ),
                  Text('ReadOnly'),
                  Checkbox(
                    value: hidden,
                    onChanged: (bool? value) {
                      setState(() {
                        hidden = value!;
                      });
                    },
                  ),
                  Text('Hidden'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
