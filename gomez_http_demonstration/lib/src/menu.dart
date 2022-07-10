import 'package:flutter/material.dart';
import 'package:gomez_http_demonstration/src/getAll.dart';
class MainMenu extends StatefulWidget {
  const MainMenu({Key? key}) : super(key: key);

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Daryll's HTTP Demonstration App v0.1"),
        backgroundColor: const Color(0xFF303030),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text("This application tests various web requests. Press a button to craft a web request"),
              SizedBox(height: 30),
              Text("Written with spite and anger by Daryll A. Gomez"),
              SizedBox(height: 10),
              ElevatedButton.icon(onPressed: (){print("Hi! Web Button Pressed!");
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const GetAll()),
              );
              }, icon: Icon(Icons.web), label: Text("Perform GET Request")),
              SizedBox(height: 20),
              ElevatedButton.icon(onPressed: (){print("Hi! Web Button Pressed!");}, icon: Icon(Icons.web), label: Text("Perform POST Request")),
              SizedBox(height: 20),
              ElevatedButton.icon(onPressed: (){print("Hi! Web Button Pressed!");}, icon: Icon(Icons.web), label: Text("Perform DELETE Request")),
              SizedBox(height: 20),
              ElevatedButton.icon(onPressed: (){print("Hi! Web Button Pressed!");}, icon: Icon(Icons.web), label: Text("Perform PATCH Request")),
              SizedBox(height: 20),
              ElevatedButton.icon(onPressed: (){print("Hi! Web Button Pressed!");}, icon: Icon(Icons.web), label: Text("Perform Custom Web Request")),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),

    );
  }
}
