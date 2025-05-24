import 'package:flutter/material.dart';

Widget buildSideDrawer(BuildContext context) {
  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
        const UserAccountsDrawerHeader(
          accountName: Text('박재효'),
          accountEmail: Text('202020261@gmail.com'),
          currentAccountPicture: CircleAvatar(
            backgroundImage: NetworkImage(
              'https://via.placeholder.com/150',
            ), // ✅ 실제 이미지 URL로 교체 가능
          ),
          decoration: BoxDecoration(color: Colors.amber),
        ),
        ListTile(
          leading: const Icon(Icons.home),
          title: const Text('home'),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        /* ListTile(
          leading: const Icon(Icons.video_library),
          title: const Text('Youtube "기타치는 개발자 Glacier"'),
          onTap: () {
            // You can use url_launcher package here
          },
        ),
        ListTile(
          leading: const Icon(Icons.shop),
          title: const Text('Android Play Store'),
          onTap: () {},
        ),
        */
        ListTile(
          leading: const Icon(Icons.star),
          title: const Text('Instagram'),
          onTap: () {},
        ),
      ],
    ),
  );
}
