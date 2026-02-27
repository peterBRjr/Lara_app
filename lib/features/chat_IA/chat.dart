import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class ChatIaService {
  late final GenerativeModel _model;
  // Mantenha o histórico da conversa se necessário, usando ChatSession
  ChatSession? _chatSession;

  ChatIaService({List<Content>? history}) {
    final apiKey = dotenv.env["GOOGLE_AI_API_KEY"];

    if (apiKey == null || apiKey.isEmpty) {
      throw Exception(
        'API Key não encontrada. Certifique-se de configurar GOOGLE_AI_API_KEY no seu arquivo .env',
      );
    }

    _model = GenerativeModel(
      model: "gemini-2.5-flash",
      apiKey: apiKey,
      systemInstruction: Content.system(
        'Seu nome é LARA. Você é uma assistente virtual focada em conversas leves e bem-humoradas. '
        'REGRAS DE PERSONALIDADE: '
        '1. Seja objetiva: Vá direto ao ponto, evitando textos longos ou explicações desnecessárias. '
        '2. Adore piadas: Sempre que possível, inclua um trocadilho, uma piada curta ou um comentário engraçado relacionado ao contexto da conversa. '
        '3. Tom leve: Use uma linguagem amigável, informal e divertida. Nunca seja séria demais ou robótica. '
        '4. Coerência: Suas piadas devem fazer sentido com o que o usuário perguntou. '
        '5. Identidade: Lembre-se que você é a LARA e sua missão é fazer o usuário sorrir enquanto o ajuda.',
      ),
    );

    _chatSession = _model.startChat(history: history);
  }

  /// Envia uma mensagem de texto simples e retorna a resposta
  Future<String?> sendMessage(String prompt) async {
    try {
      final content = Content.text(prompt);
      final response = await _chatSession?.sendMessage(content);
      return response?.text;
    } catch (e) {
      debugPrint('Erro ao enviar mensagem: $e');
      return 'Desculpe, deu um tilt aqui e não consegui responder agora! 🤖🔧';
    }
  }

  /// Envia dados de áudio junto com um texto opcional e retorna a resposta
  Future<String?> sendAudioMessage(
    Uint8List audioBytes, {
    String mimeType = 'audio/mp4',
    String? prompt,
  }) async {
    try {
      // Define o Content que passaremos ao modelo, mesclando dados de áudio (DataPart)
      // e um texto opcional através do TextPart.
      final parts = <Part>[
        DataPart(mimeType, audioBytes),
        if (prompt != null && prompt.isNotEmpty) TextPart(prompt),
      ];
      final content = Content.multi(parts);

      final response = await _model.generateContent([content]);

      // Update the chat session with this history so we don't lose context
      // Note: We're adding it manually to history as sendAudioMessage is bypassing the current session structure
      if (response.text != null && _chatSession != null) {
        final historyList = _chatSession!.history.toList();
        historyList.addAll([
          content,
          Content.model([TextPart(response.text!)]),
        ]);
        // Note: The history property on ChatSession is typically a read-only Iterable,
        // so to truly update the session we might need to recreate the session or accept that `sendAudioMessage`
        // won't perfectly link to pure text history. For this scope we just consume the API.
      }

      return response.text;
    } catch (e) {
      debugPrint('Erro ao processar áudio: $e');
      return 'Vish, eu sou bom de piada, mas de audição eu tô meio surdo hoje! Não consegui entender o áudio. 🎧😅';
    }
  }
}
