# Lara_app
App em flutter que faz consultas em chat de IA
🤖 LARA - IA Chat App (POC)
Uma Prova de Conceito (POC) desenvolvida em Flutter que implementa uma assistente virtual focada em conversas bem-humoradas, chamada LARA. O aplicativo permite autenticação de usuários, histórico local de conversas e chat em tempo real com uma IA real, utilizando os princípios da Clean Architecture.

✨ Funcionalidades
Autenticação: Login com E-mail/Senha e autenticação via Google.

Dashboard: Gerenciamento de conversas recentes (histórico com preview da última mensagem e data/hora) e criação de novas conversas.

Chat Inteligente: Comunicação em tempo real com a LARA (IA não-mockada), com respostas em formato de streaming (progressivo).

Persistência Local: Todo o histórico de mensagens e sessões é salvo localmente, permitindo retomar conversas passadas sem necessidade de um backend.

Personalidade da LARA: Respostas otimizadas via System Prompt para garantir um tom leve, divertido e focado em piadas.

Instruções para rodar o app:
Quando abrir o codigo rode o comando abaixo no terminal:
 dart pub global activate flutterfire_cli

* Para isso você precisa ter o flutter instalado e alocar a pasta do flutter/bin no path do sistema nas variaveis de ambiente.

Depois rode também o comando abaixo no terminal:
 npm install -g firebase-tools

* Para isso você precisa ter o nodejs instalado e alocar a pasta para utilizar o npm no path do sistema nas variaveis de ambiente. Algo parecido com C:\Users\Administrador\AppData\Roaming\npm

Depois rode o comando abaixo no terminal para fazer o login com sua conta de preferencia google:
 firebase login

Agora deve alocar a pasta do firebase no path do sistema nas variaveis de ambiente. para algo parecido com C:\Users\Administrador\AppData\Local\Pub\Cache\bin no path das variaveis de ambiente.

Depois rode o comando abaixo no terminal para configurar o firebase com o projeto:
 flutterfire configure
Aceite os termos e condições do firebase pelo terminal mesmo.
