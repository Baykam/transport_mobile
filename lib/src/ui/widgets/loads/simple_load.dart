import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:transport/src/domain/model/simpleLoad.dart';

class SimpleLoadMain extends StatelessWidget {
  const SimpleLoadMain({super.key, required this.simpleLoads});

  final SimpleLoad simpleLoads;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Material(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: Colors.grey.shade100),
        ),
        shadowColor: Colors.black.withOpacity(0.04),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: (){},
          child: Column(
            children: [
              // IMAGE SECTION
              SizedBox(
                height: 140,
                child: Stack(
                  children: [
                    ListView.separated(
                      padding: const EdgeInsets.all(12),
                      scrollDirection: Axis.horizontal,
                      itemCount: 4,
                      separatorBuilder: (context, index) => const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: (){},
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              'https://picsum.photos/300/200?image=${index + 10}',
                              width: 220,
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    ),
                    // Single, Clean Favorite Button
                    Positioned(
                      right: 20,
                      top: 20,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          shape: BoxShape.circle,
                          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
                        ),
                        child: IconButton(
                          onPressed: () {},
                          constraints: const BoxConstraints(), // Removes default padding
                          padding: const EdgeInsets.all(8),
                          icon: const Icon(Symbols.favorite_rounded, size: 20),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // CONTENT SECTION
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
                child: Column(
                  children: [
                    // ROW 1: Title, Category, Price
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                simpleLoads.title ?? 'No Title',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 18,
                                  letterSpacing: -0.5,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                simpleLoads.category?.toUpperCase() ?? 'GENERAL',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.blueAccent.shade700,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1.1,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '\$${simpleLoads.price}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 22,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),

                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Divider(height: 1, thickness: 0.5),
                    ),

                    // ROW 2: Locations and Date
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            '${simpleLoads.startLocation} — ${simpleLoads.endLocation}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade800,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Text(
                          simpleLoads.finishDate ?? '',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade400,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}