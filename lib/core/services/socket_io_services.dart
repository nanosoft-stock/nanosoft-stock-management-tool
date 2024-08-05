import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketIoServices {
  String localUrl = "http://localhost:3000";
  String cloudUrl = "http://18.170.161.164:3000";

  late String currentURL;
  static bool isConnected = false;

  late IO.Socket socket;

  void setToLocalEnv() {
    currentURL = localUrl;
  }

  void setToCloudEnv() {
    currentURL = cloudUrl;
  }

  IO.Socket get getSocket => socket;

  Future<void> init() async {
    socket = IO.io(currentURL, <String, dynamic>{
      'autoConnect': false,
      'transports': ['websocket']
    });

    socket.connect();
    socket.onConnect(_onConnect);
    socket.onDisconnect(_onDisconnect);
    socket.onConnectError(_onConnectError);
    socket.onError(_onError);
  }

  void _onConnect(data) {
    isConnected = true;
    print('IOSocket: Connected to server');
  }

  void _onDisconnect(data) {
    isConnected = false;
    print('IOSocket: Disconnected from server');
  }

  void _onConnectError(data) {
    print('IOSocket: Error connecting to server');
  }

  void _onError(data) {
    print('IOSocket: Error');
  }
}
