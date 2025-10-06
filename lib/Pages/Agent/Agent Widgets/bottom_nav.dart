import 'package:flutter/material.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNav({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  final List<dynamic> items = const [
    Icons.home,
    Icons.delivery_dining,
    Icons.person,
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final desiredWidth = screenWidth - 30.0;

    return SizedBox(
      height: 130,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            height: 60,
            width: desiredWidth,
            margin: EdgeInsets.only(bottom: 25),
            decoration: BoxDecoration(
              color: Color(0xFFFF863B),
              borderRadius: const BorderRadius.all(Radius.circular(60),
              ),
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(items.length, (index) {
              bool isSelected = currentIndex == index;

              return GestureDetector(
                onTap: () => onTap(index),
                child: Container(
                  margin: EdgeInsets.only(bottom: isSelected ? 40 : 0),
                  padding: isSelected ? const EdgeInsets.all(8.0) : EdgeInsets.zero,
                  decoration: isSelected
                      ? const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ) : null,
                  child: Container(
                    height: isSelected ? 55 : 45,
                    width: isSelected ? 55 : 45,
                    decoration: BoxDecoration(
                      color: isSelected ? Color(0xFFFF863B) : Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: isSelected ? [
                        const BoxShadow(
                          color: Colors.black26,
                          blurRadius: 6,
                          offset: Offset(0, 4),
                        )
                      ]: [],
                    ),
                    child: items[index] is IconData ? Icon(
                      items[index],
                      color: isSelected ? Colors.white : Color(0xFFFF863B),
                    ) : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        items[index],
                        color: isSelected ? Colors.white : Color(0xFFFF863B),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
