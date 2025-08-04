import 'package:flutter/material.dart';
import 'package:p2lantransfer/l10n/app_localizations.dart';
import 'package:p2lantransfer/models/p2p_models.dart';

class PairingRequestDialog extends StatefulWidget {
  final List<PairingRequest> requests;
  final Function(
          String requestId, bool accept, bool trustUser, bool saveConnection)
      onRespond;

  const PairingRequestDialog({
    super.key,
    required this.requests,
    required this.onRespond,
  });

  @override
  State<PairingRequestDialog> createState() => _PairingRequestDialogState();
}

class _PairingRequestDialogState extends State<PairingRequestDialog> {
  int _currentIndex = 0;
  bool _trustUser = false;
  bool _saveConnection = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (widget.requests.isEmpty) {
      return AlertDialog(
        title: Text(l10n.pairingRequests),
        content: Text(l10n.noPairingRequests),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.close),
          ),
        ],
      );
    }

    final request = widget.requests[_currentIndex];

    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.notifications,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).primaryColor),
          const SizedBox(width: 8),
          Expanded(child: Text(l10n.pairingRequests)),
          if (widget.requests.length > 1)
            Text(
              '${_currentIndex + 1}/${widget.requests.length}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.pairingRequestFrom,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),

            // Request info card
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .surfaceContainerHighest
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Theme.of(context)
                      .colorScheme
                      .outline
                      .withValues(alpha: 0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor:
                            Theme.of(context).brightness == Brightness.dark
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).primaryColor,
                        child: const Icon(
                          Icons.person,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              request.fromUserName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              '${request.fromIpAddress}:${request.fromPort}',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildInfoRow(
                    icon: Icons.fingerprint,
                    label: l10n.deviceId,
                    value: request.fromDeviceId.length > 20
                        ? '${request.fromDeviceId.substring(0, 20)}...'
                        : request.fromDeviceId,
                  ),
                  const SizedBox(height: 8),
                  _buildInfoRow(
                    icon: Icons.access_time,
                    label: l10n.sentTime,
                    value: _formatTime(request.requestTime),
                  ),
                  // Note: Removed "wants to save connection" display since
                  // connection saving is now handled per-device independently
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Trust user option
            CheckboxListTile(
              value: _trustUser,
              onChanged: (value) {
                setState(() {
                  _trustUser = value ?? false;
                });
              },
              title: Text(l10n.trustThisUser),
              subtitle: Text(
                l10n.allowFileTransfersWithoutConfirmation,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
            ),

            // Save connection option
            CheckboxListTile(
              value: _saveConnection,
              onChanged: (value) {
                setState(() {
                  _saveConnection = value ?? false;
                });
              },
              title: Text(l10n.saveConnection),
              subtitle: Text(
                l10n.autoReconnectDescription,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
            ),

            const SizedBox(height: 12),

            // Info box
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning, color: Colors.orange, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      l10n.onlyAcceptFromTrustedDevices,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.orange[700],
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        // Navigation buttons for multiple requests
        if (widget.requests.length > 1) ...[
          IconButton(
            onPressed: _currentIndex > 0 ? _previousRequest : null,
            icon: const Icon(Icons.arrow_back),
            tooltip: l10n.previousRequest,
          ),
          IconButton(
            onPressed: _currentIndex < widget.requests.length - 1
                ? _nextRequest
                : null,
            icon: const Icon(Icons.arrow_forward),
            tooltip: l10n.nextRequest,
          ),
          const Spacer(),
        ],

        // Action buttons
        TextButton(
          onPressed: () => _respondToRequest(false),
          child: Text(l10n.reject),
        ),
        ElevatedButton(
          onPressed: () => _respondToRequest(true),
          child: Text(l10n.accept),
        ),
      ],
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 13,
            color: Colors.grey[700],
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 13),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  String _formatTime(DateTime time) {
    final l10n = AppLocalizations.of(context)!;
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 1) {
      return l10n.justNow;
    } else if (difference.inMinutes < 60) {
      return l10n.minutesAgo(difference.inMinutes);
    } else if (difference.inHours < 24) {
      return l10n.hoursAgo(difference.inHours);
    } else {
      return l10n.daysAgo(difference.inDays);
    }
  }

  void _previousRequest() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
        _resetOptions();
      });
    }
  }

  void _nextRequest() {
    if (_currentIndex < widget.requests.length - 1) {
      setState(() {
        _currentIndex++;
        _resetOptions();
      });
    }
  }

  void _resetOptions() {
    _trustUser = false;
    _saveConnection = false;
  }

  void _respondToRequest(bool accept) {
    final request = widget.requests[_currentIndex];
    Navigator.of(context).pop();
    widget.onRespond(request.id, accept, _trustUser, _saveConnection);
  }
}
