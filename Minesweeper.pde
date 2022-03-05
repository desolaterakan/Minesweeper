import de.bezier.guido.*;
public final static int NUM_COLS = 25;
public final static int NUM_ROWS = 25;
public final static int NUM_MINES = 75;
public boolean firstClick;
public int minedCount;
private MSButton[][] buttons; // 2d array of minesweeper buttons
private ArrayList <MSButton> mines; // ArrayList of just the minesweeper buttons that are mined

void setup ()
{
    size(400, 400);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make(this);
    
    //your code to initialize buttons goes here
    buttons = new MSButton[NUM_ROWS][NUM_COLS];

    for(int e = 0; e < NUM_ROWS; e++){
        for(int t = 0; t < NUM_COLS; t++){
            buttons[e][t] = new MSButton(e, t);
        }
    }

    firstClick = true;
    minedCount = 0;

    mines = new ArrayList <MSButton>();
    
    setMines();
}

public void setMines(int r, int c)
{
    for(int e = 0; e < NUM_MINES; e++){
        int row = (int)(Math.random()*NUM_ROWS);
        int col = (int)(Math.random()*NUM_COLS);
        if(!mines.contains(buttons[row][col])){
            mines.add(buttons[row][col]);
        }else{
            i--;
        }
    }
}
public void setMines()
{
    for(int e = 0; e < NUM_MINES; e++){
        int row = (int)(Math.random()*NUM_ROWS);
        int col = (int)(Math.random()*NUM_COLS);
        if(!mines.contains(buttons[row][col])){
            mines.add(buttons[row][col]);
        }
    }
}
public void draw ()
{
    background( 0 );
    if(isWon() == true)
        displayWinningMessage();
}
public boolean isWon()
{
    return !(minedCount < ((NUM_ROWS * NUM_COLS) - NUM_MINES));
}
public void displayLosingMessage()
{
    gameOver();
    buttons[0][0].setLabel("Y");
    buttons[0][1].setLabel("O");
    buttons[0][2].setLabel("U");
    buttons[0][3].setLabel(" ");
    buttons[0][4].setLabel("L");
    buttons[0][5].setLabel("O");
    buttons[0][6].setLabel("S");
    buttons[0][7].setLabel("E");
}
public void displayWinningMessage()
{
    gameOver();
    buttons[0][0].setLabel("Y");
    buttons[0][1].setLabel("O");
    buttons[0][2].setLabel("U");
    buttons[0][3].setLabel(" ");
    buttons[0][4].setLabel("W");
    buttons[0][5].setLabel("I");
    buttons[0][6].setLabel("N");
}
public void gameOver() {
    for(int e = 0; e < NUM_ROWS; e++){
        for(int t = 0; t < NUM_COLS; t++){
            buttons[e][t].gameOver();
        }
    }
}
public boolean isValid(int r, int c)
{
    return r < NUM_ROWS && r >= 0 && c < NUM_COLS && c >= 0;
}
public int countMines(int row, int col)
{
    int numMines = 0;

    for(int e = row - 1; e <= row + 1; e++){
        for(int t = col - 1; t <= col + 1; t++){
            if(isValid(e, t) && mines.contains(buttons[e][t])){
                numMines++;
            }
        }
    }

    return numMines;
}
public class MSButton
{
    private int myRow, myCol;
    private float x,y, width, height;
    private boolean clicked, flagged, game, clickable;
    private String myLabel;
    
    public MSButton (int row, int col)
    {
        width = 400/NUM_COLS;
        height = 400/NUM_ROWS;
        myRow = row;
        myCol = col; 
        x = myCol*width;
        y = myRow*height;
        myLabel = "";
        flagged = clicked = false;
        game = clickable = true;
        Interactive.add( this ); // register it with the manager
    }

    // called by manager
    public void mousePressed() 
    {
        if(firstClick && mines.contains(this)){
            for(int e = mines.size() - 1; e >= 0; e--){
                mines.remove(i);
            }
            setMines(myRow, myCol);
        }
        if(firstClick && countMines(myRow, myCol) > 0){
            while (countMines(myRow, myCol) > 0){
                for(int e = mines.size() - 1; e >= 0; i--){
                    mines.remove(i);
                }
                setMines(myRow, myCol);
            }
        }
        if(game && clickable){
            firstClick = false;
            clicked = true;
            if(keyPressed || mouseButton == RIGHT){
                if(flagged){
                    flagged = false;
                    clicked = false;
                }else{
                    flagged = true;
                }
            }else if(mines.contains(this)){
                displayLosingMessage();
            }else if(countMines(myRow, myCol) > 0){
                clickable = false;
                minedCount++;
                setLabel(countMines(myRow, myCol));
            }else{
                clickable = false;
                minedCount++;
                for(int e = -1; e <= 1; e++){
                    for(int t = -1; t <= 1; t++){
                        if(isValid(myRow + e, myCol + t) && buttons[myRow + e][myCol + t].checkClicked()){
                            buttons[myRow + e][myCol + t].mousePressed();
                        }
                    }
                }
            }
        }
    }
    public void draw () 
    {    
        if (flagged)
            fill(0);
        else if( clicked && mines.contains(this) ) 
            fill(255,0,0);
        else if(clicked)
            fill(200);
        else 
            fill(100);

        rect(x, y, width, height);
        fill(0);
        text(myLabel,x+width/2,y+height/2);
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
    public boolean checkClicked() {
        return !clicked;
    }
    public void gameOver() {
        game = false;
    }
}
