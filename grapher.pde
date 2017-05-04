/**
 * @author      Alexander Elton-Pym aelt7654@uni.sydney.edu.au
 * @version     1.1     
 */

import org.gicentre.geomap.*; //gicenter's geomap library required for processing shapefiles
import processing.pdf.*;      //processing's pdf library required for saving PDFs
import java.util.Arrays;

GeoMap geoMap;
color[] colors;

Table centroids;
Table input;

ArrayList<String> capitals = new ArrayList<String>(8);

void setup() {  
  size(4961, 3508, PDF, "vectorOut300.pdf"); //output file
  geoMap = new GeoMap(118, 70, 4724, 3368, this); //create a map in middle of screen
  geoMap.readFile("SUA_2011_AUST"); //read shapefile
  println("loaded");

  //load csv files for centroid locations and input data
  centroids = loadTable("centroids.csv", "header");
  input = loadTable("input.csv", "header");

  String[] names = {
    "Sydney", 
    "Melbourne", 
    "Darwin", 
    "Hobart", 
    "Perth", 
    "Brisbane", 
    "Adelaide", 
    "Canberra - Queanbeyan"
  };

  capitals.addAll(Arrays.asList(names));
}

void draw() {
  // background(#A6C9D8); //blue background for 'water'
  background(255);
  Table t = geoMap.getAttributeTable(); //load shapefile attributes into memory

  strokeWeight(2);
  stroke(255); //light border stroke
  fill(150); //fill light grey for contrast

  //draw map
  geoMap.draw();
  noStroke();
  //loop through and draw SUAs
  int j = 0;
  for (Feature feat : geoMap.getFeatures().values()) {

    //find data for SUA
    TableRow found = input.findRow(t.getString(j, 2), 0);

    float gini = found.getFloat(4); //range: 0.377 - 0.52 (larger is less equal)
    float top = found.getFloat(5);  //range: 4.2 - 10.825
    if (j > 0) { //handle 'other territories' case
      //get polygon centroids
      float x = centroids.getFloat(j-1, 1);
      float y = centroids.getFloat(j-1, 2);
      //convert geographic to screen coordinate
      PVector point = geoMap.geoToScreen(x, y);

      //lerp color by gini coefficient
      float lerp = map(gini, 0.377, 0.52, 0, 1);
      if (lerp < 0.5) { //three colour gradient
        fill( lerpColor(color(#ffffff), color(#68C65A), lerp*2), 200);
      } else {
        fill( lerpColor(color(#68C65A), color(#000000), (lerp-0.5)*2), 200);
      } 

      //map top 1% income to ellipse area
      float area = map(top, 4.2, 10.825, 2500, 75000); 
      float r = sqrt(area/PI); //convert area to radius
      ellipse(point.x, point.y, r, r);
    }

    j++;
  }

  //Last minute addition to draw the capitals last
  stroke(0);
  strokeWeight(2);
  j = 0;
  for (int id : geoMap.getFeatures().keySet()) {
    TableRow found = input.findRow(t.getString(j, 2), 0);
    float gini = found.getFloat(4);
    float top = found.getFloat(5);
    if (j > 0) {
      float x = found.getFloat(8);
      float y = found.getFloat(9);
      PVector point = geoMap.geoToScreen(x, y);
      float lerp = map(gini, 0.377, 0.52, 0, 1);
      if (lerp < 0.5) {
        fill( lerpColor(color(#ffffff), color(#68C65A), lerp*2), 255);
      } else {
        fill( lerpColor(color(#68C65A), color(#000000), (lerp-0.5)*2), 255);
      } 
      float area = map(top, 4.2, 10.825, 2500, 75000); 
      float r = sqrt(area/PI);
      if (capitals.contains(found.getString(0)) ) {
        ellipse(point.x, point.y, r, r);
      }
    }
    j++;
  }

  println("DONE");
  exit();
}