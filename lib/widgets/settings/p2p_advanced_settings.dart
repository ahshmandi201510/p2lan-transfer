import 'package:flutter/material.dart';
import 'package:p2lantransfer/l10n/app_localizations.dart';
import 'package:p2lantransfer/models/settings_models.dart';
import 'package:p2lantransfer/models/p2p_models.dart';
import 'package:p2lantransfer/services/settings_models_service.dart';
import 'package:p2lantransfer/widgets/generic/option_slider.dart';

class P2PAdvancedSettings extends StatefulWidget {
  const P2PAdvancedSettings({super.key});

  @override
  State<P2PAdvancedSettings> createState() => _P2PAdvancedSettingsState();
}

class _P2PAdvancedSettingsState extends State<P2PAdvancedSettings> {
  late AppLocalizations loc;
  P2PTransferSettingsData? _settings;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      final settings = await ExtensibleSettingsService.getP2PTransferSettings();
      if (mounted) {
        setState(() {
          _settings = settings;
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _settings = P2PTransferSettingsData();
          _loading = false;
        });
      }
    }
  }

  Future<void> _saveSettings() async {
    if (_settings != null) {
      await ExtensibleSettingsService.updateP2PTransferSettings(_settings!);
    }
  }

  @override
  Widget build(BuildContext context) {
    loc = AppLocalizations.of(context)!;

    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_settings == null) {
      return Center(child: Text(loc.failedToLoadSettings('null')));
    }

    return SingleChildScrollView(
      // padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Security & Encryption
          _buildSectionHeader(loc.securityAndEncryption, Icons.security),
          const SizedBox(height: 16),

          Card(
            child: Column(
              children: [
                RadioListTile<EncryptionType>(
                  title: Text(loc.none),
                  subtitle: Text(loc.p2lanOptionEncryptionNoneDesc),
                  value: EncryptionType.none,
                  groupValue: _settings!.encryptionType,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _settings = _settings!.copyWith(encryptionType: value);
                      });
                      _saveSettings();
                    }
                  },
                ),
                RadioListTile<EncryptionType>(
                  title: const Text('AES-GCM'),
                  subtitle: Text(loc.p2lanOptionEncryptionAesGcmDesc),
                  value: EncryptionType.aesGcm,
                  groupValue: _settings!.encryptionType,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _settings = _settings!.copyWith(encryptionType: value);
                      });
                      _saveSettings();
                    }
                  },
                ),
                RadioListTile<EncryptionType>(
                  title: const Text('ChaCha20-Poly1305'),
                  subtitle: Text(loc.p2lanOptionEncryptionChaCha20Desc),
                  value: EncryptionType.chaCha20,
                  groupValue: _settings!.encryptionType,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _settings = _settings!.copyWith(encryptionType: value);
                      });
                      _saveSettings();
                    }
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Data Compression
          _buildSectionHeader(loc.dataCompression, Icons.compress),
          const SizedBox(height: 16),

          Card(
            child: Column(
              children: [
                SwitchListTile.adaptive(
                  title: Text('${loc.enableCompression} [BETA]'),
                  subtitle: Text(loc.enableCompressionDesc),
                  value: _settings!.enableCompression,
                  onChanged: (value) {
                    setState(() {
                      _settings = _settings!.copyWith(enableCompression: value);
                    });
                    _saveSettings();
                  },
                  secondary: const Icon(Icons.compress),
                ),
                if (_settings!.enableCompression) ...[
                  const Divider(height: 1),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        // Compression Algorithm
                        Row(
                          children: [
                            Icon(Icons.settings,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    loc.compressionAlgorithm,
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                  const SizedBox(height: 8),
                                  DropdownButtonFormField<String>(
                                    value: _settings!.compressionAlgorithm,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                    ),
                                    items: [
                                      DropdownMenuItem(
                                          value: 'auto',
                                          child: Text(
                                              loc.compressionAlgorithmAuto)),
                                      DropdownMenuItem(
                                          value: 'gzip',
                                          child: Text(
                                              loc.compressionAlgorithmGZIP)),
                                      DropdownMenuItem(
                                          value: 'deflate',
                                          child: Text(
                                              loc.compressionAlgorithmDEFLATE)),
                                      DropdownMenuItem(
                                          value: 'none',
                                          child: Text(
                                              loc.compressionAlgorithmNone)),
                                    ],
                                    onChanged: (value) {
                                      if (value != null) {
                                        setState(() {
                                          _settings = _settings!.copyWith(
                                              compressionAlgorithm: value);
                                        });
                                        _saveSettings();
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Compression Threshold
                        OptionSlider<double>(
                          icon: Icons.tune,
                          label: loc.compressionThreshold,
                          subtitle: loc.compressionThresholdDesc,
                          options: _getCompressionThresholdOptions(),
                          currentValue: _settings!.compressionThreshold,
                          onChanged: (value) {
                            setState(() {
                              _settings = _settings!
                                  .copyWith(compressionThreshold: value);
                            });
                            _saveSettings();
                          },
                          layout: OptionSliderLayout.none,
                          fixedWidth: 150,
                        ),

                        // Adaptive Compression
                        SwitchListTile.adaptive(
                          title: Text(loc.adaptiveCompression),
                          subtitle: Text(loc.adaptiveCompressionDesc),
                          value: _settings!.adaptiveCompression,
                          onChanged: (value) {
                            setState(() {
                              _settings = _settings!
                                  .copyWith(adaptiveCompression: value);
                            });
                            _saveSettings();
                          },
                          secondary: const Icon(Icons.auto_fix_high),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Performance Information
          _buildSectionHeader(loc.performanceInfo, Icons.info),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildInfoRow(
                      loc.performanceInfoEncrypt, _getEncryptionDisplayText()),
                  _buildInfoRow(loc.performanceInfoCompress,
                      _getCompressionDisplayText()),
                  _buildInfoRow(loc.performanceInfoExpectedImprovement,
                      _getExpectedImprovement()),
                  _buildInfoRow(
                      loc.performanceInfoSecuLevel, _getSecurityLevel()),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Compression Benefits Card
          if (_settings!.enableCompression)
            Card(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info,
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer),
                        const SizedBox(width: 8),
                        Text(
                          loc.compressionBenefits,
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimaryContainer,
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      loc.compressionBenefitsInfo,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer,
                          ),
                    ),
                  ],
                ),
              ),
            ),

          const SizedBox(height: 16),

          // Performance Warning Card
          if (_settings!.enableCompression ||
              _settings!.encryptionType != EncryptionType.none)
            Card(
              color: Theme.of(context).colorScheme.errorContainer,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.warning,
                            color:
                                Theme.of(context).colorScheme.onErrorContainer),
                        const SizedBox(width: 8),
                        Text(
                          loc.performanceWarning,
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onErrorContainer,
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      loc.performanceWarningInfo,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color:
                                Theme.of(context).colorScheme.onErrorContainer,
                          ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          setState(() {
                            _settings = _settings!.copyWith(
                              encryptionType: EncryptionType.none,
                              enableCompression: false,
                              compressionAlgorithm: 'none',
                              adaptiveCompression: false,
                            );
                          });
                          await _saveSettings();
                        },
                        icon: Icon(Icons.security_update_good,
                            color:
                                Theme.of(context).colorScheme.onErrorContainer),
                        label: Text(
                          loc.resetToSafeDefaults,
                          style: TextStyle(
                            color:
                                Theme.of(context).colorScheme.onErrorContainer,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color:
                                Theme.of(context).colorScheme.onErrorContainer,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 24, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 12),
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
          ),
        ],
      ),
    );
  }

  List<SliderOption<double>> _getCompressionThresholdOptions() {
    return [
      SliderOption(value: 1.05, label: '5% (${loc.aggressive})'),
      SliderOption(value: 1.1, label: '10% (${loc.ddefault})'),
      SliderOption(value: 1.15, label: '15% (${loc.conservative})'),
      SliderOption(value: 1.2, label: '20% (${loc.veryConservative})'),
      SliderOption(value: 1.5, label: '50% (${loc.onlyMajorGains})'),
    ];
  }

  String _getEncryptionDisplayText() {
    switch (_settings!.encryptionType) {
      case EncryptionType.none:
        return loc.fastest;
      case EncryptionType.aesGcm:
        return loc.strongest;
      case EncryptionType.chaCha20:
        return loc.mobileOptimized;
    }
  }

  String _getCompressionDisplayText() {
    if (!_settings!.enableCompression) return loc.disabled;
    if (_settings!.adaptiveCompression) {
      return '${_settings!.compressionAlgorithm.toUpperCase()} (${loc.adaptive})';
    }
    return _settings!.compressionAlgorithm.toUpperCase();
  }

  String _getExpectedImprovement() {
    String improvement = '';

    // Compression improvement
    if (_settings!.enableCompression) {
      switch (_settings!.compressionAlgorithm) {
        case 'gzip':
          improvement += loc.upToNumberXFaster(5);
          break;
        case 'deflate':
          improvement += loc.upToNumberXFaster(3);
          break;
        case 'auto':
          improvement += loc.upToNumberXFaster(6);
          break;
        default:
          improvement += '1x (${loc.baseline})';
      }
    } else {
      improvement = '1x (${loc.baseline})';
    }

    return improvement;
  }

  String _getSecurityLevel() {
    if (_settings!.encryptionType == EncryptionType.none) {
      return '${loc.none} (${loc.notRecommended})';
    } else {
      return '${loc.high} (${loc.encrypted})';
    }
  }
}
