// Automatic FlutterFlow imports
// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:mosaico_fotos/custom/actions/open_camera.dart';
import 'package:mosaico_fotos/pages/preview_page.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:screenshot/screenshot.dart';

class ScreenshotWidget extends StatefulWidget {
  const ScreenshotWidget({
    super.key,
    this.width,
    this.height,
    required this.mosaico,
  });

  final double? width;
  final double? height;
  final List<File> mosaico;

  @override
  State<ScreenshotWidget> createState() => _ScreenshotWidgetState();
}

class _ScreenshotWidgetState extends State<ScreenshotWidget> {
  final ScreenshotController screenshotController = ScreenshotController();

  Future<String> captureMosaic() async {
    try {
      final Uint8List? imageBytes = await screenshotController.capture();

      if (imageBytes != null) {
        final directory = await getApplicationDocumentsDirectory();
        final imagePath = '${directory.path}/mosaico.png';
        final imageFile = File(imagePath);
        await imageFile.writeAsBytes(imageBytes);

        print('✅ Screenshot salva em: $imagePath');
        // Cria o documento PDF
        final pdf = pw.Document();
        print("PDF document criado");

        // Adiciona a página com a imagem
        pdf.addPage(
          pw.Page(
            pageFormat: PdfPageFormat.a4,
            margin: pw.EdgeInsets.all(20),
            build: (pw.Context context) {
              return pw.Center(
                child: pw.Image(
                  pw.MemoryImage(imageBytes),
                  fit: pw.BoxFit.contain,
                ),
              );
            },
          ),
        );
        print("Página adicionada ao PDF");

        // Obtém o diretório para salvar o arquivo
        final Directory appDocDir = await getApplicationDocumentsDirectory();
        final String timestamp = DateTime.now().millisecondsSinceEpoch
            .toString();
        final String fileName = 'mosaico_$timestamp.pdf';
        final String filePath = '${appDocDir.path}/$fileName';

        print("Caminho do arquivo: $filePath");

        // Salva o arquivo PDF
        final File file = File(filePath);
        final pdfBytes = await pdf.save();
        await file.writeAsBytes(pdfBytes);

        print("PDF salvo com sucesso!");
        print("Tamanho do PDF: ${pdfBytes.length} bytes");

        // Verifica se o arquivo foi realmente criado
        if (await file.exists()) {
          final fileSize = await file.length();
          return "✅ PDF salvo com sucesso!\n📁 Arquivo: $fileName\n📊 Tamanho: $fileSize bytes\n📂 Local: Documentos do app";
        } else {
          return "❌ Erro: Arquivo não foi criado";
        }
      } else {
        print('❌ Erro: captura retornou null.');
        return "❌ Erro: captura retornou null.";
      }
    } catch (e) {
      print('❌ Erro ao capturar: $e');
      return "❌ Erro ao capturar screenshot: ${e.toString()}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Screenshot(
              controller: screenshotController,
              child: Container(
                padding: const EdgeInsets.all(8),
                child: (widget.mosaico.isEmpty)
                    ? const Center(
                        child: Text(
                          'Nenhuma foto adicionada',
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    : Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: widget.mosaico.map((img) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              img,
                              width: MediaQuery.of(context).size.width / 2 - 16,
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                          );
                        }).toList(),
                      ),
              ),
            ),
          ),
        ),
        Row(
          spacing: 16,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                File? file;
                bool aceito = false;
                do {
                  file = await openCamera(context);
                  if (file == null) break;
                  // Navega para a página de preview e espera resposta
                  aceito =
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PreviewPage(imageFile: file!),
                        ),
                      ) ??
                      false;
                  if (aceito) {
                    setState(() {
                      widget.mosaico.add(file!);
                    });
                    print(
                      '!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!',
                    );
                    print('Lista de imagens: $widget.mosaico');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Foto adicionada com sucesso!')),
                    );
                  }
                } while (!aceito);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF4B39EF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Tire Foto',
                style: TextStyle(color: Colors.white),
              ),
            ),
            ElevatedButton(
              onPressed: (widget.mosaico.isEmpty)
                  ? null
                  : () {
                      //Tira um print da tela e salva como PDF
                      // saveMosaicToPDF().then((result) {
                      //   ScaffoldMessenger.of(
                      //     context,
                      //   ).showSnackBar(SnackBar(content: Text(result)));
                      // });

                      captureMosaic().then((result) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text(result)));
                      });
                    },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Color(0xFF4B39EF)),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Salvar em PDF',
                style: TextStyle(color: Color(0xFF4B39EF)),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
