import 'dart:async';
import 'dart:convert';

import 'package:filter_list/filter_list.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:yebelo/Provider/CartProvider.dart';
import 'package:yebelo/module/jsonParsing.dart';

import 'package:yebelo/module/testIem.dart';
import 'package:yebelo/widgets/productCard.dart';
import 'package:yebelo/module/Categories.dart';
import 'dart:async';

void main() => runApp(
      ChangeNotifierProvider(
        create: (context) => CartProvider(),
        child: const MyApp(),
      ),
    );

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const appTitle = 'Isolate Demo';

    return const MaterialApp(
      title: appTitle,
      home: MyHomePage(title: appTitle),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    List<Categories> selectedUserList;

    return Scaffold(
      appBar: AppBar(
        title: Chip(
          backgroundColor: Colors.yellow,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.black),
            borderRadius: BorderRadius.circular(10),
          ),
          label: Text('Yebelo', style: TextStyle(fontSize: 22)),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {},
          ),
        ],
      ),
      body: FutureBuilder<String>(
        future: _loadJsonFile(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(
                child: Text("Error loading data: ${snapshot.error}"),
              );
            }

            List<TestItem> list = jsonParsing().parsePhotos(snapshot.data!);
            List<Categories> list_of_categories = jsonParsing().userList(list);

            selectedUserList = List.from(list_of_categories);

            return PhotosList(
                photos: list,
                list_of_categories: list_of_categories,
                selectedUserList: selectedUserList);
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Future<String> _loadJsonFile() async {
    try {
      return await rootBundle.loadString('assets/files.json');
    } catch (e) {
      print("Error loading JSON file: $e");
      return "";
    }
  }
}

class PhotosList extends StatefulWidget {
  const PhotosList(
      {super.key,
      required this.photos,
      required this.list_of_categories,
      required this.selectedUserList});

  final List<TestItem> photos;
  final List<Categories> list_of_categories;
  final List<Categories> selectedUserList;

  @override
  _MyPhotosList createState() => _MyPhotosList();
}

class _MyPhotosList extends State<PhotosList> {
  List<Categories>? selectedUserList = [];
  bool isFirst = true;

  Future<void> _openFilterDialog(List<Categories> userList) async {
    selectedUserList = selectedUserList = List.from(widget.selectedUserList);
    isFirst = false;
    ;
    await FilterListDialog.display<Categories>(
      context as BuildContext,
      hideSelectedTextCount: true,
      themeData: FilterListThemeData(context as BuildContext),
      headlineText: 'Select Users',
      height: 500,
      listData: userList,
      selectedListData: selectedUserList,
      choiceChipLabel: (item) => item!.name,
      validateSelectedItem: (list, val) => list!.contains(val),
      controlButtons: [ControlButtonType.All, ControlButtonType.Reset],
      onItemSearch: (user, query) {
        return user.name!.toLowerCase().contains(query.toLowerCase());
      },
      onApplyButtonClick: (list) {
        setState(() {
          selectedUserList = List.from(list!);
        });
        Navigator.pop(context as BuildContext);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isFirst) {
      selectedUserList = widget.list_of_categories;
    }
    List<TestItem> curr_list =
        jsonParsing().currList(widget.photos, selectedUserList!);

    return SingleChildScrollView(
        child: Column(children: [
      Container(
        margin: EdgeInsets.only(left: 10),
        child: Row(
          children: [
            Text('Popular Items', style: TextStyle(fontSize: 20)),
            SizedBox(
              width: 100,
            ),
            IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                _openFilterDialog(widget.list_of_categories);
              },
            ),
          ],
        ),
      ),
      SizedBox(
        height: 10,
      ),
      SizedBox(
        child: GridView.builder(
          itemCount: curr_list.length,
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 0.56,
            crossAxisCount: 2,
          ),
          itemBuilder: (BuildContext context, int index) {
            return ProductCard(item: curr_list[index]);
          },
        ),
      ),
      SizedBox(
        height: 20,
      ),
      Container(
          padding: EdgeInsets.all(16.0),
          width: 300,
          child: ElevatedButton(
            onPressed: () {
              List<Map<String, dynamic>> updatedList = [];
              Map<int, int> itemCountMap =
                  context.read<CartProvider>().getItemCountMap();

              for (TestItem item in curr_list) {
                int itemCount = itemCountMap[item.id] ?? 0;
                Map<String, dynamic> updatedItem = {
                  "p_name": item.name,
                  "p_id": item.id,
                  "p_cost": item.cost,
                  "p_availability": item.availability,
                  "p_details": item.details,
                  "p_category": item.category,
                  "p_count": itemCount,
                };
                updatedList.add(updatedItem);
              }

              String updatedJson = jsonEncode(updatedList);
              print(updatedJson);

              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Updated JSON Data"),
                      content: Text(updatedJson),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text("OK"),
                        ),
                      ],
                    );
                  });
            },
            child: Text('Confirm', style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(
              primary: Color.fromRGBO(6, 33, 125, 1),
              padding: EdgeInsets.symmetric(vertical: 5.0),
            ),
          )),
    ]));
  }

  List<Categories>? getInitialList() {
    return widget.selectedUserList;
  }
}
