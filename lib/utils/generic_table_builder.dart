import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as flutter_table;

class TableRow {
  final String label;
  final String value;
  final bool isHeader;
  final Color? backgroundColor;
  final TextStyle? labelStyle;
  final TextStyle? valueStyle;

  const TableRow({
    required this.label,
    required this.value,
    this.isHeader = false,
    this.backgroundColor,
    this.labelStyle,
    this.valueStyle,
  });
}

enum TableStyle {
  simple,
  bordered,
}

class GenericTableBuilder {
  static Widget buildResultCard(
    BuildContext context, {
    required String title,
    required List<TableRow> rows,
    VoidCallback? onSave,
    String? saveTooltip,
    TableStyle style = TableStyle.simple,
    Color? backgroundColor,
    Widget? footer,
  }) {
    final theme = Theme.of(context);

    return Card(
      elevation: style == TableStyle.bordered ? 4 : 2,
      color: backgroundColor ?? theme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (onSave != null)
                  IconButton(
                    onPressed: onSave,
                    icon: const Icon(Icons.bookmark_add_outlined),
                    tooltip: saveTooltip ?? 'Save to bookmarks',
                    iconSize: 20,
                    constraints: const BoxConstraints(
                      minWidth: 32,
                      minHeight: 32,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            style == TableStyle.bordered
                ? _buildBorderedTable(context, rows)
                : _buildTable(context, rows),
            if (footer != null) ...[
              footer,
            ],
          ],
        ),
      ),
    );
  }

  static Widget _buildTable(BuildContext context, List<TableRow> rows) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: rows.asMap().entries.map((entry) {
          final index = entry.key;
          final row = entry.value;
          final isLast = index == rows.length - 1;

          return Container(
            decoration: BoxDecoration(
              color: row.backgroundColor ??
                  (row.isHeader
                      ? theme.colorScheme.primaryContainer
                          .withValues(alpha: 0.3)
                      : Colors.transparent),
              border: !isLast
                  ? Border(
                      bottom: BorderSide(
                        color: theme.colorScheme.outline.withValues(alpha: 0.2),
                        width: 1,
                      ),
                    )
                  : null,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      row.label,
                      style: row.labelStyle ??
                          (row.isHeader
                              ? theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.onPrimaryContainer,
                                )
                              : theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w500,
                                )),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      row.value,
                      style: row.valueStyle ??
                          (row.isHeader
                              ? theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.onPrimaryContainer,
                                )
                              : theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.primary,
                                )),
                      textAlign: TextAlign.end,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  static Widget _buildBorderedTable(BuildContext context, List<TableRow> rows) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: theme.dividerColor,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      clipBehavior: Clip.antiAlias,
      child: flutter_table.Table(
        columnWidths: const {
          0: flutter_table.MaxColumnWidth(flutter_table.FixedColumnWidth(180),
              flutter_table.FlexColumnWidth(2)),
          1: flutter_table.FlexColumnWidth(3),
        },
        border: flutter_table.TableBorder(
          horizontalInside: flutter_table.BorderSide(
            color: theme.dividerColor,
            width: 0.5,
          ),
          verticalInside: flutter_table.BorderSide(
            color: theme.dividerColor,
            width: 0.5,
          ),
        ),
        children:
            rows.map((row) => _buildBorderedTableRow(context, row)).toList(),
      ),
    );
  }

  static flutter_table.TableRow _buildBorderedTableRow(
      BuildContext context, TableRow row) {
    final theme = Theme.of(context);

    return flutter_table.TableRow(
      children: [
        flutter_table.TableCell(
          verticalAlignment: flutter_table.TableCellVerticalAlignment.fill,
          child: Container(
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              color: row.backgroundColor ??
                  theme.colorScheme.primaryContainer.withValues(alpha: 0.2),
            ),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            child: Text(
              row.label,
              style: row.labelStyle ??
                  TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
            ),
          ),
        ),
        flutter_table.TableCell(
          child: Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            child: Text(
              row.value,
              style: row.valueStyle ??
                  TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: theme.textTheme.bodyMedium?.color,
                  ),
            ),
          ),
        ),
      ],
    );
  }

  // Convenience method for creating section headers
  static TableRow createSectionHeader(String title) {
    return TableRow(
      label: title,
      value: '',
      isHeader: true,
    );
  }

  // Convenience method for creating regular rows
  static TableRow createRow(String label, String value) {
    return TableRow(
      label: label,
      value: value,
    );
  }
}
