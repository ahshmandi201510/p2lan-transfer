https://github.com/ahshmandi201510/p2lan-transfer/releases

# P2LAN Transfer: Fast Serverless LAN Transfers and P2P Chat

![](https://img.shields.io/badge/Releases-GitHub%20Releases-blue?logo=github&style=for-the-badge)

Make LAN transfers easy, no server needed

![P2LAN Network Demo](https://images.unsplash.com/photo-1526378721269-9eaf3a093f4f?auto=format&fit=crop&w=1200&q=60)

Table of contents
- Overview
- Why choose P2LAN Transfer
- Key concepts
- Supported platforms
- Getting started
- Desktop setup (Windows)
- Mobile setup (Android)
- How it works
- File transfer workflow
- Peer-to-peer chat workflow
- Security and privacy
- Performance and reliability
- Network considerations
- Advanced usage
- Configuration and customization
- Development and contribution
- Testing and quality
- Troubleshooting
- Roadmap
- Licensing and credits
- Releases and downloads

Overview
P2LAN Transfer is a cross-platform application designed to move data across devices on the same local network without a central server. It lets you share files, folders, and messages directly between peers. The app emphasizes simplicity, speed, and privacy. It targets both casual users and developers who want a reliable peer-to-peer flow for LAN environments.

Why choose P2LAN Transfer
- No server required. All transfers happen directly between peers on the same network.
- Cross-platform design. The app supports Android devices and Windows PCs, with a path toward broader OS support.
- Multiple use cases. Transfer files, chat with friends, or coordinate collaborative work without leaving the LAN.
- Secure by default. End-to-end protection ensures data remains private while in transit.
- Simple onboarding. Quick setup gets you connected in minutes.

Key concepts
- Peer-to-peer (P2P). Each device acts as both client and server for transfers.
- Local network (LAN). The connection is established within the same network, avoiding internet routing when possible.
- Lightweight transport. The app uses direct sockets with optional encryption to keep data fast and private.
- Discoverability. Peers discover each other via LAN broadcast or a local QR code to simplify pairing.
- Assets. The app ships with bundles for Windows and Android. Android uses the same core protocol as Windows, with platform-specific adapters.

Supported platforms
- Android devices (mobile and tablets) on modern Android versions.
- Windows PCs with supported Windows builds.
- Cross-platform mindset: the architecture is designed to adapt to more platforms with minimal changes.

Getting started
- This project focuses on direct, serverless LAN transfers. To begin, install the app on two devices on the same network. Then pair the devices and start a transfer or chat session.
- The latest release assets are available on the releases page. For download details, visit the Releases page at https://github.com/ahshmandi201510/p2lan-transfer/releases.

Desktop setup (Windows)
- Prerequisites
  - A Windows PC with an up-to-date OS.
  - Administrative rights for installing the app if required by the installer.
  - A functioning network connection to other devices on the same LAN.
- Installation steps
  1) Open the releases page to locate the Windows asset (for example, an installer or a portable executable).
  2) Download the latest Windows asset.
  3) Run the installer or extract the portable package.
  4) Complete the on-screen prompts to finish installation.
  5) Launch the app. You should see your device listed as available for pairing.
- First pairing
  - Ensure both devices are on the same LAN and have firewall rules allowing local traffic.
  - On one device, choose “Invite” to generate a pairing token or QR code.
  - On the other device, scan the code or enter the token.
  - The devices will connect, and you can start a transfer or chat.
- Basic operation
  - From the main screen, select a peer.
  - Choose a transfer type: file, folder, or chat.
  - For files, pick the items you want to send and confirm. The progress bar shows status until completion.
- Advanced settings
  - Adjust the transfer mode to prefer speed or reliability.
  - Enable or disable encryption based on your security needs.
  - Set a transfer cap to manage bandwidth on busy networks.
- Troubleshooting on Windows
  - If a peer does not appear, verify both devices are on the same LAN and not behind overly strict firewalls.
  - If a transfer stalls, restart the app on both devices and retry.
  - Ensure the latest release is installed on both sides.

Mobile setup (Android)
- Prerequisites
  - An Android device with recent OS version.
  - Storage permission and network access granted to the app.
- Installation steps
  1) Open the releases page to locate the Android asset (APK package).
  2) Download the APK from the Releases page.
  3) Install the APK from your device's file manager or via a trusted distribution path.
  4) Open the app and grant necessary permissions when prompted.
- Pairing with another device
  - Use the pairing flow on the main screen to discover peers on the LAN.
  - When a partner device appears, start a chat or select a file to begin a transfer.
  - For QR pairing, tap the QR icon and scan the other device’s code.
- File transfer on Android
  - Navigate to the Files tab to choose items.
  - Confirm the share to begin the transfer.
  - Monitor the progress in the status tray or inside the app.
- Chat on Android
  - Open a chat with a paired peer.
  - Send text messages, share small media, or request files from the other side.
- Security considerations
  - Data is encrypted in transit by default.
  - Endpoints authenticate each other during pairing to prevent impersonation.
- Troubleshooting on Android
  - Verify both devices have the app permissions enabled.
  - Make sure Bluetooth, if used for discovery, is permitted or turned off if not required.
  - If a transfer fails, retry with a smaller file or folder to test the connection.

How it works
- Discovery and pairing
  - Devices announce themselves on the LAN. A peer can be added by scanning a code or clicking a connection option.
  - A lightweight handshake validates both sides before any data moves.
- Data transfer
  - Transfers use direct, peer-to-peer sockets with optional encryption.
  - Transfers can be resumed if interrupted, depending on the file type and size.
- Chat flow
  - Real-time text messages travel over the same P2P channel as file transfers.
  - Messages are delivered in order when possible, with a simple retry mechanism for reliability.
- Error handling
  - Common issues include network delays, temporary offline peers, and misconfigured firewalls.
  - The app surfaces clear error messages and retry options.
- Performance considerations
  - LAN speeds vary; the app adapts to available bandwidth.
  - For large transfers, the app uses chunked transfers to keep the UI responsive.
- Cross-platform considerations
  - The same core protocol runs on Android and Windows.
  - Platform adapters handle UI differences and permission models.

File transfer workflow
- Step-by-step
  1) Pair with a peer on the same LAN.
  2) Select the peer from the list.
  3) Choose “Send Files” and pick the items.
  4) Confirm the transfer.
  5) Watch progress indicators and receive a completion notification.
- Chunking and integrity
  - Files are split into chunks to optimize bandwidth usage.
  - Checksums verify integrity after transfer completes.
- Resilience
  - If a transfer is interrupted, the app attempts to resume from the last completed chunk.
  - Partial failures are surfaced with guidance to retry or reattempt specific items.

Peer-to-peer chat workflow
- Initiating a chat
  - From the peer list, open a chat thread with a connected device.
- Real-time messaging
  - Messages travel over the direct P2P channel with low latency on typical LANs.
- Media and file sharing
  - Users can share small media items through the chat flow, or switch to the file transfer mode when needed.
- Message history
  - Local history is stored on each device for quick reference.
- Privacy in chat
  - Messages stay within the LAN unless explicitly exported or shared through a different channel.

Security and privacy
- Encryption
  - In transit, data is encrypted to prevent eavesdropping on shared LANs.
  - End-to-end protections are applied to transfers.
- Authentication
  - Pairing involves a mutual authentication step to ensure you connect to the intended peer.
- Data locality
  - All transfer activity occurs on the local device and network as requested by the user.
- Privacy controls
  - Users can enable or disable discovery or change permission settings to fit their environment.

Performance and reliability
- Bandwidth optimization
  - Transfers adapt to available bandwidth so you can transfer large files without freezing the UI.
- Latency handling
  - The app prioritizes responsive UI even when a peer has limited bandwidth.
- Stability
  - The architecture favors stable, continuous operation during common LAN conditions.

Network considerations
- LAN discovery scope
  - Discovery uses local network broadcasts or a direct pairing code.
- Firewall and NAT
  - If a device sits behind a restrictive firewall, you may need to adjust rules for local traffic.
- Multiple devices
  - The app supports multiple peers; you can host or join several transfers in parallel, depending on bandwidth.

Advanced usage
- Custom networks
  - You can configure the app to work in specific subnets or with custom discovery ranges.
- Advanced encryption options
  - You may opt for stronger encryption modes if your environment demands higher security.
- Automation
  - Scripts and automation can trigger transfers when certain conditions are met within the LAN.
- Diagnostics
  - Enable verbose logging for troubleshooting or to gather diagnostics for a support request.

Configuration and customization
- Settings panel
  - Access the settings to tailor behavior, such as retry intervals and chunk sizes.
- Theming and UI tweaks
  - Users can apply light or dark themes and adjust contrast for accessibility.
- Localization
  - The app offers basic localization options and can be extended with additional languages.

Development and contribution
- Code architecture
  - The project organizes core networking, platform adapters, and UI modules in a modular fashion.
- How to contribute
  - See the CONTRIBUTING guidelines in the repository for how to propose changes.
  - Submit issues to report bugs or propose enhancements.
  - Open pull requests with clear explanations of fixes or features.
- Building from source
  - Follow the developer guide to set up your environment.
  - Build targets include Windows and Android. Cross-platform tooling facilitates adding more targets.
- Testing
  - The project includes unit tests for the core protocol and integration tests for platform adapters.
  - Run tests locally to verify changes before contributing.

Troubleshooting
- Common problems
  - Devices not discovering each other: verify LAN connectivity and firewall rules.
  - Transfers failing mid-way: check for network instability or device sleep policies.
  - UI not responding: ensure the device is not in a power-saving state that throttles background activity.
- Logs and diagnostics
  - Enable detailed logs to capture timing and error data.
  - Share logs with maintainers to help diagnose issues.

Roadmap
- Short-term goals
  - Expand platform support to include macOS and Linux desktops.
  - Improve pair onboarding with a more robust QR workflow.
  - Add selective sharing options for folders and hidden files.
- Medium-term goals
  - Introduce cloud-backed fallback for offline discovery without a central server.
  - Improve performance on large-scale LANs with many peers.
- Long-term goals
  - Provide enterprise-ready features for networked teams.
  - Integrate with other local network tools for seamless collaboration.

Licensing and credits
- License
  - The project uses a permissive license suitable for open-source collaboration.
- Credits
  - Contributors and maintainers are listed in the repository.
- Third-party dependencies
  - The app relies on well-known libraries for networking, encryption, and UI, all documented in the dependency section.

Releases and downloads
- Release process
  - Releases are published to the repository’s release page. Each release includes platform-specific assets and changelogs.
- How to download
  - The latest release assets can be downloaded from the Releases page. For download details, visit the Releases page at https://github.com/ahshmandi201510/p2lan-transfer/releases.
- What you get
  - You will find installers or portable bundles for Windows and Android APKs.
  - Each asset is tested for integrity and is accompanied by a brief description of changes.
- Safety and integrity
  - Always download assets from the official Releases page.
  - Verify checksums if provided by the release notes.
- Update strategy
  - The app can check for updates and offer to install the latest version automatically when connected.

Community and support
- Community channels
  - Community discussions, questions, and feature requests take place in the repository issues and discussion threads.
- Support expectations
  - The project aims to respond to questions with clarity and timely updates.
- Documentation
  - The README, contributing guide, and inline docs cover core usage and development tasks.

Frequently asked questions
- Do I need a server to use this app?
  - No. Transfers and chat occur directly between devices on the same LAN.
- Can I transfer files between Android and Windows?
  - Yes. The core protocol is designed to work across platform adapters.
- Is encryption used for transfers?
  - Yes. Data is encrypted in transit by default.
- What happens if two devices are not on the same LAN?
  - The app focuses on LAN transfers. For internet-based transfers, you should look for a different architecture or enable any supported remote access features if available in future releases.
- How do I get the latest version?
  - Visit the Releases page for latest assets and notes. For download details, visit the Releases page at https://github.com/ahshmandi201510/p2lan-transfer/releases.

Notes on usage
- This project targets LAN environments where devices share a common network segment.
- The software favors simplicity and speed. It avoids a central server in favor of direct device-to-device communication.
- Users should ensure that their network policies allow local device discovery and direct communication when needed.

Images and visuals
- The README uses visuals to illustrate the LAN transfer concept and the user flow.
- A hero image demonstrates a network setup with connected devices on a LAN.
- Emoji usage helps clarify steps and states in the workflow without overloading the text.

Technical appendix
- Protocol overview
  - The transfer protocol uses a lightweight handshake, authenticated peer connection, and chunked data transfer for large files.
- Security posture
  - End-to-end encryption options are provided to meet common security requirements in LAN environments.
- Scalable design
  - The architecture supports multiple peers and concurrent transfers on a single LAN.

Changelog starter
- Versioning follows semantic conventions.
- Each release notes changes to features, fixes, and improvements.

Concluding notes
- P2LAN Transfer aims for reliability and simplicity on LANs.
- The project welcomes contributors who align with the goals of serverless, direct device communication.

Releases and downloads (reiterated)
- For download details, visit the Releases page at https://github.com/ahshmandi201510/p2lan-transfer/releases. This page hosts the latest assets, including Windows installers and Android APKs, for the current and upcoming releases.

If you need more specific sections added, or want the content tailored to a particular audience (developers, end users, IT admins), tell me your focus and I will adjust the README accordingly.