// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:ui' as ui;
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';

enum Detector { barcode, face, label, cloudLabel, text }

class BarcodeDetectorPainter extends CustomPainter {
  BarcodeDetectorPainter(this.imageSize, this.barcodes);

  final Size imageSize;
  final List<Barcode> barcodes;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    for (Barcode barcode in barcodes) {
      paint.color = Colors.green;
      canvas.drawRect(
        _scaleAndFlipRectangle(
          rect: barcode.boundingBox,
          imageSize: imageSize,
          widgetSize: size,
          shouldFlipX: defaultTargetPlatform != TargetPlatform.iOS,
          shouldFlipY: defaultTargetPlatform != TargetPlatform.iOS,
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(BarcodeDetectorPainter oldDelegate) {
    return oldDelegate.imageSize != imageSize ||
        oldDelegate.barcodes != barcodes;
  }
}

class FaceDetectorPainter extends CustomPainter {
  FaceDetectorPainter(this.imageSize, this.faces);

  final Size imageSize;
  final List<Face> faces;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..color = Colors.red;

    final Paint paint2 = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5.0
      ..color = Colors.green;

    for (Face face in faces) {
      List<Offset> points = List();
      if (face.getLandmark(FaceLandmarkType.leftEye) != null) {
        points.add(_scaleAndFlipLine(
          rect: Offset(face.getLandmark(FaceLandmarkType.leftEye).position.x,
              face.getLandmark(FaceLandmarkType.leftEye).position.y),
          imageSize: imageSize,
          widgetSize: size,
        ));
      }

      if (face.getLandmark(FaceLandmarkType.rightEye) != null) {
        points.add(_scaleAndFlipLine(
          rect: Offset(face.getLandmark(FaceLandmarkType.rightEye).position.x,
              face.getLandmark(FaceLandmarkType.rightEye).position.y),
          imageSize: imageSize,
          widgetSize: size,
        ));
      }

      if (face.getLandmark(FaceLandmarkType.leftMouth) != null) {
        points.add(_scaleAndFlipLine(
          rect: Offset(face.getLandmark(FaceLandmarkType.leftMouth).position.x,
              face.getLandmark(FaceLandmarkType.leftMouth).position.y),
          imageSize: imageSize,
          widgetSize: size,
        ));
      }

      if (face.getLandmark(FaceLandmarkType.leftEar) != null) {
        points.add(_scaleAndFlipLine(
          rect: Offset(face.getLandmark(FaceLandmarkType.leftEar).position.x,
              face.getLandmark(FaceLandmarkType.leftEar).position.y),
          imageSize: imageSize,
          widgetSize: size,
        ));
      }

      if (face.getLandmark(FaceLandmarkType.leftCheek) != null) {
        points.add(_scaleAndFlipLine(
          rect: Offset(face.getLandmark(FaceLandmarkType.leftCheek).position.x,
              face.getLandmark(FaceLandmarkType.leftCheek).position.y),
          imageSize: imageSize,
          widgetSize: size,
        ));
      }

      if (face.getLandmark(FaceLandmarkType.rightCheek) != null) {
        points.add(_scaleAndFlipLine(
          rect: Offset(face.getLandmark(FaceLandmarkType.rightCheek).position.x,
              face.getLandmark(FaceLandmarkType.rightCheek).position.y),
          imageSize: imageSize,
          widgetSize: size,
        ));
      }

      if (face.getLandmark(FaceLandmarkType.rightEar) != null) {
        points.add(_scaleAndFlipLine(
          rect: Offset(face.getLandmark(FaceLandmarkType.rightEar).position.x,
              face.getLandmark(FaceLandmarkType.rightEar).position.y),
          imageSize: imageSize,
          widgetSize: size,
        ));
      }

      if (face.getLandmark(FaceLandmarkType.rightMouth) != null) {
        points.add(_scaleAndFlipLine(
          rect: Offset(face.getLandmark(FaceLandmarkType.rightMouth).position.x,
              face.getLandmark(FaceLandmarkType.rightMouth).position.y),
          imageSize: imageSize,
          widgetSize: size,
        ));
      }

      if (face.getLandmark(FaceLandmarkType.bottomMouth) != null) {
        points.add(_scaleAndFlipLine(
          rect: Offset(
              face.getLandmark(FaceLandmarkType.bottomMouth).position.x,
              face.getLandmark(FaceLandmarkType.bottomMouth).position.y),
          imageSize: imageSize,
          widgetSize: size,
        ));
      }

      if (face.getLandmark(FaceLandmarkType.noseBase) != null) {
        points.add(_scaleAndFlipLine(
          rect: Offset(face.getLandmark(FaceLandmarkType.noseBase).position.x,
              face.getLandmark(FaceLandmarkType.noseBase).position.y),
          imageSize: imageSize,
          widgetSize: size,
        ));
      }

      canvas.drawPoints(ui.PointMode.points, points, paint2);
      canvas.drawRect(
        _scaleAndFlipRectangle(
          rect: face.boundingBox,
          imageSize: imageSize,
          widgetSize: size,
          shouldFlipY: false,
          shouldFlipX: defaultTargetPlatform != TargetPlatform.iOS,
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(FaceDetectorPainter oldDelegate) {
    return oldDelegate.imageSize != imageSize || oldDelegate.faces != faces;
  }
}

class LabelDetectorPainter extends CustomPainter {
  LabelDetectorPainter(this.imageSize, this.labels);

  final Size imageSize;
  final List<Label> labels;

  @override
  void paint(Canvas canvas, Size size) {
    final ui.ParagraphBuilder builder = ui.ParagraphBuilder(
      ui.ParagraphStyle(
          textAlign: TextAlign.left,
          fontSize: 23.0,
          textDirection: TextDirection.ltr),
    );

    builder.pushStyle(ui.TextStyle(color: Colors.green));
    for (Label label in labels) {
      builder.addText('Label: ${label.label}, '
          'Confidence: ${label.confidence.toStringAsFixed(2)}\n');
    }
    builder.pop();

    canvas.drawParagraph(
      builder.build()
        ..layout(ui.ParagraphConstraints(
          width: size.width,
        )),
      const Offset(0.0, 0.0),
    );
  }

  @override
  bool shouldRepaint(LabelDetectorPainter oldDelegate) {
    return oldDelegate.imageSize != imageSize || oldDelegate.labels != labels;
  }
}

// Paints rectangles around all the text in the image.
class TextDetectorPainter extends CustomPainter {
  TextDetectorPainter(this.imageSize, this.visionText);

  final Size imageSize;
  final VisionText visionText;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    Rect _getRect(TextContainer container) {
      return _scaleAndFlipRectangle(
        rect: container.boundingBox,
        imageSize: imageSize,
        widgetSize: size,
        shouldFlipY: defaultTargetPlatform != TargetPlatform.iOS,
        shouldFlipX: defaultTargetPlatform != TargetPlatform.iOS,
      );
    }

    for (TextBlock block in visionText.blocks) {
      for (TextLine line in block.lines) {
        for (TextElement element in line.elements) {
          paint.color = Colors.green;
          canvas.drawRect(_getRect(element), paint);
        }

        paint.color = Colors.yellow;
        canvas.drawRect(_getRect(line), paint);
      }

      paint.color = Colors.red;
      canvas.drawRect(_getRect(block), paint);
    }
  }

  @override
  bool shouldRepaint(TextDetectorPainter oldDelegate) {
    return oldDelegate.imageSize != imageSize ||
        oldDelegate.visionText != visionText;
  }
}

Rect _scaleAndFlipRectangle({
  @required Rectangle<int> rect,
  @required Size imageSize,
  @required Size widgetSize,
  bool shouldScaleX = true,
  bool shouldScaleY = true,
  bool shouldFlipX = true,
  bool shouldFlipY = true,
}) {
  final double scaleX = shouldScaleX ? widgetSize.width / imageSize.width : 1;
  final double scaleY = shouldScaleY ? widgetSize.height / imageSize.height : 1;

  double left;
  double right;
  if (shouldFlipX) {
    left = imageSize.width - rect.left;
    right = imageSize.width - rect.right;
  } else {
    left = rect.left.toDouble();
    right = rect.right.toDouble();
  }

  double top;
  double bottom;
  if (shouldFlipY) {
    top = imageSize.height - rect.top;
    bottom = imageSize.height - rect.bottom;
  } else {
    top = rect.top.toDouble();
    bottom = rect.bottom.toDouble();
  }

  return Rect.fromLTRB(
    left * scaleX,
    top * scaleY,
    right * scaleX,
    bottom * scaleY,
  );
}

Offset _scaleAndFlipLine(
    {@required Offset rect,
    @required Size imageSize,
    @required Size widgetSize,
    bool shouldScaleX = true,
    bool shouldScaleY = true}) {
  final shouldFlipX = defaultTargetPlatform != TargetPlatform.iOS;
  final double scaleX = shouldScaleX ? widgetSize.width / imageSize.width : 1;
  final double scaleY = shouldScaleY ? widgetSize.height / imageSize.height : 1;

  double left;
  if (shouldFlipX) {
    left = imageSize.width - rect.dx;
  } else {
    left = rect.dx.toDouble();
  }

  double top = imageSize.height - rect.dy;

  return Offset(left * scaleX, top * scaleY);
}
