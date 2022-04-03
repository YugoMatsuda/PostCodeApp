import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'provider.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends ConsumerWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final familyPostalCode = ref.watch(apiFamilyProvider(ref.watch(postalCodeProvider.state).state));

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              onChanged: (text) => onPostalCodeChanged(ref, text),
            ),
            Expanded(
              child: familyPostalCode.when(
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

  void onPostalCodeChanged(WidgetRef ref, String text) {
    if (text.length != 7) {
      return ;
    }
    try {
      int.parse(text);
      ref.watch(postalCodeProvider.state).state = text;
      print(text);

    } catch(ex) {}
  }
}
