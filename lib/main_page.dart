import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'main_page_vm.dart';

class MainPage extends ConsumerStatefulWidget {
  const MainPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  ConsumerState<MainPage> createState() => _MainPageState();
}

class _MainPageState extends ConsumerState<MainPage> {
  MainPageViewModel _vm = MainPageViewModel();

  @override
  void initState() {
    super.initState();
    _vm.setRef(ref);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              onChanged: (text) => _vm.onPostalcodeChanged(text),
            ),
            Expanded(
              child: _vm.postalCodeWithFamily(_vm.postalcode).when(
                  data: (data) => ListView.separated(
                    itemCount: data.data.length,
                    itemBuilder: (context, index) => ListTile(
                      title: Column(
                        children: [
                          Text(data.data[index].ja.prefecture),
                          Text(data.data[index].ja.address1),
                          Text(data.data[index].ja.address2),
                          Text(data.data[index].ja.address3),
                          Text(data.data[index].ja.address4),
                        ],
                      ),
                    ),
                    separatorBuilder: (context, index) => const Divider(color: Colors.black),
                  ),
                  error: (error, stack) => Text(error.toString()),
                  loading: () => const AspectRatio(aspectRatio: 1, child: CircularProgressIndicator())),
            ),
          ],
        ),
      ),
    );
  }
}