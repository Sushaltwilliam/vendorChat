import 'package:chat_vendor/provider/chat_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchFormFieldController extends StatelessWidget {
  const SearchFormFieldController({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final provider = Provider.of<UserChatProvider>(context);
    return Container(
      height: size.height * 0.05,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: Colors.grey.shade200,
      ),
      child: TextFormField(
        onChanged: (val) {


            provider.searchUserQuery(val.toString());
         
        },
        decoration: const InputDecoration(
            prefixIcon: Icon(Icons.search),
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            focusedErrorBorder: InputBorder.none,
            hintText: 'Search Message'),
        controller: provider.searchController,
      ),
    );
  }
}
