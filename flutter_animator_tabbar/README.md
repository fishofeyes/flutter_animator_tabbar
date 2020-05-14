# flutter_animator_tabbar

仿美团的tabbar效果

## Example

```
class RootPage extends StatefulWidget {
  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {

  final PageController _controller = PageController(initialPage: 2);
  int index = 2;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _controller,
        children: [
          HomeScreen("abc"),
          HomeScreen("bbc"),
        ],
      ),
      bottomNavigationBar: TabAnimationBar(
        index: index,
        backgroundColor: Colors.white,
        children: List.generate(5, (index) => Icon(Icons.home, size: 30,)),
        selectedChildren: List.generate(5, (index) => Icon(Icons.image, size: 30,color: Colors.cyan,)),
        onPress: (int selected){
          _controller.jumpToPage(selected);
        },
      ),
    );
  }
}
```

## Getting Started

This project is a starting point for a Dart
[package](https://flutter.dev/developing-packages/),
a library module containing code that can be shared easily across
multiple Flutter or Dart projects.

For help getting started with Flutter, view our 
[online documentation](https://flutter.dev/docs), which offers tutorials, 
samples, guidance on mobile development, and a full API reference.
