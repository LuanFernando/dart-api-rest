A sample command-line application with an entrypoint in `bin/`, library code
in `lib/`, and example unit test in `test/`.

# Subir o server

dart run bin/server.dart

# Url

http://localhost:8888/api

# Rotas

As rotas devem ser cadastradas no service_route

# A lista de usuário está em lib/users.json

# Criação de API Key Google AI Studio

https://aistudio.google.com/app/apikey

# Exemplo de prompt:

http://localhost:8888/api/ai/chat

{
"prompt" : "Qual o resultado da expressão: 100-32/2+1990"
}

http://localhost:8888/api/ai/chat

{
"prompt" : "Qual a linguagem de programação mais popular no brasil ?"
}
