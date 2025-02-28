//●▀
//make it so the first mine clicked is never a mine
//choose board size and mine count
//click all mines at end of game
//make numbers have set colors instead of random

import de.bezier.guido.*;

public final static int NUM_ROWS = 20;
public final static int NUM_COLS = 20;
public final static int NUM_SQUARES = NUM_ROWS * NUM_COLS;
public static int NUM_MINES = 150;

//width and height
public static int w;
public static int h;

private MSButton[][] squares = new MSButton[NUM_ROWS][NUM_COLS]; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList <MSButton>(); //ArrayList of just the minesweeper buttons that are mined

void setup () {
  size(600, 600);
  w = width;
  h = height;
  background(255);
  textAlign(CENTER, CENTER);
  // make the manager
  Interactive.make( this );
  for (int r = 0; r < NUM_ROWS; r++) {
    for (int c = 0; c < NUM_COLS; c++) {
      squares[r][c] = new MSButton(r, c);
    }
  }
  setMines();
}

public void setMines() {
  while (mines.size() < NUM_MINES) {
    int r = (int)(Math.random()*NUM_ROWS);
    int c = (int)(Math.random()*NUM_COLS);
    if (!mines.contains(squares[r][c])) { //if this square isn't already a mine
      mines.add(squares[r][c]);
    }
  }
}

public void draw () {
  background(255);
  if (isWon() == true)
    displayWinningMessage();
}

public boolean isWon() {
  return false;
}

public void displayLosingMessage() {
}

public void displayWinningMessage() {
}

public boolean isValid(int r, int c) {
  return (r >= 0 && c >= 0 && r <= NUM_ROWS && c <= NUM_COLS);
}
public int countMines(int row, int col) {
  int numMines = 0;
  for (int r = row-1; r <= row+1; r++) {
    for (int c = col-1; c <= col+1; c++) {
      if (isValid(r, c) && mines.contains(squares[r][c])) {
        numMines++;
      }
    }
  }
  return numMines;
}
public class MSButton 
{
  private int myRow, myCol;
  private float x, y, width, height;
  private boolean clicked, flagged, hovered, mined;
  private String myLabel;
  private color myRandColor;

  public MSButton (int row, int col) {
    width = w/NUM_COLS;
    height = h/NUM_ROWS;
    myRow = row;
    myCol = col; 
    flagged = clicked = hovered = false;
    x = myCol*width;
    y = myRow*height;
    myLabel = "";
    myRandColor = color((int)(Math.random()*255)-100, (int)(Math.random()*255)-100, (int)(Math.random()*255));
    Interactive.add( this ); // register it with the manager
  }

  // called by manager
  public void mousePressed () 
  {
    if (mouseX < x+width && mouseX > x && mouseY < y+height && mouseY > y) {
      if (mouseButton == RIGHT) {
        flagged = !flagged;
        if (flagged) {
          myLabel = "▀";
        } else { 
          myLabel = "";
        }
      } else if (mouseButton == LEFT && !flagged) {
        clicked = true;
        if (mines.contains(this)) {
          this.setLabel("●");
          mined = true;
        } else {
          this.setLabel(countMines(myRow, myCol));
        }
      }
    }
  }

  public void draw () { 
    if (mouseX < x+width && mouseX > x && mouseY < y+height && mouseY > y) {
      hovered = true;
    } else { 
      hovered = false;
    }
    noStroke();
    if (hovered && !clicked) { 
      fill(#b9dd77); //hovered color
    } else {
      if ((myRow % 2 == 0 && myCol % 2 != 0)||(myRow % 2 != 0 && myCol % 2 == 0)) {
        if (!clicked) {
          fill(#94bf41); //darker green
        } else if (clicked) {
          fill(215, 184, 153); //darker tan
        }
      } else {
        if (!clicked) {
          fill(#aad751); //lighter green
        } else if (clicked) {
          fill(229, 194, 159);
        }
      }
    } 
    hovered = false;

    rect(x, y, width, height);
    if (flagged || mined) { 
      textSize(15);
      fill(255, 0, 0);
    } else {
      textSize(20);
      fill(myRandColor);
    }
    text(myLabel, x+width/2, y+height/2);
  }
  public void setLabel(String newLabel)
  {
    myLabel = newLabel;
  }
  public void setLabel(int newLabel)
  {
    myLabel = ""+ newLabel;
  }
  public boolean isFlagged()
  {
    return flagged;
  }
  public boolean isClicked() 
  {
    return clicked;
  }
}
