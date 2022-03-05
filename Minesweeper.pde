import de.bezier.guido.*;
public final static int NUM_COLS = 25;
public final static int NUM_ROWS = 25;
public final static int NUM_MINES = 75;
public boolean flag;
public int count;
private MSButton[][] buttons; // 2d array of minesweeper buttons
private ArrayList <MSButton> mines; // ArrayList of just the minesweeper buttons that are mined

void setup() {
  size(400, 400);
  textAlign(CENTER, CENTER);

  // make the manager
  Interactive.make(this);

  // your code to initialize buttons goes here
  buttons = new MSButton[NUM_ROWS][NUM_COLS];
  for (int e = 0; e < NUM_ROWS; e++) {
    for (int t = 0; t < NUM_COLS; t++) {
       buttons[e][t] = new MSButton(e, t);
    }
  }

  flag = true;
  count = 0;
  mines = new ArrayList <MSButton>();
  setMines();
}

public void setMines() {
  for(int e = 0; e < NUM_MINES; e++) {
    int rm = (int)(Math.random() * NUM_ROWS);
    int cm = (int)(Math.random() * NUM_COLS);
    if (!mines.contains(buttons[rm][cm])) {
      mines.add(buttons[rm][cm]);
    } else {
      e--;
    }
  }
}

public void draw() {
  if(isWon()) {
    displayWinningMessage();
  }
}

public boolean isWon() {
    return !(count < ((NUM_ROWS * NUM_COLS) - NUM_MINES));
}

public void displayLosingMessage() {
    gameOver();
    buttons[24][0].setLabel("L");
    buttons[24][1].setLabel("O");
    buttons[24][2].setLabel("L");
    buttons[24][4].setLabel("U");
    buttons[24][6].setLabel("S");
    buttons[24][7].setLabel("U");
    buttons[24][8].setLabel("C");
    buttons[24][9].setLabel("K");
}

public void displayWinningMessage() {
    gameOver();
    buttons[24][0].setLabel("C");
    buttons[24][1].setLabel("O");
    buttons[24][2].setLabel("N");
    buttons[24][3].setLabel("G");
    buttons[24][4].setLabel("A");
    buttons[24][6].setLabel("R");
    buttons[24][7].setLabel("A");
    buttons[24][8].setLabel("T");
    buttons[24][9].setLabel("S");
    buttons[24][10].setLabel("!");
    buttons[24][11].setLabel("!");
}

public void gameOver() {
  for (int e = 0; e < NUM_ROWS; e++) {
    for (int t = 0; t < NUM_COLS; t++) {
      buttons[e][t].gameOver();
    }
  }
}

public boolean isValid(int r, int c) {
    return (r < NUM_ROWS && r >= 0 && c < NUM_COLS && c >= 0);
}

public int countMines(int r, int c) {
  int numMines = 0;
  for (int e = r - 1; e <= r + 1; e++) {
    for (int t = c - 1; t <= c + 1; t++) {
      if (isValid(e, t) && mines.contains(buttons[e][t])) {
        numMines++;
      }
    }
  }
  return numMines;
}

public class MSButton {
  private float x, y, width, height;
  private boolean clicked, flagged, game, clickable;
  private String myLabel;
  private int myRow, myCol;

  public MSButton (int r, int c) {
    width = 400 / NUM_COLS;
    height = 400 / NUM_ROWS;
    myRow = r;
    myCol = c;
    x = c * width;
    y = r * height;
    myLabel = "";
    flagged = clicked = false;
    game = clickable = true;
    Interactive.add(this); // register it with the manager
  }

  // called by manager
  public void mousePressed() {
    if (flag && mines.contains(this)) {
      for (int e = mines.size() - 1; e >= 0; e--) {
        mines.remove(e);
      }
      setMines();
    }

    if (flag && countMines(myRow, myCol) > 0) {
      if (countMines(myRow, myCol) > 0) {
        for(int i = mines.size() - 1; i >= 0; i--){
          mines.remove(i);
        }
        setMines();
      }
    }

    if (game && clickable) {
      flag = false;
      clicked = true;
      if (keyPressed || mouseButton == RIGHT) {
        if (flagged) {
          flagged = false;
          clicked = false;
        } else {
          flagged = true;
        }
      } else if (mines.contains(this)) {
        displayLosingMessage();
      } else if (countMines(myRow, myCol) > 0) {
        clickable = false;
        count++;
        setLabel(countMines(myRow, myCol));
      } else {
        clickable = false;
        count++;
        for (int e = -1; e <= 1; e++) {
          for (int t = -1; t <= 1; t++) {
            if (isValid(myRow + e, myCol + t) && buttons[myRow + e][myCol + t].checkClicked()) {
              buttons[myRow + e][myCol + t].mousePressed();
            }
          }
        }
      }
    }
  }

  public void draw() {
    if (flagged) {fill(0);}
    else if (clicked && mines.contains(this)) {fill(255, 0, 0);}
    else if (clicked) {fill(200);}
    else {fill(100);}
    rect(x, y, width, height);
    fill(0);
    text(myLabel, x + width / 2, y + height / 2);
  }

  public void setLabel(String newLabel) {
    myLabel = newLabel;
  }

  public void setLabel(int newLabel) {
    myLabel = "" + newLabel;
  }
