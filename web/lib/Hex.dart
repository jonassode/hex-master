
library hexlib;

import 'package:js/js.dart' as js;
import 'dart:math';
import 'dart:html';

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
  
  HexField(this.x, this.y, this.size){
    height = size;
    width = size * 1.5;
    xangle = size * 0.75;
    yangle = xangle / 2;
  }
  
  void set_area(r, c){
    
    var matrix = js.context.matrix;
    var conf = js.context.conf;
    
    var ccell = matrix.get_cell(r,c);
    
    // Clean up matrix      
    for( var row = 0; row < matrix.rows; row++) {
      for( var col = 0; col < matrix.cols; col++) {
        var cell = matrix.get_cell(row,col);
        cell.has_item_by_type("area") ? cell.remove_item('area') : false;
        cell.has_item_by_type("start") ? cell.remove_item('start') : false;
      }
    }

    // Defining the start and goal positions
    var depth = 2;
    var start = matrix.point(r, c);
    var area = matrix.find_area(start, null, depth, conf);   
    
    ccell.set_item('start', {});

    for ( var i = 0; i < area.length; i++ ){
      var pos = area[i].pos;
      matrix.get_cell(pos.row,pos.col).set_item('area', {});           
    } 
    
  }
  
  void draw(context){
    
    var m = js.context.matrix;
        
    num xx;
    num yy = y;
    bool even = false;
    var color = 'lightblue';
    
    for (int j = 0; j < m.rows; j++) {
      xx = x;
      if ( even ){
        xx += width / 2 + 1;
      }
      for (int i = 0; i < m.cols; i++) {
        var color = "lightblue";
        color = m.get_cell(j,i).has_item_by_type("area") ? "pink" : color;
        color = m.get_cell(j,i).has_item_by_type("start") ? "blue" : color;
        color = m.get_cell(j,i).has_item_by_type("rock") ? "gray" : color;
        
        draw_hex(context, xx, yy, color);
        xx += width + border;
      }
      yy += (height * 1.375) + border;
      even = even ? false : true;
    }
  }
  
  void draw_hex(context, xx, yy, color){
    
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

