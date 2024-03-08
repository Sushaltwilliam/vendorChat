import 'package:chat_vendor/const/colors.dart';
import 'package:chat_vendor/const/const_value.dart';
import 'package:chat_vendor/const/image.dart';
import 'package:chat_vendor/provider/chat_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class OneToOneChatRoomScreen extends StatefulWidget {
  final String userId;
  const OneToOneChatRoomScreen({super.key, required this.userId});

  @override
  State<OneToOneChatRoomScreen> createState() => _OneToOneChatRoomScreenState();
}

class _OneToOneChatRoomScreenState extends State<OneToOneChatRoomScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<UserChatProvider>(context, listen: false)
        .oneToOneChatList(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UserChatProvider>(context);
    final userDetails = provider.findById(widget.userId);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: customColors.lightGreenColor.withOpacity(0.2),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Icon(Icons.arrow_back)),
            CircleAvatar(
              backgroundImage: NetworkImage(restApiUrl + userDetails.imageUrl),
            ),
            SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userDetails.name,
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  "Online",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                )
              ],
            ),
          ],
        ),
        actions: [
          Image.asset(
            customImages.calenderImage,
            width: 35,
            height: 35,
          ),
          IconButton(onPressed: () {}, icon: Icon(Icons.more_vert))
        ],
      ),
      body: ListView.builder(
        reverse: false,
        itemCount: provider.listOfOneToOneMessage.length,
        itemBuilder: (ctx, index) {
          final message = provider.listOfOneToOneMessage[index];
          final currentDate = DateTime.now();
          final yesterdayDate = DateTime.now().subtract(Duration(days: 1));

          // Check if the message's date is today, yesterday, or a different date
          String dateString;
          if (currentDate.day == message.createdDate.day &&
              currentDate.month == message.createdDate.month &&
              currentDate.year == message.createdDate.year) {
            dateString = 'Today';
          } else if (yesterdayDate.day == message.createdDate.day &&
              yesterdayDate.month == message.createdDate.month &&
              yesterdayDate.year == message.createdDate.year) {
            dateString = 'Yesterday';
          } else {
            dateString = DateFormat('yyyy-MM-dd').format(message.createdDate);
          }

          // If this is the first message of the day, display a header
          if (index == 0 ||
              provider.listOfOneToOneMessage[index - 1].createdDate.day !=
                  message.createdDate.day) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(dateString,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      margin: const EdgeInsets.all(8),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10),
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                        ),
                      ),
                      child: Text(message.message),
                    ),
                  ],
                ),
              ],
            );
          } else {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10),
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                    ),
                  ),
                  child: Text(message.message),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
