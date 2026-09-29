import 'package:flutter/material.dart';
import 'package:campusvault/admin/screens/upload_resource_screen.dart';
import 'package:campusvault/admin/widgets/admin_stat_card.dart';
import 'package:campusvault/admin/widgets/hierarchy_selector.dart';
import 'package:campusvault/data/admin_data.dart';
import 'package:campusvault/models/admin_user.dart';
import 'package:campusvault/models/resource.dart';
import 'package:campusvault/models/user_role.dart';
import 'package:campusvault/services/auth_service.dart';
import 'package:campusvault/utils/route_transitions.dart';

class AdminDashboardScreen extends StatefulWidget {
  final AdminUser admin;

  const AdminDashboardScreen({super.key, required this.admin});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  HierarchySelection _filter = const HierarchySelection();
  bool _showFilter = false;

  List<Resource> get _filteredResources {
    return mockResources.where((r) {
      if (_filter.university != null &&
          r.universityId != _filter.university!.id) { return false; }
      if (_filter.college != null &&
          r.collegeId != _filter.college!.id) { return false; }
      if (_filter.programType != null &&
          r.programType != _filter.programType!.name) { return false; }
      if (_filter.course != null &&
          r.courseId != _filter.course!.id) { return false; }
      if (_filter.year != null && r.yearId != _filter.year!.id) { return false; }
      if (_filter.subject != null &&
          r.subjectCode != _filter.subject!.code) { return false; }
      return true;
    }).toList();
  }

  Future<void> _signOut() async {
    await authService.signOut();
    if (!mounted) return;
    Navigator.of(context).pushNamedAndRemoveUntil('/', (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final admin = widget.admin;
    final resources = _filteredResources;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.primary,
                    theme.colorScheme.primary.withValues(alpha: 0.75),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.admin_panel_settings_rounded,
                color: Colors.white,
                size: 18,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              'Admin Panel',
              style: theme.appBarTheme.titleTextStyle,
            ),
          ],
        ),
        actions: [
          // Upload FAB in AppBar
          if (admin.role == UserRole.superAdmin ||
              admin.role == UserRole.moderator)
            IconButton(
              tooltip: 'Upload Resource',
              icon: const Icon(Icons.cloud_upload_rounded),
              onPressed: () => Navigator.of(context).push(
                slideRoute(UploadResourceScreen(admin: admin)),
              ),
            ),
          // Profile / sign-out menu
          PopupMenuButton<String>(
            icon: CircleAvatar(
              radius: 16,
              backgroundColor:
                  theme.colorScheme.primary.withValues(alpha: 0.12),
              child: Text(
                admin.username[0].toUpperCase(),
                style: TextStyle(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14)),
            itemBuilder: (_) => [
              PopupMenuItem(
                enabled: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      admin.username,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      admin.role.label,
                      style: TextStyle(
                        fontSize: 12,
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              PopupMenuItem(
                value: 'signout',
                child: const Row(
                  children: [
                    Icon(Icons.logout_rounded, size: 18),
                    SizedBox(width: 10),
                    Text('Sign Out'),
                  ],
                ),
              ),
            ],
            onSelected: (val) {
              if (val == 'signout') _signOut();
            },
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async =>
              await Future.delayed(const Duration(milliseconds: 500)),
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              // ── Welcome banner ────────────────────────────────────────
              _WelcomeBanner(admin: admin),
              const SizedBox(height: 24),

              // ── Stats row ─────────────────────────────────────────────
              _StatsRow(totalResources: mockResources.length),
              const SizedBox(height: 24),

              // ── Quick Action ──────────────────────────────────────────
              if (admin.role == UserRole.superAdmin ||
                  admin.role == UserRole.moderator) ...[
                _QuickUploadCard(
                  onTap: () => Navigator.of(context).push(
                    slideRoute(UploadResourceScreen(admin: admin)),
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // ── Filter toggle ─────────────────────────────────────────
              Row(
                children: [
                  Text(
                    'Resources',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const Spacer(),
                  TextButton.icon(
                    icon: Icon(
                      _showFilter
                          ? Icons.filter_alt_off_rounded
                          : Icons.filter_alt_rounded,
                      size: 18,
                    ),
                    label: Text(_showFilter ? 'Clear Filter' : 'Filter'),
                    onPressed: () {
                      setState(() {
                        _showFilter = !_showFilter;
                        if (!_showFilter) {
                          _filter = const HierarchySelection();
                        }
                      });
                    },
                  ),
                ],
              ),

              // Filter panel
              if (_showFilter) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest
                        .withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: theme.colorScheme.outlineVariant
                          .withValues(alpha: 0.4),
                    ),
                  ),
                  child: HierarchySelector(
                    onSelectionChanged: (s) =>
                        setState(() => _filter = s),
                  ),
                ),
              ],
              const SizedBox(height: 16),

              // ── Resource list ─────────────────────────────────────────
              if (resources.isEmpty)
                _EmptyResources(isFiltered: _showFilter)
              else
                ...resources.map((r) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _ResourceListTile(resource: r),
                    )),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Welcome banner ────────────────────────────────────────────────────────────
class _WelcomeBanner extends StatelessWidget {
  final AdminUser admin;
  const _WelcomeBanner({required this.admin});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.primary.withValues(alpha: 0.75),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withValues(alpha: 0.22),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome back,',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  admin.username,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    admin.role.label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                admin.username[0].toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Stats row ─────────────────────────────────────────────────────────────────
class _StatsRow extends StatelessWidget {
  final int totalResources;
  const _StatsRow({required this.totalResources});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AdminStatCard(
            icon: Icons.folder_rounded,
            value: '$totalResources',
            label: 'Resources',
            color: const Color(0xFF4F46E5),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: AdminStatCard(
            icon: Icons.account_balance_rounded,
            value: '1',
            label: 'Universities',
            color: const Color(0xFF0D9488),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: AdminStatCard(
            icon: Icons.school_rounded,
            value: '1',
            label: 'Colleges',
            color: const Color(0xFFD946EF),
          ),
        ),
      ],
    );
  }
}

// ── Quick upload card ─────────────────────────────────────────────────────────
class _QuickUploadCard extends StatelessWidget {
  final VoidCallback onTap;
  const _QuickUploadCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0xFF10B981).withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: const Color(0xFF10B981).withValues(alpha: 0.25),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFF10B981).withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.cloud_upload_rounded,
                  color: Color(0xFF10B981), size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Upload Resource',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Color(0xFF10B981),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Add PDF, image, or external link',
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.55),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14,
              color: Color(0xFF10B981),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Resource list tile ────────────────────────────────────────────────────────
class _ResourceListTile extends StatelessWidget {
  final Resource resource;
  const _ResourceListTile({required this.resource});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final type = resource.type;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.4),
        ),
      ),
      color: theme.colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            // Type icon
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: type.color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(type.icon, color: type.color, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    resource.title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 7, vertical: 2),
                        decoration: BoxDecoration(
                          color: type.color.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          type.label,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: type.color,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        resource.subjectCode,
                        style: TextStyle(
                          fontSize: 11,
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.5),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.more_vert_rounded,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.35),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Empty state ───────────────────────────────────────────────────────────────
class _EmptyResources extends StatelessWidget {
  final bool isFiltered;
  const _EmptyResources({required this.isFiltered});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        children: [
          Icon(
            isFiltered
                ? Icons.search_off_rounded
                : Icons.folder_open_rounded,
            size: 56,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
          ),
          const SizedBox(height: 16),
          Text(
            isFiltered ? 'No resources match the filter' : 'No resources yet',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }
}
