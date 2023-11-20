import 'package:dart_periphery/dart_periphery.dart';

const codes = {
  'a': '.-',
  'b': '-...',
  'c': '-.-.',
  'd': '-..',
  'e': '.',
  'f': '..-.',
  'g': '--.',
  'h': '....',
  'i': '..',
  'j': '.---',
  'k': '-.-',
  'l': '.-..',
  'm': '--',
  'n': '-.',
  'o': '---',
  'p': '.--.',
  'q': '--.-',
  'r': '.-.',
  's': '...',
  't': '-',
  'u': '..-',
  'v': '...-',
  'w': '.--',
  'x': '-..-',
  'y': '-.--',
  'z': '--..',
  '1': '.----',
  '2': '..---',
  '3': '...--',
  '4': '....-',
  '5': '.....',
  '6': '-....',
  '7': '--...',
  '8': '---..',
  '9': '----.',
  '0': '-----',
  ', ': '--..--',
  '.': '.-.-.-',
  '?': '..--..',
  '/': '-..-.',
  '-': '-....-',
  '(': '-.--.',
  ')': '-.--.-'
};

Future<void> blinkLight(String regularString, Led led) async {
  for (var element in regularString.runes) {
    var character = String.fromCharCode(element).toLowerCase();
    if (character == " ") {
      await Future.delayed(const Duration(milliseconds: 1050));
    }
    if (codes.containsKey(character)) {
      for (var codeRune in codes[character]!.runes) {
        var codeChar = String.fromCharCode(codeRune).toLowerCase();
        switch (codeChar) {
          case "-":
            led.setBrightness(1);
            await Future.delayed(const Duration(milliseconds: 450));
            led.setBrightness(0);
            await Future.delayed(const Duration(milliseconds: 450));
            break;
          case ".":
            led.setBrightness(1);
            await Future.delayed(const Duration(milliseconds: 150));
            led.setBrightness(0);
            await Future.delayed(const Duration(milliseconds: 450));
            break;
        }
      }
    }
    await Future.delayed(const Duration(milliseconds: 450));
  }
  return;
}
