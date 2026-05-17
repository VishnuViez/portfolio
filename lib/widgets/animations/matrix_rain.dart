import 'package:flutter/material.dart';
import 'dart:math' as math;

class MatrixRain extends StatefulWidget {
  final Color? color;
  final double opacity;
  final int columns;

  const MatrixRain({
    super.key,
    this.color,
    this.opacity = 0.3,
    this.columns = 50,
  });

  @override
  State<MatrixRain> createState() => _MatrixRainState();
}

class _MatrixRainState extends State<MatrixRain>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<MatrixColumn> _columns = [];
  final List<String> _chars = [
    '0', '1', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H',
    'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R',
    'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', '{', '}',
    '<', '>', '/', '(', ')', '[', ']', '+', '-', '*',
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 50),
    )..addListener(_updateColumns);
    
    _controller.repeat();
  }

  void _initColumns(Size size) {
    if (_columns.isEmpty) {
      final random = math.Random();
      final columnWidth = size.width / widget.columns;
      
      for (int i = 0; i < widget.columns; i++) {
        _columns.add(MatrixColumn(
          x: i * columnWidth,
          y: random.nextDouble() * size.height - size.height,
          speed: random.nextDouble() * 3 + 1,
          length: random.nextInt(20) + 10,
          chars: List.generate(
            30,
            (_) => _chars[random.nextInt(_chars.length)],
          ),
        ));
      }
    }
  }

  void _updateColumns() {
    setState(() {
      final random = math.Random();
      for (var column in _columns) {
        column.y += column.speed;
        
        // Reset when column goes off screen
        if (column.y > MediaQuery.of(context).size.height + 100) {
          column.y = -100;
          column.speed = random.nextDouble() * 3 + 1;
          column.length = random.nextInt(20) + 10;
          column.chars = List.generate(
            30,
            (_) => _chars[random.nextInt(_chars.length)],
          );
        }
        
        // Randomly change characters
        if (random.nextDouble() > 0.95) {
          final index = random.nextInt(column.chars.length);
          column.chars[index] = _chars[random.nextInt(_chars.length)];
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = widget.color ?? theme.colorScheme.primary;

    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);
        _initColumns(size);

        return CustomPaint(
          size: size,
          painter: _MatrixPainter(
            columns: _columns,
            color: color,
            opacity: widget.opacity,
          ),
        );
      },
    );
  }
}

class MatrixColumn {
  double x;
  double y;
  double speed;
  int length;
  List<String> chars;

  MatrixColumn({
    required this.x,
    required this.y,
    required this.speed,
    required this.length,
    required this.chars,
  });
}

class _MatrixPainter extends CustomPainter {
  final List<MatrixColumn> columns;
  final Color color;
  final double opacity;

  _MatrixPainter({
    required this.columns,
    required this.color,
    required this.opacity,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (var column in columns) {
      for (int i = 0; i < column.length; i++) {
        final charY = column.y + (i * 20);
        if (charY < 0 || charY > size.height) continue;
        
        // Calculate opacity - brighter at the head, fading toward tail
        final charOpacity = (1 - (i / column.length)) * opacity;
        
        final textPainter = TextPainter(
          text: TextSpan(
            text: column.chars[i % column.chars.length],
            style: TextStyle(
              color: i == 0 
                  ? Colors.white.withOpacity(charOpacity * 1.5)
                  : color.withOpacity(charOpacity),
              fontSize: 14,
              fontFamily: 'monospace',
              fontWeight: i == 0 ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          textDirection: TextDirection.ltr,
        );
        
        textPainter.layout();
        textPainter.paint(canvas, Offset(column.x, charY));
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// Floating code snippets
class FloatingCodeSnippets extends StatefulWidget {
  final int snippetCount;
  
  const FloatingCodeSnippets({
    super.key,
    this.snippetCount = 5,
  });

  @override
  State<FloatingCodeSnippets> createState() => _FloatingCodeSnippetsState();
}

class _FloatingCodeSnippetsState extends State<FloatingCodeSnippets>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<CodeSnippet> _snippets = [];
  final List<String> _codeLines = [
    'class Portfolio {',
    'Widget build() {',
    'return Awesome();',
    'final data = [];',
    'if (code.isClean)',
    'async function()',
    'const result = {}',
    'import React',
    'npm install',
    'git commit -m',
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 16),
    )..addListener(_updateSnippets);
    
    _controller.repeat();
  }

  void _initSnippets(Size size) {
    if (_snippets.isEmpty) {
      final random = math.Random();
      for (int i = 0; i < widget.snippetCount; i++) {
        _snippets.add(CodeSnippet(
          x: random.nextDouble() * size.width,
          y: random.nextDouble() * size.height,
          vx: (random.nextDouble() - 0.5) * 0.3,
          vy: (random.nextDouble() - 0.5) * 0.3,
          text: _codeLines[random.nextInt(_codeLines.length)],
          opacity: random.nextDouble() * 0.3 + 0.1,
          rotation: random.nextDouble() * math.pi * 2,
          rotationSpeed: (random.nextDouble() - 0.5) * 0.01,
        ));
      }
    }
  }

  void _updateSnippets() {
    final size = MediaQuery.of(context).size;
    setState(() {
      for (var snippet in _snippets) {
        snippet.x += snippet.vx;
        snippet.y += snippet.vy;
        snippet.rotation += snippet.rotationSpeed;

        // Bounce off edges
        if (snippet.x < 0 || snippet.x > size.width) snippet.vx *= -1;
        if (snippet.y < 0 || snippet.y > size.height) snippet.vy *= -1;
        
        // Keep within bounds
        snippet.x = snippet.x.clamp(0, size.width);
        snippet.y = snippet.y.clamp(0, size.height);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);
        _initSnippets(size);

        return CustomPaint(
          size: size,
          painter: _CodeSnippetPainter(
            snippets: _snippets,
            color: Theme.of(context).colorScheme.primary,
          ),
        );
      },
    );
  }
}

class CodeSnippet {
  double x;
  double y;
  double vx;
  double vy;
  final String text;
  double opacity;
  double rotation;
  double rotationSpeed;

  CodeSnippet({
    required this.x,
    required this.y,
    required this.vx,
    required this.vy,
    required this.text,
    required this.opacity,
    required this.rotation,
    required this.rotationSpeed,
  });
}

class _CodeSnippetPainter extends CustomPainter {
  final List<CodeSnippet> snippets;
  final Color color;

  _CodeSnippetPainter({
    required this.snippets,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (var snippet in snippets) {
      canvas.save();
      canvas.translate(snippet.x, snippet.y);
      canvas.rotate(snippet.rotation);
      
      final textPainter = TextPainter(
        text: TextSpan(
          text: snippet.text,
          style: TextStyle(
            color: color.withOpacity(snippet.opacity),
            fontSize: 16,
            fontFamily: 'monospace',
            fontWeight: FontWeight.w500,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(-textPainter.width / 2, -textPainter.height / 2),
      );
      
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
