
import 'package:chat_vendor/model/one_to_one_chat_model.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart';

import '../const/const_value.dart';
import '../model/chat_user_model.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class UserChatProvider with ChangeNotifier {
  TextEditingController searchController = TextEditingController();
  List<ChatUserModel> _allChatUserData = [];
  List<ChatUserModel> _allSearchUserData = [];
  List<ChatUserModel> get allSerachUserData {
    return _allSearchUserData;
  }

  List<ChatUserModel> get allChatUserData {
    return _allChatUserData;
  }

  List<OneToOneChatModel> _listOfOneToOneMessage = [];

  List<OneToOneChatModel> get listOfOneToOneMessage {
    return _listOfOneToOneMessage;
  }

  // late IO.Socket socket;
  List<dynamic> chatList = [];
  int page = 1;
  bool isLoading = false;

  ChatProvider() {
    initializeSocket();
  }

  String formatTimeDifference(String inputDate) {
    DateTime date = DateTime.parse(inputDate);
    DateTime now = DateTime.now();
    print(now);
    Duration difference = now.difference(date);

    if (difference.inSeconds < 60) {
      return 'just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} min ago';
    } else if (difference.inHours < 24 && date.day == now.day) {
      return '${difference.inHours} hr ago';
    } else if (difference.inHours < 48 && date.day == now.day - 1) {
      return 'yesterday';
    } else {
      // return formatted date
      return '${date.year}-${date.month}-${date.day}';
    }
  }

  ChatUserModel findById(String userId) {
    return allChatUserData.firstWhere(
      (user) => user.userId == userId,
    );
  }



  Future<void> allSocketConnection() async {}

  void initializeSocket() {
    // Initialize Socket.IO connection
    socket;
   

    // Connect to server
    socket.connect();
    /* Search user chat */
    socket.on('search_chat_list', (data) {
      var responseData = data['data']['chat_list'];
      _allSearchUserData = List<ChatUserModel>.from(
          responseData.map((item) => ChatUserModel.fromJson(item)));
      print("Length of the User ${_allSearchUserData.length}");
      // _allSearchUserData = List.from(data);
    });

    /* List of user chat */

    /* connect the room */
    socket.on('room', (data) {
      print("Room Connection $data");
    });
    /* one to one chat list */
    socket.on('message', (data) {
      // print("Room chat event $data");
      print(data);
      var response = data["data"]["list"];
      print(response);
      for (var i = 0; i < response.length; i++) {
        _listOfOneToOneMessage.add(OneToOneChatModel(
            id: response[i]["id"] ?? "",
            createdDate: DateTime.parse(response[i]["created_datetime"]),
            senderId: response[i]["senter_id"] ?? "",
            reciverId: response[i]["receiver_id"] ?? "",
            type: response[i]["type"] ?? "",
            message: response[i]["message"] ?? "",
            messageType: response[i]["message_type"] ?? "",
            duration: response[i]["duration"] ?? "",
            messageStatus: response[i]["message_status"] ?? "",
            room: response[i]["room"] ?? "",
            replyId: response[i]["replay_id"] ?? "",
            replyMessage: response[i]["replay_message"] ?? "",
            replyMessageType: response[i]["replay_message_type"] ?? "",
            replyMessageSender: response[i]["replay_senter"] ?? "",
            replyDuration: response[i]["replay_duration"] ?? "",
            replyFile: response[i]["replay_file_size"] ?? "",
            forwardId: response[i]["forward_id"] ?? "",
            forwardCount: response[i]["forwarded_count"] ?? "",
            optionalText: response[i]["optional_text"] ?? "",
            thumNail: response[i]["thumbnail"] ?? "",
            fileSize: response[i]["file_size"] ?? ""));
      }
      notifyListeners();
    });

    // Listen to 'connect_error' event
    socket.on('connect_error', (error) {
      // Handle connection error here
      // You can show an alert or perform any other action
    });

    // Fetch initial chat list
    // fetchChatList();
    roomConnection();

    // Listen for scroll events
    // Note: You might want to handle scroll events outside the provider
  }

  void searchUserQuery(String searchTerm) async {
    // Emit 'search_room_message' event with search term
    if (searchTerm != "") {
      socket.emit('search_chat_list', {
        "user_id": "1",
        "access_token": "13a761e10063f408f3c6c8622a156c38",
        "search": searchTerm,
      });
    }

    notifyListeners();
  }

  // Function to fetch chat list data
  void fetchChatList() {
    if (!isLoading) {
      isLoading = true; // Set isLoading to true before fetching data

      // Emit 'chat_list' event with pagination parameters
      socket.emit('chat_list', {
        "user_id": "1",
        "access_token": "13a761e10063f408f3c6c8622a156c38",
        "page": page,
      });
      socket.on('chat_list', (data) {
      var responseData = data['data'];
      print('Received datas: $responseData');
      _allChatUserData = List<ChatUserModel>.from(
          responseData.map((item) => ChatUserModel.fromJson(item)));

      // Data loaded, set isLoading to false
      isLoading = false;
      notifyListeners();
    });

      // Increment page number for next pagination
      page++;
    }
  }

  void oneToOneChatList(String reciverId) {
    socket.emit('room_chat_list', {
      "user_id": "1",
      "receiver_id": reciverId,
      "limit": "10",
      "last_message_id": "",
    });
  }

  void roomConnection() {
    socket.emit('room', {"user_id": "1", "receiver_id": "2"});
  }

  @override
  void dispose() {
    // Disconnect socket when not in use
    socket.disconnect();
    super.dispose();
  }
}
