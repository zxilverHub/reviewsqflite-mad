import 'package:conndb2/dbhelper.dart';
import 'package:flutter/material.dart';

class Add extends StatefulWidget {
  Add({super.key, required this.refresh});

  Function refresh;

  @override
  State<Add> createState() => _AddState();
}

class _AddState extends State<Add> {
  var name = TextEditingController();
  var rule = TextEditingController();
  var age = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView(
          children: [
            TextField(
              controller: name,
              decoration: InputDecoration(
                label: Text("Name"),
              ),
            ),
            TextField(
              keyboardType: TextInputType.number,
              controller: age,
              decoration: InputDecoration(
                label: Text("Age"),
              ),
            ),
            TextField(
              controller: rule,
              decoration: InputDecoration(
                label: Text("Rule"),
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  Dbhelper.addHero({
                    Dbhelper.colName: name.text,
                    Dbhelper.colAge: int.parse(age.text),
                    Dbhelper.colRule: rule.text,
                  });

                  setState(() {
                    name.text = "";
                    age.text = "";
                    rule.text = "";
                  });

                  widget.refresh();
                  Navigator.of(context).pop();
                },
                child: Text("Add")),
          ],
        ),
      ),
    );
  }
}
