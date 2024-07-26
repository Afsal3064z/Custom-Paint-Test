import 'package:flutter/material.dart';

class SliverStackScrollView extends StatefulWidget {
  const SliverStackScrollView({super.key});

  @override
  _SliverStackScrollViewState createState() => _SliverStackScrollViewState();
}

class _SliverStackScrollViewState extends State<SliverStackScrollView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Add a listener to update the state when scrolling
    _scrollController.addListener(() {
      setState(() {}); // Rebuild to update the position of containers
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sliver Stacked Containers"),
      ),
      body: Stack(
        children: [
          // The scrollable area
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return Container(
                      color: Colors
                          .transparent, // Transparent so it doesn't obstruct the stacked view
                      height: 200, // The height of each container
                    );
                  },
                  childCount: 4,
                ),
              ),
            ],
          ),
          // The stacked containers
          Positioned.fill(
            child: Stack(
              clipBehavior: Clip.none,
              children: List.generate(
                4,
                (index) {
                  double offset = _scrollController.hasClients
                      ? _scrollController.offset
                      : 0;
                  return Positioned(
                    top: index * 50.0 - offset,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 200,
                      color: Colors.primaries[index % Colors.primaries.length],
                      child: Center(
                        child: Text(
                          'Container ${index + 1}',
                          style: const TextStyle(
                              fontSize: 24, color: Colors.white),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
