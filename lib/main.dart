import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

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
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MySocketPage(),
    );
  }
}

class MySocketPage extends StatefulWidget {
  @override
  _MySocketPageState createState() => _MySocketPageState();
}

class _MySocketPageState extends State<MySocketPage> {
  late IO.Socket socket;
  List<dynamic> chatList = [];
  int page = 1;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    // Initialize Socket.IO connection
    socket = IO.io('https://jobs.creativeapplab.in/', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    // Connect to server
    socket.connect();

    // Listen to 'chat_list' event
    socket.on('chat_list', (data) {
      print('Received datas: $data');
      var responseData = data['data'];
      print("Response : $responseData");
      setState(() {
        chatList.add(responseData);
      });
      // Data loaded, set isLoading to false
      setState(() {
        isLoading = false;
      });
    });

    // Listen to 'connect_error' event
    socket.on('connect_error', (error) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Connection Error'),
            content: Text('Please check your internet connection.'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    });

    // Fetch initial chat list
    fetchChatList();

    // Listen for scroll events
    ScrollController scrollController = ScrollController();
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        // If user reached the bottom of the list, load more data
        fetchChatList();
      }
    });
  }

  @override
  void dispose() {
    // Disconnect socket when not in use
    socket.disconnect();
    super.dispose();
  }

  // Function to fetch chat list data
  void fetchChatList() {
    if (!isLoading) {
      setState(() {
        isLoading = true; // Set isLoading to true before fetching data
      });

      // Emit 'chat_list' event with pagination parameters
      socket.emit('chat_list', {
        "user_id": "1",
        "access_token": "13a761e10063f408f3c6c8622a156c38",
        "page": page,
      });

      // Increment page number for next pagination
      page++;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Socket.IO Example'),
      ),
      body: ListView.builder(
        itemCount: chatList.length + 1,
        itemBuilder: (context, index) {
          if (index < chatList.length) {
            // Display chat message
            return ListTile(
              leading: IconButton(onPressed: () {}, icon: Icon(Icons.abc)),
              title: Text(
                chatList[index].toString(),
                style: TextStyle(fontSize: 35),
              ),
            );
          } else {
            // Display loading indicator only when isLoading is true
            return isLoading
                ? Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : SizedBox(); // Otherwise, return an empty SizedBox
          }
        },
      ),
    );
  }
}
