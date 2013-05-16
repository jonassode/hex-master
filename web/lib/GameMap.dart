library gamemap;

import "Hex.dart";
import "Units.dart";
import "GamePoint.dart";
import 'dart:math';
import 'package:js/js.dart' as js;

class GameMap {
  var matrix;
  var conf;
  HexField hexfield;
  
  GameMap(rows, cols, x, y){
    
    // Create Matrix
    matrix = new js.Proxy(js.context.jsmatrix.Matrix2d, rows, cols, new js.Proxy(js.context.jsmatrix.Hex));
    js.retain(matrix);

    // Create Randon Thing
    var rng = new Random();
    
    // Add some rocks
    for( var i = 0; i < 45; i++ ) {
      matrix.get_cell(rng.nextInt(8),rng.nextInt(24)).set_item("rock", {});
    }
    
    // Create Configuration to block rocks
    conf = new js.Proxy(js.context.jsmatrix.Configuration);
    conf.add_blocker("rock");
    js.retain(conf);

    // Create The Hex field
    hexfield = new HexField(this.matrix, x, y, 30);

  }
  
  void set_area(r, c){
    
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
    var start = new js.Proxy(js.context.Point, r, c);
    var area = matrix.find_area(start, null, depth, conf);   

    ccell.set_item('start', {});
    //ccell.set_item('unit', new Unit("Tank", "t", 5, 3, 2, 1));

    for ( var i = 0; i < area.length; i++ ){
      var pos = area[i].pos;
      matrix.get_cell(pos.row,pos.col).set_item('area', {}); 

    } 
    
  }

  void draw(context){
    hexfield.draw(context);
  }
}