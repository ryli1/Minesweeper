import de.bezier.guido.*;

//got an if else stairway over here 😳

public final static int NUM_ROWS = 10;
public final static int NUM_COLS = 10;
public final static int NUM_SQUARES = NUM_ROWS * NUM_COLS;
public static int NUM_MINES = (NUM_ROWS*NUM_COLS)/5;
public static String GAME_STATE = "INPLAY"; //SELECT, INPLAY, LOSE, WIN

public static boolean FIRST_CLICK = true;


//width and height
public static int w;
public static int h;

private MSButton[][] squares = new MSButton[NUM_ROWS][NUM_COLS]; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList <MSButton>(); //ArrayList of just the minesweeper buttons that are mined
private int[][] mineIndices = new int[NUM_MINES][2]; //2d array of mine locations

void setup () {
  size(600, 700);
  w = width;
  h = height-100;
  background(74, 117, 44);
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
    if (!mines.contains(squares[r][c])) { //if this square isn't already a mine
      mines.add(squares[r][c]);
    }
  }
  for (MSButton mine : mines) {
    for (int i = 0; i < mineIndices.length; i++) {
      mineIndices[i] = mine.getRowAndCol();
    }
  }
}

public void draw () {
  background(74, 117, 44);
  if (isWon() == true) {
    displayWinningMessage();
  } else if (GAME_STATE == "LOSE") {
    displayLosingMessage();
  }
}

public boolean isWon() {
  int flagCount = 0;
  int clickCount = 0;
  //if all mined squares are flagged or if all safe squares have been clicked
  for (int r = 0; r < squares.length; r++) {
    for (int c = 0; c < squares[r].length; c++) {
      if (mines.contains(squares[r][c]) && squares[r][c].isFlagged()) {
        flagCount++;
      } else if (!mines.contains(squares[r][c]) && squares[r][c].isClicked()) {
        clickCount++;
      }
    }
  }
  if (flagCount == NUM_MINES || clickCount == (NUM_ROWS*NUM_COLS)-NUM_MINES) {
    return true;
  }
  return false;
}

public void displayLosingMessage() {
  pushMatrix();
  fill(255);
  textSize(25);
  text("You Lost...", 300, 650);
  popMatrix();
  //display all mines
  for (int r = 0; r < squares.length; r++) {
    for (int c = 0; c < squares[r].length; c++) {
      if (mines.contains(squares[r][c]) && squares[r][c].isClicked() == false) {
        squares[r][c].setLabel("●");
        squares[r][c].setState(true);
      }
    }
  }
}

public void displayWinningMessage() {
  GAME_STATE = "WIN";
  pushMatrix();
  fill(255);
  textSize(25);
  text("You Won!", 300, 650);
  popMatrix();
}

public boolean isValid(int r, int c) {
  return (r >= 0 && c >= 0 && r < NUM_ROWS && c < NUM_COLS);
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

public void firstClick(int r, int c) {
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
  public void mousePressed() {
    if (GAME_STATE.equals("INPLAY")) {
      if (mouseButton != RIGHT) {
        clicked = true;
      }

      if (mouseButton == RIGHT && !clicked) {
        clicked = false;
        flagged = !flagged;
        if (flagged) {
          myLabel = "|▀";
        } else { 
          myLabel = "";
        }
      } else if (mouseButton == LEFT && flagged) {
        clicked = false;
      } else if (mouseButton == LEFT && !flagged) {
        if (mines.contains(this)) {
          if (FIRST_CLICK == true) {  //if this is the first click and it has a mine: make it not a mine
            mines.remove(this);
            mines.add(squares[(int)(Math.random()*NUM_ROWS)][(int)(Math.random()*NUM_COLS)]); //move it to a new spot
            myLabel = "" + countMines(myRow, myCol);

            //make random surrounding squares not a mine
            /*for (int r = myRow-(int)(Math.random()*5); r < myRow+(int)(Math.random()*5); r++) {
              for (int c = myCol-(int)(Math.random()*5); c < myCol+(int)(Math.random()*5); c++) {
                if (isValid(r, c)) {
                  if (mines.contains(squares[r][c])) {
                    mines.remove(squares[r][c]);
                    int[] newSpot = new int[]{(int)(Math.random()*NUM_ROWS), (int)(Math.random()*NUM_COLS)};
                    for (int[] spots : mineIndices) {
                      if (newSpot == spots) {
                        newSpot[0] = (int)(Math.random()*NUM_ROWS);
                        newSpot[1] = (int)(Math.random()*NUM_COLS);
                        spots[0] = newSpot[0];
                        spots[1] = newSpot[1];
                      }
                    }
                    mines.add(squares[newSpot[0]][newSpot[1]]);
                  }
                  if (!mines.contains(squares[r][c])) {
                    squares[r][c].mousePressed();
                  }
                }
              }
            }*/

            FIRST_CLICK = false;
          } else {
            myLabel = "●";
            mined = true;
            GAME_STATE = "LOSE";
          }
        } else {
          if (FIRST_CLICK == true) {  //if this is the first click and it has no mine, click it
            FIRST_CLICK = false;

            //make random surrounding squares not a mine
            /*for (int r = myRow-(int)(Math.random()*5); r < myRow+(int)(Math.random()*5); r++) {
              for (int c = myCol-(int)(Math.random()*5); c < myCol+(int)(Math.random()*5); c++) {
                if (isValid(r, c)) {
                  if (mines.contains(squares[r][c])) {
                    mines.remove(squares[r][c]);
                    int[] newSpot = new int[]{(int)(Math.random()*NUM_ROWS), (int)(Math.random()*NUM_COLS)};
                    for (int[] spots : mineIndices) {
                      if (newSpot == spots) {
                        newSpot[0] = (int)(Math.random()*NUM_ROWS);
                        newSpot[1] = (int)(Math.random()*NUM_COLS);
                        spots[0] = newSpot[0];
                        spots[1] = newSpot[1];
                      }
                    }
                    mines.add(squares[newSpot[0]][newSpot[1]]);
                  }
                  if (!mines.contains(squares[r][c])) {
                    squares[r][c].mousePressed();
                  }
                }
              }
            }*/

            if (countMines(myRow, myCol) != 0) {
              myLabel = "" + countMines(myRow, myCol);
            }
          } else {
            if (countMines(myRow, myCol) != 0) {
              myLabel = "" + countMines(myRow, myCol);
            }
          }
        }
      }

      if (countMines(myRow, myCol) == 0 && mouseButton != RIGHT) {
        for (int r = myRow - 1; r <= myRow + 1; r++) {
          for (int c = myCol - 1; c <= myCol + 1; c++) {
            if (isValid(r, c) && squares[r][c].isClicked() == false) {
              squares[r][c].mousePressed();
              if (countMines(myRow, myCol) != 0) {
                myLabel = "" + countMines(myRow, myCol);
              }
            }
          }
        }
      }
    }
  }

  public void draw () { 
    if (countMines(myRow, myCol) != 0 && clicked && !mined) {
      myLabel = "" + countMines(myRow, myCol);
    }
    if (mouseX < x+width && mouseX > x && mouseY < y+height && mouseY > y) {
      hovered = true;
    } else { 
      hovered = false;
    }
    noStroke();
    if (hovered && !clicked && GAME_STATE.equals("INPLAY")) { 
      fill(#b9dd77);
    } //hovered color
    else {
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
    if (flagged) { 
      textSize(20);
      fill(255, 0, 0);
    } else if (mined) {
      textSize(15);
      fill(0);
    } else {
      textSize(25);
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
  public void setState(boolean newState) {
    mined = newState;
    clicked = newState;
  }
  public boolean isFlagged()
  {
    return flagged;
  }
  public boolean isClicked() 
  {
    return clicked;
  }
  public int[] getRowAndCol() {
    int[] myRowAndCol = new int[]{myRow, myCol};
    return myRowAndCol;
  }
}
