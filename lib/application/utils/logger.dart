import 'package:logger/logger.dart';

final logger = Logger(
  printer: PrettyPrinter(
    methodCount: 0,
    colors: true,
    printEmojis: false,
    printTime: false,
    lineLength: 120,
    errorMethodCount: 8,
    noBoxingByDefault: false,
    levelColors: null,
    levelEmojis: null,
  ),
  output: ConsoleOutput(),
  filter: ProductionFilter(),
  level: Level.debug,
);


