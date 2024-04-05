import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class AppListPage extends StatefulWidget {
  final String deviceName;
  final String userId;

  AppListPage({required this.deviceName, required this.userId});

  @override
  _AppListPageState createState() => _AppListPageState();
}

class _AppListPageState extends State<AppListPage> {
  RxList apps = [].obs;

  @override
  void initState() {
    super.initState();
    _fetchAppList();
  }

  Future<void> _fetchAppList() async {
    try {
      // Execute adb command to get list of apps for a user
      final process = await Process.run('adb', [
        '-s',
        widget.deviceName,
        'shell',
        'pm',
        'list',
        'packages',
        '--user',
        widget.userId
      ]);
      var list = process.stdout.toString().split('\n')
        ..removeWhere((line) => line.isEmpty);

      if (process.exitCode == 0) {
        apps.value = list;
      } else {
        print('Error: ${process.stderr}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('App List'),
      ),
      child: Obx(
        () => SafeArea(
          child: ListView.builder(
            itemCount: apps.length,
            itemBuilder: (context, index) {
              return Container(
                clipBehavior: Clip.antiAlias,
                padding: EdgeInsets.all(2),
                margin: EdgeInsets.all(6),
                decoration: const BoxDecoration(
                    border: Border(),
                    color: CupertinoColors.black,
                    borderRadius: BorderRadius.all(Radius.circular(14))),
                child: CupertinoListTile(
                  padding: const EdgeInsets.all(8),
                  leading: const Icon(CupertinoIcons.app_badge),
                  trailing: const Icon(CupertinoIcons.right_chevron),
                  backgroundColor: CupertinoColors.systemGrey.withOpacity(.1),
                  title:
                      Text(apps[index].toString().replaceAll("package:", "")),
                  onTap: () {},
                ),
              );
              ;
            },
          ),
        ),
      ),
    );
  }
}
