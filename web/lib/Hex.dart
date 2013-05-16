
library hexlib;

import 'package:js/js.dart' as js;
import 'dart:math';
import 'dart:html';
import 'Units.dart';

class HexField {
  num size;
  num x;
  num y;
  num rows;
  num cols;
  num height;
  num width;
  num xangle;
  num yangle;
  num border = 2;
  var matrix;
  
  HexField(this.matrix, this.x, this.y, this.size){
    height = size;
    width = size * 1.5;
    xangle = size * 0.75;
    yangle = xangle / 2;
  }
  
  void draw(context){
    
    num xx;
    num yy = y;
    bool even = false;
    var color = 'lightblue';
    
    for (int j = 0; j < matrix.rows; j++) {
      xx = x;
      if ( even ){
        xx += width / 2 + 1;
      }
      for (int i = 0; i < matrix.cols; i++) {
        var color = "lightblue";
        var text;
        var cell = matrix.get_cell(j,i);
        color = cell.has_item_by_type("area") ? "pink" : color;
        color = cell.has_item_by_type("start") ? "blue" : color;
        color = cell.has_item_by_type("rock") ? "gray" : color;
        // text = cell.has_item_by_type("unit") ? cell.get_item("unit").sign : text;
        
        draw_hex(context, xx, yy, color, text);
        xx += width + border;
      }
      yy += (height * 1.375) + border;
      even = even ? false : true;
    }
  }
  
  void draw_hex(context, xx, yy, color, text){
    
    // Hex 
    context.beginPath();
    context.fillStyle = color; 

    context.moveTo(xx, yy);
    context.lineTo(xx+xangle, yy-yangle);
    context.lineTo(xx+width, yy);
    context.lineTo(xx+width, yy+height);
    context.lineTo(xx+xangle, yy+height+yangle);
    context.lineTo(xx, yy+height);
        
    context.lineTo(xx, yy);

    context.fill();
    context.closePath();
    
    if ( text != null ){
      num textSize = 16;
      context.fillStyle = "black"; 
      context.font = "bold " + textSize.toString() + "px Arial";
      context.fillText(text, xx + (width/2 - (textSize/3)), yy + (height/1 - (textSize/2)));
    }
    
  }
  
  Hex clickedHex(mouseX, mouseY){
    
    mouseX -= x;
    mouseY -= y;
    
    num row = mouseY / (height+yangle);
    num col = (row.ceil() % 2 != 0 ? mouseX / (width+border) : ((mouseX + width/2) / (width+border))-1);
    // column is more complex because it has to
    // take into account that every other row
    // is offset by 20 pixels (20 for my hexagons anyway)

    return new Hex(row.ceil()-1, col.ceil()-1);
    
  }
}

class Hex {
  num row;
  num col;
  
  Hex(this.row, this.col){
    // Empty Constructor
  }
  
}

