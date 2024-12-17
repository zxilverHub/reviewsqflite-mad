import 'package:conndb2/add.dart';
import 'package:conndb2/dbhelper.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  void refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Dbhelper.openDb();
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => Add(
                      refresh: refresh,
                    ),
                  ),
                );
              },
              icon: Icon(Icons.add)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: FutureBuilder(
          future: Dbhelper.fetchData(),
          builder: (_, s) {
            if (s.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }

            if (s.connectionState == ConnectionState.done) {
              if (s.data == null) {
                return Text("No data");
              }
            }

            return ListView.builder(
                itemCount: s.data!.length,
                itemBuilder: (_, i) {
                  final hero = s.data![i];

                  return Dismissible(
                    key: ValueKey(hero),
                    onDismissed: (direction) {
                      deletHero(hero[Dbhelper.colId]);
                    },
                    child: Card(
                      child: ListTile(
                        title: Text(hero[Dbhelper.colName]),
                        subtitle: Text(hero[Dbhelper.colRule]),
                        trailing: IconButton(
                            onPressed: () {
                              openEntry(hero);
                            },
                            icon: Icon(Icons.edit)),
                      ),
                    ),
                  );
                });
          },
        ),
      ),
    );
  }

  void deletHero(id) {
    Dbhelper.deleteHero(id);
    setState(() {});
  }

  void openEntry(hero) {
    var n = TextEditingController();
    var a = TextEditingController();
    var r = TextEditingController();

    n.text = hero[Dbhelper.colName];
    a.text = hero[Dbhelper.colAge].toString();
    r.text = hero[Dbhelper.colRule];

    showModalBottomSheet(
      context: context,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: n,
              decoration: InputDecoration(label: Text("Name")),
            ),
            TextField(
              controller: a,
              decoration: InputDecoration(label: Text("Age")),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: r,
              decoration: InputDecoration(label: Text("Rule")),
            ),
            ElevatedButton(
                onPressed: () {
                  Dbhelper.editItem(hero[Dbhelper.colId], {
                    Dbhelper.colName: n.text,
                    Dbhelper.colAge: int.parse(a.text),
                    Dbhelper.colRule: r.text,
                  });

                  setState(() {});
                  Navigator.of(context).pop();
                },
                child: Text("Update")),
          ],
        ),
      ),
    );
  }
}
