import de.bezier.guido.*;

//got an if else stairway over here 😳
/*when printing an object via "this", it will look for function toString() to return, otherwise it 
 returns a memory address*/

public final static int NUM_ROWS = 10;
public final static int NUM_COLS = 10;
public final static int NUM_SQUARES = NUM_ROWS * NUM_COLS;
public static int NUM_MINES = (NUM_ROWS*NUM_COLS)/5;
public static String GAME_STATE = "INPLAY"; //SELECT, INPLAY, LOSE, WIN

public static boolean FIRST_CLICK = true;

public static int flagCount = NUM_MINES;

//width and height
public static int w;
public static int h;

private MSButton[][] squares = new MSButton[NUM_ROWS][NUM_COLS]; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList <MSButton>(); //ArrayList of just the minesweeper buttons that are mined
private ArrayList <MSButton> reservedSquares = new ArrayList <MSButton>(); //ArrayList of reserved squares so there can be a safe zone

private retryButton rButt = new retryButton();

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
  //setMines();
}



public void setMines(int row, int col) {
  reservedSquares.add(squares[row][col]);
  int rN = (int)(Math.random()*2)+2;
  int rN2 = (int)(Math.random()*2)+2;
  for (int R = row-rN; R < row+rN2; R++) {
    for (int C = col-rN2; C < col+rN; C++) {
      reservedSquares.add(squares[R][C]); //randomly make surrounding squares reserved
    }
  }
  while (mines.size() < NUM_MINES) {
    int r = (int)(Math.random()*NUM_ROWS);
    int c = (int)(Math.random()*NUM_COLS);
    if (!mines.contains(squares[r][c]) && !reservedSquares.contains(squares[r][c])) { //if this square isn't already a mine
      mines.add(squares[r][c]);
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

  textSize(25);
  fill(255, 0, 0);
  text("|▀", 50, 650);
  fill(255);
  text(flagCount, 100, 650);

  rButt.draw();
}

public class retryButton {
  private boolean hovered = false;
  public retryButton() {
  }

  public void draw() {
    if (GAME_STATE == "LOSE" ||GAME_STATE == "WIN") {
      pushMatrix();
      if (mouseX < 450+120 && mouseX > 450 && mouseY < 625+50 && mouseY > 625) {
        fill(103, 140, 77); 
        hovered = true;
      } else {
        fill(136, 184, 101);
        hovered = false;
      }
      rect(450, 625, 120, 50, 10);
      fill(255);
      textSize(15);
      text("↻ Try Again", 510, 647);
      popMatrix();
    }
  }
  public boolean isHovered() {
    return hovered;
  }
  public void setHovered(boolean newState) {
    hovered = newState; 
  }
}

public void mousePressed() {
  if (mouseButton == LEFT && rButt.isHovered() && (GAME_STATE == "LOSE" ||GAME_STATE == "WIN")) {
      while (mines.size() > 0) {
      mines.remove(mines.size()-1); //clear mines
    }
    while(reservedSquares.size() > 0) {
      reservedSquares.remove(reservedSquares.size()-1); //clear reserved squares 
    }
    for (int r = 0; r < NUM_ROWS; r++) {
      for (int c = 0; c < NUM_COLS; c++) {
        squares[r][c].setClicked(false);
        textSize(25);
        squares[r][c].setLabel("");
        squares[r][c].setState(false);
        flagCount = 20;
      }
    }
    GAME_STATE = "INPLAY";
    FIRST_CLICK = true;
    rButt.setHovered(false);
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
        if (flagged && flagCount > 0) {
          myLabel = "|▀";
          flagCount--;
        } else if (flagged && flagCount <= 0) {
          flagged = !flagged;
        } else if (!flagged) { 
          myLabel = "";
          flagCount++;
        }
      } else if (mouseButton == LEFT && flagged) {
        clicked = false;
      } else if (mouseButton == LEFT && !flagged) {
        if (FIRST_CLICK) {
          setMines(myRow, myCol);
          FIRST_CLICK = false;
        }
        if (!mines.contains(this) && countMines(myRow, myCol) != 0) {
          textSize(25);
          setLabel(countMines(myRow, myCol));
        }
        if (mines.contains(this)) {
          myLabel = "●";
          mined = true;
          GAME_STATE = "LOSE";
        }
      }

      if (countMines(myRow, myCol) == 0 && mouseButton != RIGHT||mouseButton != RIGHT && FIRST_CLICK) {
        for (int r = myRow - 1; r <= myRow + 1; r++) {
          for (int c = myCol - 1; c <= myCol + 1; c++) {
            if (isValid(r, c) && squares[r][c].isClicked() == false) {
              squares[r][c].mousePressed();
              FIRST_CLICK = false;
              if (countMines(myRow, myCol) != 0) {      
                textSize(25);
                myLabel = "" + countMines(myRow, myCol);
              }
            }
          }
        }
      }
    }
  }

  public void draw () { 
    if (countMines(myRow, myCol) != 0 && clicked && !mined && !mines.contains(this)) {
      textSize(25);
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
  public void setClicked(boolean newState) {
    clicked = newState;
    flagged = newState;
    mined = newState;
  }
  public int[] getRowAndCol() {
    int[] myRowAndCol = new int[]{myRow, myCol};
    return myRowAndCol;
  }
}
