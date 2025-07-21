import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:swasthya_doot/widgets/common_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';

class MyDetectScreen extends StatefulWidget {
  const MyDetectScreen({super.key});

  @override
  State<MyDetectScreen> createState() => _MyDetectScreenState();
}

class _MyDetectScreenState extends State<MyDetectScreen> {
  File? _selectedImage;

  String? _pillName;
  String? _dosage;
  String? _usedFor;
  String? _expiry;

  List<Map<String, String>> _medicineData = [];

  @override
  void initState() {
    super.initState();
    _loadMedicineList();
  }

  Future<void> _loadMedicineList() async {
    final rawData = await rootBundle.loadString("assets/asha_anm_medicines_with_usage_hi.csv");
    final List<List<dynamic>> csvTable = const CsvToListConverter().convert(rawData, eol: '\n');
    final List<Map<String, String>> data = csvTable.skip(1).map((row) {
      return {
        "name": row[0].toString(),
        "used_for": row[1].toString(),
      };
    }).toList();
    setState(() {
      _medicineData = data;
    });
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      final image = File(pickedFile.path);
      setState(() {
        _selectedImage = image;
      });
      await _processImageWithOCR(image); // Run OCR
    }
  }
  Future<void> _openCamera() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      final image = File(pickedFile.path);
      setState(() {
        _selectedImage = image;
      });
      await _processImageWithOCR(image); // Run OCR
    }
  }

  Future<void> _processImageWithOCR(File imageFile) async {
    final inputImage = InputImage.fromFile(imageFile);
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

    final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);

    String ocrText = recognizedText.text;
    debugPrint('🧠 OCR Output: $ocrText');

    textRecognizer.close();

    _extractFieldsFromOCR(ocrText);
  }

  void _extractFieldsFromOCR(String text) {
    final lines = text.split('\n');

    String? pillName;
    String? dosage;
    String? usedFor;
    String? expiry;

    for (var line in lines) {
      final lower = line.toLowerCase();

      for (final entry in _medicineData) {
        if (lower.contains(entry['name']!.toLowerCase())) {
          pillName = entry['name'];
          usedFor = entry['used_for'];
          break;
        }
      }

      final doseMatch = RegExp(r'\b\d+\s?(mg|ml|mcg)\b', caseSensitive: false).firstMatch(line);
      if (doseMatch != null) {
        dosage = doseMatch.group(0);
      }

      if (expiry == null) {
        final expKeywords = ['exp', 'expiry', 'expires', 'exp. date', 'exp date'];
        final lineHasKeyword = expKeywords.any((kw) => lower.contains(kw));

        if (lineHasKeyword) {
          final expiryDatePatterns = [
            RegExp(r'(0[1-9]|1[0-2])[/-](\d{2,4})'),
            RegExp(r'(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)[a-z]*[-/ ]?\d{2,4}', caseSensitive: false),
            RegExp(r'\d{2}[/-]\d{2,4}'),
          ];

          for (final pattern in expiryDatePatterns) {
            final match = pattern.firstMatch(line);
            if (match != null) {
              expiry = match.group(0);
              break;
            }
          }
        }
      }
    }

    setState(() {
      _pillName = pillName ?? "Unknown";
      _dosage = dosage ?? "Unknown";
      _usedFor = usedFor ?? "उपलब्ध नहीं";
      _expiry = expiry ?? "Not found";
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Padding(
          padding: EdgeInsets.only(
            left: size.width * 0.02,
            right: size.width * 0.02,
            top: size.height * 0.02,
            bottom: MediaQuery.of(context).padding.bottom + 80,
          ),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Gap(size.height * 0.04),
                Text(
                  'Pill Detection',
                  style: TextStyle(
                    fontSize: size.height * 0.03,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Identify medicines using your camera',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Gap(size.height * 0.02),
                Card(
                  elevation: 4,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(size.width * 0.04),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'कैसे इस्तेमाल करें:',
                          style: GoogleFonts.openSans(
                            fontSize: size.height * 0.022,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Gap(size.height * 0.015),
                        UsageTip(
                          text:
                              'दवाई को एक साधारण रंग की जगह (जैसे सफेद कपड़ा) पर रखें',
                        ),
                        UsageTip(text: 'साफ़ और अच्छी रोशनी में फोटो लें'),
                        UsageTip(text: 'कैमरा को दवाई के ठीक ऊपर रखें'),
                        UsageTip(text: 'पूरी गोली या पैक को साफ़-साफ़ दिखाएं'),
                      ],
                    ),
                  ),
                ),
                Gap(size.height * 0.02),
                Card(
                  elevation: 4,
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.04,
                      vertical: size.width * 0.04,
                    ),
                    child: Column(
                      children: [
                        CustomElevatedButton(
                          text: 'Open Camera',
                          onPressed: _openCamera,
                          backgroundClr: Colors.blue.shade700,
                          textClr: Colors.white,
                          icn: Icons.camera_alt_outlined,
                        ),
                        Gap(size.height * 0.02),
                        CustomElevatedButton(
                          text: 'Upload Image',
                          onPressed: _pickImage,
                          backgroundClr: Colors.white,
                          textClr: Colors.black,
                          icn: Icons.photo_library_outlined,
                        ),
                      ],
                    ),
                  ),
                ),
                if (_selectedImage != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        _selectedImage!,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                if (_pillName != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Card(
                      elevation: 4,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('📋 Extracted Pill Info:', style: TextStyle(fontWeight: FontWeight.bold)),
                            SizedBox(height: 10),
                            Text('💊 Pill Name: $_pillName'),
                            Text('🧪 Dosage: $_dosage'),
                            Text('📌 Used For: $_usedFor'),
                            Text('📅 Expiry: $_expiry'),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
