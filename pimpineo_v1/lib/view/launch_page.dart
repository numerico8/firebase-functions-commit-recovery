import 'package:flutter/material.dart';
import 'package:pimpineo_v1/viewmodels/launch_page_view_model.dart';
import 'package:provider_architecture/provider_architecture.dart';



class LaunchPage extends StatelessWidget {
  static const route = '/launch';  
  
  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<LaunchPageViewModel>.withConsumer(
      viewModel: LaunchPageViewModel(),
      onModelReady: (model) => model.handleInitialLogic(context),
      builder: (context, model, child) => SafeArea(
        child: Scaffold(
          body: Stack(
            children: <Widget>[
              Center(
                child: CircleAvatar(
                  radius: 36,
                  backgroundColor: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: Text(
                      'P',
                      style: TextStyle(
                        color: Colors.blue[800],
                        fontFamily: 'Pacifico',
                        fontSize: 38
                      ),
                    ),
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 0.0),
                  child: SizedBox(
                    height: 60,
                    width: 60,
                    child: CircularProgressIndicator(
                      strokeWidth: 5,
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                      backgroundColor: Colors.blue[800],
              ),
                  ),
                ),)
              // Center(
              //   child: CircleAvatar(
              //     radius: 32,
              //     backgroundColor: Colors.white,
              //     child: Text(
              //       'P',
              //       style: TextStyle(
              //         color: Colors.blue[800],
              //         fontFamily: 'Pacifico',
              //         fontSize: 36
              //       ),
              //     ),
              //   ),
              // ),
              // Center(
              //   child: SizedBox(
              //     height: 55,
              //     width: 55,
              //     child: CircularProgressIndicator(
              //       strokeWidth: 4,
              //       valueColor: AlwaysStoppedAnimation(Colors.blue),
              //       backgroundColor: Colors.white,
              // ),
              //   ),)
            ],
          ),
          backgroundColor: Colors.blue[800],
        ),
      ),
    );    
  }    
  

}