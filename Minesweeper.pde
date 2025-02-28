import de.bezier.guido.*;

public final static int NUM_ROWS = 20;
public final static int NUM_COLS = 20;
public final static int NUM_SQUARES = NUM_ROWS * NUM_COLS;
public static int NUM_MINES = 150;

private MSButton[][] squares = new MSButton[NUM_ROWS][NUM_COLS]; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList <MSButton>(); //ArrayList of just the minesweeper buttons that are mined

void setup () {
  size(600, 600);
  background(255);
  textAlign(CENTER, CENTER);
  // make the manager
  Interactive.make( this );
  //your code to initialize buttons goes here
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
    if(!mines.contains(squares[r][c])) { //if this square isn't already a mine
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
  //your code here
  return false;
}

public void displayLosingMessage() {
  //your code here
}

public void displayWinningMessage() {
  //your code here
}

public boolean isValid(int r, int c) {
  //your code here
  return false;
}
public int countMines(int row, int col) {
  int numMines = 0;
  return numMines;
}
public class MSButton {
  private int myRow, myCol;
  private float x, y, widt, heigh;
  private boolean clicked, flagged;
  private String myLabel;

  public MSButton (int row, int col) {
    widt = width/NUM_COLS;
    heigh = height/NUM_ROWS;
    clicked = flagged = false;
    myRow = row;
    myCol = col; 
    x = myCol*widt;
    y = myRow*heigh;
    myLabel = "";
    Interactive.add( this ); // register it with the manager
  }

  // called by manager
  public void mousePressed () {
    clicked = true;
    //your code here
  }
  public void draw () { 
    noStroke();
    /*if (flagged)
      fill(0);
    else */if (clicked && mines.contains(this)) {
      fill(255, 0, 0);
    } else if (clicked) {
      fill(200);
    } else if ((mouseX < x+widt && mouseX > x && mouseY < y+heigh && mouseY > y)) { 
      fill(#b9dd77); //hovered color
    } else {
      if ((myRow % 2 == 0 && myCol % 2 != 0)||(myRow % 2 != 0 && myCol % 2 == 0)) {
        fill(#94bf41); //darker green
      } else {
        fill(#aad751); //lighter green
      }
    } 

    rect(x, y, widt, heigh);
    fill(0);
    text(myLabel, x+widt/2, y+heigh/2); //check this width and height
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
}

public class SimpleButton {
  float x, y, width, height;
  boolean on;

  SimpleButton ( float xx, float yy, float w, float h )
  {
    x = xx; 
    y = yy; 
    width = w; 
    height = h;

    Interactive.add( this ); // register it with the manager
  }

  // called by manager

  void mousePressed () 
  {
    on = !on;
  }

  void draw () 
  {
    if ( on ) fill( 200 );
    else fill( 100 );

    rect(x, y, width, height);
  }
}
