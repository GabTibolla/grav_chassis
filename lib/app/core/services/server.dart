import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_static/shelf_static.dart';
import 'package:flutter/services.dart' show rootBundle;

// Copia a fonte escolhida para o diretório de documentos do app
// Essa etapa é importante devido às permissoes de acesso do app ao celular
Future<void> copyFontsToDocumentsDirectory(String font) async {
  final directory = await getApplicationDocumentsDirectory();

  // Directory where the fonts will be saved
  final fontsDir = Directory('${directory.path}/fonts');
  if (!await fontsDir.exists()) {
    await fontsDir.create(recursive: true);
  }

  final fontPath = '${fontsDir.path}/$font.ttf';
  final byteData = await rootBundle.load('assets/fonts/$font.ttf');
  final buffer = byteData.buffer;
  await File(fontPath).writeAsBytes(buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
}

Future<void> main() async {
  final router = Router();

  // Rota para devolver a página criada
  router.get('/page', (Request request) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/index.html');

    if (await file.exists()) {
      final contents = await file.readAsString();
      return Response.ok(contents, headers: {
        HttpHeaders.contentTypeHeader: 'text/html',
      });
    } else {
      return Response.notFound('File not found');
    }
  });

  // Rota para renderizar o texto
  router.post('/render', (Request request) async {
    final payload = await request.readAsString();
    final data = jsonDecode(payload);
    final text = data['text'];
    final font = data['font'];

    // Copia a fonte escolhida para o diretório de documentos do app
    await copyFontsToDocumentsDirectory(font);

    // pega o diretorio de documentos do app
    final directory = await getApplicationDocumentsDirectory();

    // pega o caminho da fonte
    final fontPath = '/fonts/$font.ttf';

    // cria o html
    final htmlContent = '''
      <!DOCTYPE html>
      <html lang="en">
      <head>
          <meta charset="UTF-8">
          <meta name="viewport" content="width=device-width, initial-scale=1.0">
          <title>Rendered Text</title>
          <style>
              @font-face {
                  font-family: '$font';
                  src: url('$fontPath') format('truetype');
              }

              body {
                  margin: 0px;
                  font-size: 29px;
                  padding: 5px;
              }

              .vertical-text {
                  font-family: '$font';
                  writing-mode: vertical-rl;
                  transform: scale(-1, 1);
                  white-space: pre-wrap; /* Preserva espaços e quebras de linha */
                   letter-spacing: 2mm;
              }
          </style>
          <script>
              window.onload = function() {
                  window.print();
              }
          </script>
      </head>
      <body>
          <p class="vertical-text">$text</p>
      </body>
      </html>
      ''';

    try {
      // Obtém o diretório de documentos do aplicativo
      final file = File('${directory.path}/index.html');
      await file.writeAsString(htmlContent);
    } catch (ex) {
      return Response.internalServerError(body: ex.toString());
    }

    return Response.ok(htmlContent, headers: {'Content-Type': 'text/html'});
  });

  // Servir arquivos estáticos (incluindo index.html)
  final staticHandler = createStaticHandler(
    (await getApplicationDocumentsDirectory()).path,
    defaultDocument: 'index.html',
    serveFilesOutsidePath: true,
  );

  // Adiciona o handler de arquivos estáticos
  router.mount('/', staticHandler);

  // Inicia o servidor
  await shelf_io.serve(router.call, 'localhost', 8080);
  //print('Servidor rodando em http://${server.address.host}:${server.port}');
}
