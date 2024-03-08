import 'package:chat_vendor/const/colors.dart';
import 'package:chat_vendor/const/const_value.dart';
import 'package:chat_vendor/screen/allChatViewScreen/widget/serach_field_controller.dart';
import 'package:chat_vendor/screen/oneToOneChatScreen/one_to_one_chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/chat_list_provider.dart';

class AllUserChatScreen extends StatefulWidget {
  const AllUserChatScreen({super.key});

  @override
  State<AllUserChatScreen> createState() => _AllUserChatScreenState();
}

class _AllUserChatScreenState extends State<AllUserChatScreen> {
  void initState() {
    super.initState();
    // Initialize socket when the screen is loaded
    Provider.of<UserChatProvider>(context, listen: false).initializeSocket();
     Provider.of<UserChatProvider>(context, listen: false).fetchChatList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () {}, icon: Icon(Icons.arrow_back)),
        title: Text('Message'),
      ),
      body: Container(
        margin: const EdgeInsets.all(10),
        child: Column(
          children: [
            SearchFormFieldController(),
            Expanded(
              child: Consumer<UserChatProvider>(
                builder: (context, chatProvider, _) {
                  return chatProvider.searchController.text.trim().isEmpty
                      ? ListView.separated(
                          itemCount: chatProvider.allChatUserData.length,
                          itemBuilder: (context, index) {
                            // Build your chat message UI using chatProvider.chatList[index]
                            return ListTile(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (ctx) =>
                                        OneToOneChatRoomScreen(userId: chatProvider.allChatUserData[index].userId,)));
                              },
                              leading: CircleAvatar(
                                radius: 25,
                                backgroundImage: NetworkImage(restApiUrl +
                                    chatProvider
                                        .allChatUserData[index].imageUrl),
                              ),
                              title: Text(
                                chatProvider.allChatUserData[index].name,
                                maxLines: 1,
                              ),
                              subtitle: Text(
                                chatProvider.allChatUserData[index].lastMessage,
                                maxLines: 1,
                              ),
                              trailing: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(chatProvider.formatTimeDifference(
                                      chatProvider
                                          .allChatUserData[index].dateTime)),
                                  chatProvider.allChatUserData[index]
                                              .unreadCount <=
                                          0
                                      ? Container(
                                          width: 5,
                                          height: 5,
                                        )
                                      : Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: customColors.lightGreenColor,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Text(
                                            chatProvider.allChatUserData[index]
                                                .unreadCount
                                                .toString(),
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        )
                                ],
                              ),
                              // Customize the UI as per your chat message structure
                            );
                          },
                          separatorBuilder: (ctx, index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Divider(
                                color: Colors.grey.shade300,
                              ),
                            );
                          },
                        )
                      : chatProvider.searchController.text.isNotEmpty &&
                              chatProvider.allSerachUserData.isNotEmpty
                          ? ListView.separated(
                              itemCount: chatProvider.allSerachUserData.length,
                              itemBuilder: (context, index) {
                                // Build your chat message UI using chatProvider.chatList[index]
                                return ListTile(
                                  leading: CircleAvatar(
                                    radius: 25,
                                    backgroundImage: NetworkImage(restApiUrl +
                                        chatProvider
                                            .allSerachUserData[index].imageUrl),
                                  ),
                                  title: Text(
                                    chatProvider.allSerachUserData[index].name,
                                    maxLines: 1,
                                  ),
                                  subtitle: Text(
                                    chatProvider
                                        .allSerachUserData[index].lastMessage,
                                    maxLines: 1,
                                  ),
                                  trailing: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(chatProvider.formatTimeDifference(
                                          chatProvider.allChatUserData[index]
                                              .dateTime)),
                                      chatProvider.allSerachUserData[index]
                                                  .unreadCount <=
                                              0
                                          ? Container(
                                              width: 5,
                                              height: 5,
                                            )
                                          : Container(
                                              padding: const EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                color: customColors
                                                    .lightGreenColor,
                                                shape: BoxShape.circle,
                                              ),
                                              child: Text(
                                                chatProvider
                                                    .allSerachUserData[index]
                                                    .unreadCount
                                                    .toString(),
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            )
                                    ],
                                  ),
                                  // Customize the UI as per your chat message structure
                                );
                              },
                              separatorBuilder: (ctx, index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: Divider(
                                    color: Colors.grey.shade300,
                                  ),
                                );
                              },
                            )
                          : Center(
                              child: Text("Nothing found"),
                            );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
