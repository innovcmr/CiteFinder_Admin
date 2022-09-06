import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/agent_controller.dart';

class AgentView extends GetView<AgentController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AgentView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'AgentView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
