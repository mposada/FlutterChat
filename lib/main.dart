import 'package:flutter/material.dart';

const String _name = "Miguel Posada";

void main() => runApp(new FriendlyChatApp());

class FriendlyChatApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(title: "Friendlychat", home: new ChatScreen());
  }

}

class ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {

  final TextEditingController _textController = new TextEditingController();
  final List<ChatMessage> _messages = <ChatMessage>[];

  Widget _buildTextComposer() {
    return new Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: new Row(
        children: <Widget>[
          new Flexible(child: new TextField(
              controller: _textController,
              onSubmitted: _handleSubmitted,
              decoration: new InputDecoration.collapsed(hintText: "Send message"))
          ),
          new Container(
            margin: new EdgeInsets.symmetric(horizontal: 4.0),
            child: new IconButton(
                icon: new Icon(Icons.send),
                color: Colors.blue,
                onPressed: () => _handleSubmitted(_textController.text)
            ),
          )
        ],
      ),
    );
  }

  void _handleSubmitted(String text) {
    _textController.clear();
    ChatMessage chatMessage = new ChatMessage(
        text: text,
        animationController: new AnimationController(duration: new Duration(milliseconds: 700), vsync: this)
    );
    setState(() {
      _messages.insert(0, chatMessage);
    });
    // animation should play forward
    chatMessage.animationController.forward();
  }

  /**
   * It's good practice to dispose of your animation controllers to free up
   * your resources when they are no longer needed. The following code snippet
   * shows how you can implement this operation by overriding the dispose()
   * method in ChatScreenState. In the current app, the framework does not call
   * the dispose()method since the app only has a single screen.
   *
   * In a more complex app with multiple screens, the framework would invoke
   * the method when the ChatScreenState object was no longer in use.
   */
  @override
  void dispose() {
    for (ChatMessage message in _messages)
      message.animationController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text("Friendlychat")),
      body: new Column(
        children: <Widget>[
          new Flexible(child: new ListView.builder(
            padding: new EdgeInsets.all(8.0),
            reverse: true,
            itemBuilder: (_, int index) => _messages[index],
            itemCount: _messages.length,
          )),
          new Divider(height: 1.0),
          new Container(
            decoration: new BoxDecoration(color: Theme.of(context).cardColor),
            child: _buildTextComposer(),
          )
        ],
      ),
    );
  }

}

class ChatScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => new ChatScreenState();
}

class ChatMessage extends StatelessWidget {

  ChatMessage({this.text, this.animationController});
  final String text;
  final AnimationController animationController;

  @override
  Widget build(BuildContext context) {
    return new SizeTransition(
      sizeFactor: new CurvedAnimation(parent: animationController, curve: Curves.easeOut),
      axisAlignment: 0.0,
      child: new Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: new Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Container(
              margin: const EdgeInsets.only(right: 16.0),
              child: new CircleAvatar(child: new Text(_name[0])),
            ),
            new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text(_name, style: Theme.of(context).textTheme.subhead),
                new Container(
                  margin: const EdgeInsets.only(top: 5.0),
                  child: new Text(text),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

}




