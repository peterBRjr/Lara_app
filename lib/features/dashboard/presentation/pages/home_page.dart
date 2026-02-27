import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lara_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:lara_app/features/chat_IA/chat_page.dart';
import 'package:lara_app/injection_container.dart';
import 'package:lara_app/features/chat_IA/data/datasources/chat_local_data_source.dart';
import 'package:lara_app/features/chat_IA/data/models/chat_conversation.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ChatLocalDataSource _localDb = sl<ChatLocalDataSource>();
  List<ChatConversation> _conversations = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadConversations();
    });
  }

  String get _currentUserId {
    final state = context.read<AuthBloc>().state;
    if (state is Authenticated) {
      return state.user.id;
    }
    return 'unknown_user';
  }

  void _loadConversations() {
    setState(() {
      _conversations = _localDb.getConversations(_currentUserId);
    });
  }

  void _openChat([String? conversationId]) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            ChatPage(conversationId: conversationId, userId: _currentUserId),
      ),
    );
    // Reload local chats when returning to Dashboard
    _loadConversations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'LARA',
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthBloc>().add(SignOutEvent());
              Navigator.of(
                context,
              ).pushNamedAndRemoveUntil('/', (route) => false);
            },
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: _conversations.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.forum_rounded,
                        size: 80,
                        color: Colors.white70,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Nenhuma conversa ainda.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF6A11CB),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          elevation: 4,
                        ),
                        onPressed: () => _openChat(),
                        icon: const Icon(Icons.add),
                        label: const Text(
                          'Nova Conversa',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _conversations.length,
                  itemBuilder: (context, index) {
                    final convo = _conversations[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      elevation: 4,
                      color: Colors.white,
                      surfaceTintColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        leading: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF6A11CB).withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.chat_bubble_outline,
                            color: Color(0xFF6A11CB),
                          ),
                        ),
                        title: Text(
                          convo.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(
                            'Última conversa: ${convo.updatedAt.day.toString().padLeft(2, '0')}/${convo.updatedAt.month.toString().padLeft(2, '0')} às ${convo.updatedAt.hour.toString().padLeft(2, '0')}:${convo.updatedAt.minute.toString().padLeft(2, '0')}',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ),
                        trailing: Icon(
                          Icons.chevron_right,
                          color: Colors.grey.shade400,
                        ),
                        onTap: () => _openChat(convo.id),
                      ),
                    );
                  },
                ),
        ),
      ),
      floatingActionButton: _conversations.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: () => _openChat(),
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF6A11CB),
              elevation: 4,
              icon: const Icon(Icons.add),
              label: const Text(
                'Nova Conversa',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            )
          : null,
    );
  }
}
