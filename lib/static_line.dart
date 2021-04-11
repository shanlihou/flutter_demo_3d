import 'package:flutter/material.dart';
import 'package:flutter/painting.dart' as PaintLib;
import 'package:flutter_demo_3d/utils.dart';
import 'package:vector_math/vector_math.dart' as Math;

class StaticLine extends StatefulWidget {
  _StaticLineState createState() => _StaticLineState();
}

class _StaticLineState extends State<StaticLine>{
  double angleX = 0.0;
  double angleY = 0.0;
  double angleZ = 0.0;

  _dragX(DragUpdateDetails update) {
    setState(() {
      angleX += update.delta.dy;
      if (angleX > 360)
        angleX = angleX - 360;
      else if (angleX < 0) angleX = 360 - angleX;
    });
  }

  _dragY(DragUpdateDetails update) {
    setState(() {
      angleY += update.delta.dx;
      if (angleY > 360)
        angleY = angleY - 360;
      else if (angleY < 0) angleY = 360 - angleY;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: CustomPaint(
        painter: _LinePainter(angleX, angleY, angleZ),
        size: Size(400.0, 400.0),
      ),
      onHorizontalDragUpdate: (DragUpdateDetails update) => _dragY(update),
      onVerticalDragUpdate: (DragUpdateDetails update) => _dragX(update),
    );
  }
}


class _LinePainter extends CustomPainter {
  double angleX;
  double angleY;
  double angleZ;
  List<Math.Vector3> verts;

  Math.Vector3 _calcVertex(Math.Vector3 vertex) {
    var trans = Math.Matrix4.translationValues(200, 200, 1);
    //trans.scale(0.0, 0.0);
    trans.rotateX(Utils.degreeToRadian(angleX));
    trans.rotateY(Utils.degreeToRadian(angleY));
    trans.rotateZ(Utils.degreeToRadian(angleZ));
    return trans.transform3(vertex);
  }

  _LinePainter(this.angleX, this.angleY, this.angleZ) {
    List<Math.Vector3> _verts = <Math.Vector3>[];
    _verts.add(Math.Vector3(5, 5, 5));
    _verts.add(Math.Vector3(5, 72, 36));
    _verts.add(Math.Vector3(47, 85, 43));
    _verts.add(Math.Vector3(69, 19, 96));

    verts = <Math.Vector3>[];
    for (int i = 0; i < _verts.length; i++) {
      verts.add(_calcVertex(_verts[i]));
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    PaintLib.Gradient gradient = PaintLib.LinearGradient(
      begin: Alignment.topCenter,
      end:
      Alignment(0.8, 0.0), // 10% of the width, so there are ten blinds.
      colors: <Color>[
        Color(0xffee0000),
        Color(0xffeeee00)
      ], // red to yellow
      tileMode: TileMode.repeated, // repeats the gradient over the canvas
    );

    var paint = Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..shader = gradient.createShader(Rect.fromLTWH(0,0,size.width, size.height))
      ..strokeWidth = 5.0;

    for (int i = 0; i < verts.length - 1; i++) {
      print("cur x:${verts[i].x}, y:${verts[i].y}, next x:${verts[i + 1].x}, y:${verts[i + 1].y}, i:${i}");
      canvas.drawLine(Offset(verts[i].x, verts[i].y), Offset(verts[i + 1].x, verts[i + 1].y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}