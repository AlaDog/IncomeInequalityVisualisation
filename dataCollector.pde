/**
 * @author      Alexander Elton-Pym aelt7654@uni.sydney.edu.au
 * @version     1.1     
 *
 *  ACRONYMS
 *  SUA: Signigicang urban area - Larger areas, smaller set
 *  SA2: Statistical area (level 2) - Smaller areas, larger set
 */

import java.util.Map;
import java.io.FileNotFoundException;

HashMap<String, double[][]> data; //this hashmap will store the 110 SUAs and collect the SA2's data
Table sa2; //stores the SA2 input data
Table sua; //stores the SUA input data

Table out; //the final output of the program

void setup() {

  sa2 = loadTable("sa2Data.csv", "header");
  sua = loadTable("suaData.csv", "header");
  out = new Table();

  //initialise the hashmap
  data = new HashMap<String, double[][]>(110); //setting intial capacity to 110 to optimise data structure for the SUAs


  //initially setting keys as SUA names and copying in the population data (came with SUAs)
  for (TableRow row : sua.rows()) {
    double[][] storedData = new double[7][2]; //we are storing 7 attributes as well as a count for averaging 
    storedData[6][0] = row.getDouble(1);
    String suaName = row.getString(0);
    data.put(suaName, storedData);
  }

  //loop through the SA2s and collect data into 'buckets'
  for (TableRow row : sa2.rows()) {
    String suaName = row.getString("SUA");
    double[][] storedData = data.get(suaName);

    for (int i = 0; i < 6; i++) {
      double val = -1; //this is the n/a, np, null representor
      try {
        val = Double.parseDouble(row.getString(1+i));
      } 
      catch (NumberFormatException nfE) { //handles cases where the data is no numerical and parseable to a double
      }
      if (val != -1) { //dont count non-numeric cases
        storedData[i][0] += val; //collect data from csv
        storedData[i][1]++; //count number of S2As in each SUA that is calculated for averages
      }
    }
    data.put(suaName, storedData);
  }

  //loop through SUAs and divide median, mean, gini and top to get averages
  //note income and area are summed as the S2As perfectly make up the SUAs
  for (Map.Entry en : data.entrySet()) {
    double[][] toAvg  = (double[][])en.getValue();
    toAvg[1][0] /= toAvg[1][1];
    toAvg[2][0] /= toAvg[2][1];
    toAvg[3][0] /= toAvg[3][1];
    toAvg[4][0] /= toAvg[4][1];
    en.setValue(toAvg);
  }

  //construct output file
  out.addColumn("SUA");
  out.addColumn("Income");
  out.addColumn("Median Income");
  out.addColumn("Mean Income");
  out.addColumn("Gini");
  out.addColumn("Top");
  out.addColumn("Area");
  out.addColumn("Population");

  //populate output fille
  for (Map.Entry en : data.entrySet()) {
    TableRow newRow = out.addRow();
    newRow.setString(0, (String)en.getKey());
    for (int i = 0; i < 7; i++) {
      newRow.setDouble(i+1, ((double[][])en.getValue())[i][0]);
    }
  }

  //save file
  try {
    saveTable(out, "ouput.csv"); 

    //finished screen
    background(0, 255, 0);
    textAlign(CENTER, CENTER);
    textSize(20);
    text("DONE", width/2, height/2);
  } 
  catch (Exception fnfE) { //make sure you don't have the file open
    background(255, 0, 0);
    textAlign(CENTER, CENTER);
    textSize(15);
    text("CLOSE FILE", width/2, height/2);
  }
}