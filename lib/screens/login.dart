// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

void main() => runApp(
  MaterialApp(
    home: LoginPage(),
  )
  );

class LoginPage extends StatelessWidget {
  const LoginPage({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints.expand(),
      decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.jpg'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(Colors.black12, BlendMode.darken)
              )
            ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SafeArea(
              child :SizedBox(
                height: 400,
                child: Card(
                  elevation: 16,
                  shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    children:   [
                      // Welcome Admin
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Icon(
                          Icons.home_outlined,
                          color: Color(0xFF431C69),
                          size: 60,
                        ),
                      ),
                      Text(
                        'Welcome Admin',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 27,
                          letterSpacing: 1.0,
                          color: Color(0xFF431C69),
                        ),
                      ),
                      SizedBox(height: 30),
                
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 25.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(12)
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child:
                                TextField(
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.person,
                                      color: Color(0xFF8560A8),
                                    ),
                                    border: InputBorder.none,
                                    hintText: 'Full Name',
                                    hintStyle: TextStyle(
                                      color: Color(0xFF696880),
                                    )
                                  ),
                                ),
                              
                          ),
                        ),
                        ),
                
                        SizedBox(height: 25.0),
                        Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 25.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.grey[100],
                                          border: Border.all(color: Colors.white),
                                          borderRadius: BorderRadius.circular(12)
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 20.0),
                                          child: TextField(
                                            obscureText: true,
                                            decoration: InputDecoration(
                                              prefixIcon: Icon(
                                              Icons.lock,
                                              color: Color(0xFF8560A8),
                                    ),
                                              border: InputBorder.none,
                                              hintText: 'Password',
                                              hintStyle: TextStyle(
                                                color: Color(0xFF696880)
                                              )
                                              
                                            ),
                                          ),
                                        ),
                                      )),
                          SizedBox(height: 25.0),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Container(
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color:Color(0xFF431C69),
                                borderRadius: BorderRadius.circular(20)
                              ),
                              child: Center(
                                child: Text(
                                  'Login',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    ),
                                ),
                              ),
                            ),
                          )
                  ],
                  ),
                ),
              ),
            ),
          ),
        ),
        
      ),
    );
  }
}
