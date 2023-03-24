import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService {
  late WebSocketChannel _channel;

  // Connect to the WebSocket
  Future<void> connect(String url) async {
    _channel = WebSocketChannel.connect(Uri.parse(url));
  }

  // Send a message to the WebSocket
  Future<void> sendMessage(String message) async {
    _channel.sink.add(message);
    _channel.sink.done.then((_) {
      print('Message sent successfully');
    }).catchError((error) {
      print('Error sending message: $error');
    });
  }

  // Close the WebSocket connection
  Future<void> close() async {
    _channel.sink.close();
  }
}
