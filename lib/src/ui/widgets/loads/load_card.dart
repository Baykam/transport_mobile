import 'package:flutter/material.dart';
import 'package:transport/src/domain/model/simpleLoad2.dart';
import 'package:transport/src/helper/theme/theme.dart';

class LoadCard extends StatelessWidget {
  final SimpleLoad2 load; // Use the model directly
  final VoidCallback? onTap;
  final Widget? trailing;

  const LoadCard({
    super.key,
    required this.load,
    this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppTheme.surfaceCard,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.divider, width: 0.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  load.id ?? 'No ID', // Handle null id
                  style: const TextStyle(
                    color: AppTheme.primary,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
                StatusBadge(
                  label: (load.status ?? 'Unknown').toUpperCase().replaceAll('_', ' '),
                  color: statusColor(load.status ?? 'unknown'),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        load.origin ?? 'Unknown Origin',
                        style: const TextStyle(
                          color: AppTheme.onBackground,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Container(
                            width: 1.5,
                            height: 14,
                            color: AppTheme.primary.withOpacity(0.5),
                            margin: const EdgeInsets.only(left: 4),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            load.mode ?? 'N/A',
                            style: const TextStyle(
                              color: AppTheme.onSurfaceMuted,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        load.destination ?? 'Unknown Destination',
                        style: const TextStyle(
                          color: AppTheme.onBackground,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '\$${load.price?.toStringAsFixed(0) ?? '0'}', // Handle null price
                      style: const TextStyle(
                        color: AppTheme.onBackground,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      load.date ?? '--/--/--',
                      style: const TextStyle(
                        color: AppTheme.onSurfaceMuted,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(
                  Icons.inventory_2_outlined,
                  size: 12,
                  color: AppTheme.onSurfaceMuted,
                ),
                const SizedBox(width: 4),
                Text(
                  load.cargo ?? 'Not specified',
                  style: const TextStyle(
                    color: AppTheme.onSurfaceMuted,
                    fontSize: 12,
                  ),
                ),
                if (trailing != null) ...[
                  const Spacer(),
                  trailing!,
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}