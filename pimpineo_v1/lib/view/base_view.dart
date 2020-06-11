import 'package:flutter/material.dart';
import 'package:pimpineo_v1/services/locator.dart';
import 'package:pimpineo_v1/viewmodels/base_model.dart';
import 'package:provider/provider.dart';


class BaseView<T extends BaseModel> extends StatefulWidget {

  final Widget Function(BuildContext context, T model, Widget child) builder;
  final Function(T) onModelReady;
  final Widget child;

  BaseView({this.builder, this.onModelReady, this.child});

  @override
  _BaseViewState<T> createState() => _BaseViewState<T>();

}

class _BaseViewState<T extends BaseModel> extends State<BaseView<T>> {
  T model = locator<T>();

  
  @override
  void initState() {
    if(widget.onModelReady != null){
      widget.onModelReady(model);
    }
    super.initState();
  }

  
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<T>.value(
      value: model,   //it has to be a value that already extends ChangeNotifier 
      child: Consumer<T>(
          builder:widget.builder,
          child: widget.child,));
  }
}