import 'package:flutter/material.dart';
import 'classes/api.dart';

class DataView extends StatefulWidget {
  const DataView({super.key});

  @override
  State<DataView> createState() => _DataViewState();
}

class _DataViewState extends State<DataView> {
  List<dynamic> data = [];

  @override
  void initState() {
    super.initState();

    // fetch data from api
    Api api = Api();
    api.get('/user').then((response) {
      debugPrint("Response: ${response.runtimeType}");
      if (response["code"] != 200) {
        debugPrint('Error fetching data: ${response["message"]}');
        return;
      }
      setState(() {
        data = response["data"];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          leading: Text(data[index]['id'].toString()),
          title: Text(data[index]['firstname'] + ' ' + data[index]['lastname']),
          subtitle: Text("Klasse: ${data[index]['class']['name']}"),

          // select user on tap
          onTap: () {
            debugPrint('User ${data[index]['id']} tapped');

            // open user popup
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text(
                      data[index]['firstname'] + ' ' + data[index]['lastname']),
                  content: Text("Klasse: ${data[index]['class']['name']}"),
                  actions: [
                    TextButton(
                      child: const Text('Schließen'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }
}
