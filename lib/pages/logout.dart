import "package:flutter/material.dart";

class LogOut extends StatelessWidget {
  const LogOut({super.key});


  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Log Out',
        style: TextStyle(fontSize: 50),
      ),
    );
  }
}
