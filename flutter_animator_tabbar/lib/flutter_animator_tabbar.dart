library flutter_animator_tabbar;

import 'package:flutter/material.dart';

///
/// 修改duration 、 curve、 circleOffset 属性的时候需要reload
///
///
class TabAnimationBar extends StatefulWidget {

  final Color backgroundColor;            // tabbarView的背景颜色
  final List<Widget> children;
  final List<Widget> selectedChildren;
  int index;
  final Function(int selected) onPress;
  final Color dividerColor;               // 分割线颜色
  final double circleOffset;              // 圆突出的范围10 - 30
  final double circleRadiuOffset;         // 圆大小的偏移
  final Duration animateDuration; 
  final Curve curve; 

  TabAnimationBar({
      Key key, 
      @required this.backgroundColor, 
      @required this.children, 
      @required this.onPress, 
      @required this.selectedChildren,
      this.dividerColor = Colors.black12,
      this.index = 0,
      this.circleOffset = 10,
      this.circleRadiuOffset = 0,
      this.animateDuration = const Duration(milliseconds: 200),
      this.curve = Curves.bounceOut
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
    _controller = AnimationController(vsync: this, duration: widget.animateDuration);
    CurvedAnimation _cure = CurvedAnimation(curve: widget.curve, parent: _controller);
    _animation = Tween<double>(begin: 0, end: widget.circleOffset).animate(_cure)
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
    final height = 44 + margin.bottom;
    return Stack(
      children: [
        CustomPaint(
        size: Size(size.width, height),
        painter: WaveTabbar(
          index: widget.index,
          valY: _animation.value,
          color: widget.backgroundColor,
          circleRadiusOffset: widget.circleRadiuOffset,
          childrenCount: widget.children.length,
          dividerColor: widget.dividerColor
        ),),
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
  final Color dividerColor;
  final double circleRadiusOffset;

  WaveTabbar({
    this.index, 
    this.valY, 
    this.color, 
    this.childrenCount,
    this.dividerColor = Colors.black12,
    this.circleRadiusOffset = 0
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
    ..color = color
    ;
    final circleY = -valY;

    double circleWidth = size.height + circleRadiusOffset;
    // 计算间距
    double distance = (size.width / childrenCount - circleWidth) / 2.0;

    final paint2 = Paint()
    ..color = dividerColor
    ..strokeWidth = 0.5
    ..style = PaintingStyle.stroke
    ;
    canvas.drawLine(Offset(0, 0), Offset(size.width, 0), paint2);

    // 绘制圆
    Path path = Path()
    ..addOval(Rect.fromLTWH((size.width) / childrenCount * index + distance, circleY, circleWidth, circleWidth));
    canvas.drawPath(path, paint);

    // 绘制圆的边框
    double circleRadiu = circleWidth / 2.0 + 0.5;
    canvas.drawCircle(Offset((size.width) / childrenCount * index + distance + circleRadiu , circleY + circleRadiu), circleRadiu, paint2);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

}
