import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter/widgets.dart';
import 'constants.dart';
import 'webSocket.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: MyHomePage(title: 'Flutter WebSocket Client'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  final _webSocketService = WebSocketService();
  final channel = WebSocketChannel.connect(
    Uri.parse(Constant.UPDATE_LINK),
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _webSocketService.connect(Constant.UPDATE_LINK);
  }

  Future<void> _incrementCounter() async {
    await _webSocketService.sendMessage('Hello! It is me, Mustafa. :)');
    setState(() {
      _counter++;
    });
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
            const Text(
              'The button will send a message to the WebSocket server.',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            StreamBuilder(
              stream: channel.stream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<String> dataList = snapshot.data
                      .split(','); // Split the data into a list of strings
                  return SizedBox(
                    height: 400,
                    child: Container(
                      color: Colors.grey[800],
                      child: ListView.builder(
                        itemCount: dataList.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(dataList[index],
                                style: TextStyle(color: Colors.green)),
                          );
                        },
                      ),
                    ),
                  );
                } else {
                  return Text('');
                }
              },
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
