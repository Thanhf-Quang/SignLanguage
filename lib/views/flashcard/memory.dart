import 'package:flutter/material.dart';
import '../../controllers/memory_game_controller.dart';
import '../../models/CardItem.dart';
import 'flashcard.dart';

class MemoryGame extends StatefulWidget {
  @override
  _MemoryGameState createState() => _MemoryGameState();
}

class _MemoryGameState extends State<MemoryGame> {
  late MemoryGameController _controller;

  @override
  void initState() {
    super.initState();
    _controller = MemoryGameController(onUpdate: () => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    const gridCount = 4;

    return Scaffold(
      backgroundColor: Color(0xFFFFF8EE),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xFFFFF8EE),
        title: Text('Memory Game', style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
      ),
      body: Center(
        child: _controller.gameCompleted
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('🎉 You have completed the game!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => FlashCardScreen()),
                );
              },
              child: Text('Continue'),
            ),
          ],
        )
            : Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            height: 400,
            child: GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: _controller.shuffled.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: gridCount,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemBuilder: (context, index) {
                final revealed = _controller.revealed[index] || _controller.selectedIndexes.contains(index);
                final card = _controller.shuffled[index];

                return GestureDetector(
                  onTap: () => _controller.onTileTap(index),
                  child: FlipCard(
                    revealed: revealed,
                    front: Container(
                      decoration: BoxDecoration(
                        color: Color(0xFFCFA96F),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    back: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
                      ),
                      child: Center(
                        child: card.isImage
                            ? Image.asset(card.content, width: 60, height: 60)
                            : Text(card.content, style: TextStyle(fontSize: 32)),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class FlipCard extends StatefulWidget {
  final bool revealed;
  final Widget front;
  final Widget back;

  const FlipCard({required this.revealed, required this.front, required this.back});

  @override
  _FlipCardState createState() => _FlipCardState();
}

class _FlipCardState extends State<FlipCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _flip;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: Duration(milliseconds: 300), vsync: this);
    _flip = Tween<double>(begin: 0, end: 1).animate(_controller);
    if (widget.revealed) _controller.forward();
  }

  @override
  void didUpdateWidget(covariant FlipCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.revealed != oldWidget.revealed) {
      widget.revealed ? _controller.forward() : _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _flip,
      builder: (context, child) {
        final isFront = _flip.value < 0.5;
        final angle = _flip.value * 3.1416;

        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.rotationY(angle),
          child: isFront
              ? widget.front
              : Transform(
            alignment: Alignment.center,
            transform: Matrix4.rotationY(3.1416),
            child: widget.back,
          ),
        );
      },
    );
  }
}
