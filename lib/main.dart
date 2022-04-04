import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Directory directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  await Hive.openBox<String>('friends');

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late Box<String> friendsBox;

  final nameFieldController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState

    friendsBox = Hive.box<String>('friends');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(children: [
          SizedBox(
            height: 120,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: Text(
                'Records',
                style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            child: ValueListenableBuilder(
                valueListenable: friendsBox.listenable(),
                builder: (context, Box<String> friends, _) {
                  return ListView.builder(
                      itemCount: friends.keys.length,
                      itemBuilder: (ctx, i) {
                        final key = friends.keys.toList()[i];

                        final value = friends.get(key);

                        return Card(
                          child: ListTile(
                              title: Text(value.toString()),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        showDialog(
                                            context: context,
                                            builder: (_) {
                                              return Dialog(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      16.0),
                                                  child: SizedBox(
                                                    height: 180,
                                                    child: Container(
                                                      child: Column(
                                                        children: [
                                                          Expanded(
                                                            child: TextField(
                                                              controller:
                                                                  nameFieldController,
                                                              decoration: InputDecoration(
                                                                  border:
                                                                      OutlineInputBorder(),
                                                                  label: Text(value
                                                                      .toString()),
                                                                  hintText: value
                                                                      .toString()),
                                                            ),
                                                          ),
                                                          Row(
                                                            children: [
                                                              Expanded(
                                                                  child: ElevatedButton(
                                                                      style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.grey)),
                                                                      onPressed: () {
                                                                        final value =
                                                                            nameFieldController.text;

                                                                        print(
                                                                            value);

                                                                        friendsBox.put(
                                                                            key,
                                                                            value);

                                                                        nameFieldController
                                                                            .clear();

                                                                        Navigator.pop(
                                                                            context);
                                                                      },
                                                                      child: Text('Update')))
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            });
                                      },
                                      child: Icon(Icons.edit),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        showDialog(
                                            context: context,
                                            builder: (_) {
                                              return AlertDialog(
                                                title: Text('Are you sure?',
                                                    textAlign:
                                                        TextAlign.center),
                                                content: ElevatedButton(
                                                    style: ButtonStyle(
                                                        backgroundColor:
                                                            MaterialStateProperty
                                                                .all(Colors
                                                                    .red)),
                                                    onPressed: () {
                                                      friendsBox.delete(key);

                                                      Navigator.pop(context);
                                                    },
                                                    child: Text('Delete')),
                                              );
                                            });
                                        // friendsBox.delete(key);
                                      },
                                      child: Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                        );
                      });
                }),

            //   child: ListView.builder(
            //       itemCount: 5,
            //       itemBuilder: (context, index) {
            //         return Card(
            //           child: ListTile(
            //             title: Text('Sample'),
            //             subtitle: Text('description'),
            //           ),
            //         );
            //       }),
            // ),
          ),
          Container(
              padding: EdgeInsets.all(8.0),
              child: Center(
                child: ElevatedButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (_) {
                            return Dialog(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: SizedBox(
                                  height: 180,
                                  child: Container(
                                    child: Column(
                                      children: [
                                        Expanded(
                                          child: TextField(
                                            controller: nameFieldController,
                                            decoration: InputDecoration(
                                                border: OutlineInputBorder(),
                                                label: Text('Enter Name')),
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                                child: ElevatedButton(
                                                    onPressed: () {
                                                      final value =
                                                          nameFieldController
                                                              .text;

                                                      final dkey = new Random();

                                                      final key =
                                                          dkey.nextInt(100);

                                                      print(key);

                                                      print(value);

                                                      friendsBox.add(value);

                                                      nameFieldController
                                                          .clear();

                                                      Navigator.pop(context);
                                                    },
                                                    child: Text('Submit')))
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          });
                    },
                    child: Text('Add Record')),
              ))
        ]),
      ),
    );
  }
}
