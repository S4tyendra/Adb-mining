import 'dart:io';
import 'dart:math';
import 'package:adb_app/screens/3GetListOfApps.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class UserListPage extends StatefulWidget {
  final String deviceName;

  UserListPage({required this.deviceName});

  @override
  _UserListPageState createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  RxList users = [].obs;

  @override
  void initState() {
    super.initState();
    _fetchUserList();
  }

  Future<void> _fetchUserList() async {
    try {
      // Execute adb command to get list of users
      final process = await Process.run(
          'adb', ['-s', widget.deviceName, 'shell', 'pm', 'list', 'users']);
      var list = process.stdout.toString().split('\n')
        ..removeAt(0)
        ..removeWhere((line) => line.isEmpty);

      if (process.exitCode == 0) {
        users.value = list;
      } else {
        print('Error: ${process.stderr}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Color _generateRandomColor() {
    Random random = Random();
    return Color.fromARGB(
      255,
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('User List'),
      ),
      child: Obx(
        () => SafeArea(
          child: ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              print(users[index]
                  .replaceAll("UserInfo{", "")
                  .split(":")[0]
                  .replaceAll("	", ""));
              return Container(
                clipBehavior: Clip.antiAlias,
                padding: const EdgeInsets.all(2),
                margin: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  border: Border(),
                  color: CupertinoColors.black,
                  borderRadius: BorderRadius.all(
                    Radius.circular(14),
                  ),
                ),
                child: CupertinoListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => AppListPage(
                          deviceName: widget.deviceName,
                          userId: users[index]
                              .replaceAll("UserInfo{", "")
                              .split(":")[0]
                              .replaceAll("	", ""),
                        ),
                      ),
                    );
                  },
                  leadingSize: 40,
                  padding: const EdgeInsets.all(12),
                  trailing: const Icon(CupertinoIcons.right_chevron),
                  backgroundColor: CupertinoColors.systemGrey.withOpacity(.1),
                  leading: Container(
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: CupertinoColors.systemGrey,
                      ),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(100)),
                      color:
                          _generateRandomColor(), // Generating a random color for the profile picture
                    ),
                    child: Center(
                      child: Text(
                        users[index]
                            .replaceAll("UserInfo{", "")
                            .split(":")[0]
                            .replaceAll("\t", ""),
                        style: const TextStyle(
                          color: CupertinoColors
                              .white, // Setting text color to white for better contrast
                        ),
                      ),
                    ),
                  ),
                  title: Text(
                      users[index].replaceAll("UserInfo{", "").split(":")[1]),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
