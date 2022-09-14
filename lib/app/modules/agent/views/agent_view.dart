import 'package:cite_finder_admin/app/modules/home/views/home_view.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/agent_controller.dart';

class AgentView extends GetView<AgentController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeView().MainAppBar(),
      drawer: MainDrawer(),
      body: Center(
        child: Text(
          'AgentView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
