import 'package:adb/adb.dart';
import 'package:adb_app/screens/2UsersListScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show LinearProgressIndicator;
import 'package:get/get.dart';

class DeviceListScreen extends StatefulWidget {
  const DeviceListScreen({super.key});

  @override
  _DeviceListScreenState createState() => _DeviceListScreenState();
}

class _DeviceListScreenState extends State<DeviceListScreen> {
  RxList _devices = [].obs;

  @override
  void initState() {
    super.initState();
    _checkDeviceConnectivity();
  }

  Future<void> _checkDeviceConnectivity() async {
    while (true) {
      final devices = await Adb().devices();
      _devices.value = devices;
      await Future.delayed(const Duration(seconds: 3));
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(
          middle: Text('Devices'),
        ),
        child: Obx(
          () => Column(
            children: [
              const SizedBox(
                height: 42,
              ),
              const LinearProgressIndicator(
                backgroundColor: CupertinoColors.black,
              ),
              _devices.isEmpty
                  ? const Center(
                      child:
                          Text("No devices found!, Try to connect a device..."))
                  : const SizedBox.shrink(),
              Expanded(
                child: ListView.builder(
                  itemCount: _devices.length,
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
                        leading:
                            const Icon(CupertinoIcons.device_phone_portrait),
                        trailing: const Icon(CupertinoIcons.right_chevron),
                        backgroundColor:
                            CupertinoColors.systemGrey.withOpacity(.1),
                        title: Text(_devices[index]),
                        onTap: () {
                          // Get.to(() => UserListPage(deviceName: _devices[index]));
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) =>
                                  UserListPage(deviceName: _devices[index]),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
              Text('Connected devices: ${_devices.length}'),
            ],
          ),
        ));
  }
}
