import 'package:socket_io_client/socket_io_client.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

String restApiUrl = "";
String socketIoApiUrl = "";
  Socket socket = IO.io('', <String, dynamic>{
    '': [''],
    '': false,
  });
