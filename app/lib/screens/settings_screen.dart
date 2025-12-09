import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: const Color(0xFF000000),
      navigationBar: const CupertinoNavigationBar(
        backgroundColor: Color(0xFF1C1C1E),
        border: null,
        middle: Text(
          'Settings',
          style: TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 24),
          children: [
            _buildSection(
              title: 'GAME',
              children: [
                _buildSettingTile(
                  icon: CupertinoIcons.game_controller,
                  title: 'Difficulty',
                  value: 'Random AI',
                  onTap: () {},
                ),
                _buildSettingTile(
                  icon: CupertinoIcons.time,
                  title: 'Time Control',
                  value: 'None',
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: 32),
            _buildSection(
              title: 'APPEARANCE',
              children: [
                _buildSettingTile(
                  icon: CupertinoIcons.square_grid_2x2,
                  title: 'Board Style',
                  value: 'Classic',
                  onTap: () {},
                ),
                _buildSettingTile(
                  icon: CupertinoIcons.textformat,
                  title: 'Piece Set',
                  value: 'Default',
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: 32),
            _buildSection(
              title: 'ABOUT',
              children: [
                _buildSettingTile(
                  icon: CupertinoIcons.info_circle,
                  title: 'Version',
                  value: '1.0.0',
                  onTap: () {},
                ),
                _buildSettingTile(
                  icon: CupertinoIcons.heart_fill,
                  title: 'Rate App',
                  value: '',
                  onTap: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
              letterSpacing: 0.5,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: const Color(0xFF1C1C1E),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(
              icon,
              size: 24,
              color: const Color(0xFF81b64c),
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.w400,
              ),
            ),
            const Spacer(),
            if (value.isNotEmpty)
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[500],
                  fontWeight: FontWeight.w400,
                ),
              ),
            const SizedBox(width: 8),
            Icon(
              CupertinoIcons.chevron_right,
              size: 18,
              color: Colors.grey[600],
            ),
          ],
        ),
      ),
    );
  }
}
