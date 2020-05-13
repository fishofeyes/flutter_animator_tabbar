library flutter_animator_tabbar;

import 'package:flutter/material.dart';

class TabAnimationBar extends StatefulWidget {

  final Color backgroundColor;
  final List<Widget> children;
  final List<Widget> selectedChildren;
  int index;
  final Function(int selected) onPress;

  TabAnimationBar({
      Key key, 
      @required this.backgroundColor, 
      @required this.children, 
      @required this.onPress, 
      @required this.selectedChildren,
      this.index = 0
    })
     : super(key: key);

  @override
  _TabAnimationPageState createState() => _TabAnimationPageState();
}

class _TabAnimationPageState extends State<TabAnimationBar> with SingleTickerProviderStateMixin {

  AnimationController _controller;
  Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    CurvedAnimation _cure = CurvedAnimation(curve: Curves.bounceOut, parent: _controller);
    _animation = Tween<double>(begin: 0, end: 10).animate(_cure)
    ..addListener((){
      setState(() {
        
      });
    });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  _onIconPressed(int index) async {
    // 首先重置弧度的位置
    if(_controller.status == AnimationStatus.completed){
      await _controller.reverse();
    } 
    setState(() {
      widget.index = index;
    });
    widget.onPress(index);
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final margin = MediaQuery.of(context).padding;
    final height = 40 + margin.bottom;
    return Stack(
      children: [
        CustomPaint(
        size: Size(size.width, height),
        painter: WaveTabbar(
          index: widget.index,
          valY: _animation.value,
          color: widget.backgroundColor,
          childrenCount: widget.children.length
        )),
        Container(
          height: height,
          padding: EdgeInsets.only(bottom: margin.bottom / 3),
          color: widget.backgroundColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(widget.children.length, (index) => GestureDetector(
              child: widget.index == index ? widget.selectedChildren[index] : widget.children[index],
              onTap:() => _onIconPressed(index),
            )),
          ),
        ),
      ],
    );
  }
}

class WaveTabbar extends CustomPainter {
  final int index;
  final double valY;
  final Color color;
  final int childrenCount;

  WaveTabbar({this.index, this.valY, this.color, this.childrenCount});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
    ..color = color
    ;
    final circleY = -valY;
    // 计算间距
    double distance = (size.width / childrenCount - size.height) / 2.0;

    final paint2 = Paint()
    ..color = Colors.black12
    ..strokeWidth = 0.5
    ..style = PaintingStyle.stroke
    ;
    canvas.drawLine(Offset(0, 0), Offset(size.width, 0), paint2);

    // 绘制圆
    Path path = Path()
    ..addOval(Rect.fromLTWH((size.width) / childrenCount * index + distance, circleY, size.height, size.height));
    canvas.drawPath(path, paint);

    // 绘制圆的边框
    double circleRadiu = size.height / 2.0 + 0.5;
    canvas.drawCircle(Offset((size.width) / childrenCount * index + distance + circleRadiu , circleY + circleRadiu), circleRadiu, paint2);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

}
