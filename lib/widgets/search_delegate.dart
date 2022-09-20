import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/localstorage/local_storage.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/widgets/tasklist_item.dart';

import '../models/task.dart';

class CustomSearchDelegated extends SearchDelegate {
  final List<Task> allTask;
  CustomSearchDelegated({required this.allTask});
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query.isEmpty ? null : query = '';
          },
          icon: const Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return GestureDetector(
        onTap: () {
          close(context, null);
        },
        child: const Icon(Icons.arrow_back_ios, color: Colors.red, size: 24));
  }

  @override
  Widget buildResults(BuildContext context) {
    List<Task> _filterList = allTask
        .where(
            (gorev) => gorev.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return _filterList.length>0?    ListView.builder(itemBuilder: (context, index) {
              var oankiListeEelemani = _filterList[index];
              return Dismissible(
                key: Key(oankiListeEelemani.id),
                background: Row(children:  [
                  Icon(
                    Icons.delete,
                    color: Colors.red,
                    size: 15,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text('remove_task').tr()
                ]),
                onDismissed: (direction) async {
                 _filterList.removeAt(index);
               await   locator<LocalStorage>().deletedTask(task: oankiListeEelemani);
                  
                },
                child: TaskItem(task: oankiListeEelemani),
              );
            })
          : Center(child: Text('search_not_found').tr());
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    throw UnimplementedError();
  }
}
