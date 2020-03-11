import de.bezier.guido.*;
int NUM_ROWS= 16;
int NUM_COLS = 16;
boolean gameOver = false;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList <MSButton>(); //ArrayList of just the minesweeper buttons that are mined

void setup ()
{
    size(400, 400);
    textAlign(CENTER,CENTER);
    // make the manager
    Interactive.make( this );
    
    //your code to initialize buttons goes hereddd
    buttons = new MSButton [NUM_ROWS] [NUM_COLS];
    for(int i = 0; i < NUM_ROWS; i++)
    {
        for(int e = 0; e < NUM_COLS; e++)
        {
            buttons[i][e] = new MSButton(i, e);
        }
    }
    setMines();
}
public void setMines()
{
    while(mines.size() < 5)
    {
        int r = (int)(Math.random()*NUM_ROWS);
        int c = (int)(Math.random()*NUM_COLS);
        if(!mines.contains(buttons[r][c]))
        {
            mines.add(buttons[r][c]);
        }
    }
}

public void draw ()
{
    background(0);
    if(gameOver == true)
    {
        if(isWon() == true)
        {
            displayWinningMessage();
            noLoop();
        }
        else
        {
            displayLosingMessage();  
            noLoop();  
        }
    }
}
public boolean isWon()
{
    for (int r =0; r< NUM_ROWS; r++) 
    {
        for(int c = 0; c < NUM_COLS; c++)
        {
            if(!mines.contains(buttons[r][c]) && (!buttons[r][c].isClicked() || buttons[r][c].isFlagged()))
            {
                return false;
            }
        }
    }
    return true;
}
public void displayLosingMessage()
{
    textAlign(CENTER, CENTER);
    text("Loser", 200, 200);
}
public void displayWinningMessage()
{
    textAlign(CENTER, CENTER);
    text("Winner!", 200, 200);
}
public boolean isValid(int r, int c)
{
    if(r < NUM_ROWS && r >=0 && c < NUM_COLS && c >= 0)
    {
    return true;
    }
    else
    {
    return false;
    }
}
public int countMines(int row, int col)
{
    int numMines = 0;
    for(int i = row -1; i <= row + 1; i++)
    {
        for(int e = col - 1; e <= col + 1; e++)
        {
            if(isValid(i,e))
            {
                if(mines.contains(buttons[i][e]) == true)
                {
                    numMines++;
                }
            }
        }
    }
    return numMines;
}
public class MSButton
{
    private int myRow, myCol;
    private float x,y, width, height;
    private boolean clicked, flagged;
    private String myLabel;
    
    public MSButton ( int row, int col )
    {
        width = 400/NUM_COLS;
        height = 400/NUM_ROWS;
        myRow = row;
        myCol = col; 
        x = myCol*width;
        y = myRow*height;
        myLabel = "";
        flagged = clicked = false;
        Interactive.add( this ); // register it with the manager
    }

    // called by manager
    public void mousePressed () 
    {
        clicked = true;
        if(mouseButton == RIGHT)
        {
            if(flagged == true)
            {
                flagged = false;
                clicked = false;
            }
            else
            {
                flagged = true;   
            }
        }
        else if(mines.contains(buttons[myRow][myCol]))
        {
            gameOver = true;
        }
        else if(countMines(myRow, myCol) > 0)
        {
            myLabel = "" + countMines(myRow, myCol);
        }
        else
        {
            if(isValid(myRow - 1,myCol - 1) && !buttons[myRow - 1][myCol-1].isClicked())
            {
                buttons[myRow - 1][myCol - 1].mousePressed();
            }
            if(isValid(myRow - 1,myCol) && !buttons[myRow - 1][myCol].isClicked())
            {
                buttons[myRow - 1][myCol].mousePressed();
            }
            if(isValid(myRow - 1,myCol + 1) && !buttons[myRow - 1][myCol+1].isClicked())
            {
                buttons[myRow - 1][myCol + 1].mousePressed();
            }
            if(isValid(myRow,myCol - 1) && !buttons[myRow][myCol-1].isClicked())
            {
                buttons[myRow][myCol - 1].mousePressed();
            }
            if(isValid(myRow,myCol + 1) && !buttons[myRow][myCol+1].isClicked())
            {
                buttons[myRow][myCol + 1].mousePressed();
            }
            if(isValid(myRow + 1,myCol - 1) && !buttons[myRow+1][myCol-1].isClicked())
            {
                buttons[myRow + 1][myCol - 1].mousePressed();
            }
            if(isValid(myRow + 1,myCol) && !buttons[myRow+1][myCol].isClicked())
            {
                buttons[myRow + 1][myCol].mousePressed();
            }
            if(isValid(myRow + 1,myCol + 1) && !buttons[myRow+1][myCol+1].isClicked())
            {
                buttons[myRow + 1][myCol + 1].mousePressed();
            }
        }
        if(isWon())
        {
            gameOver = true;
        }
    }
    public void draw () 
    {    
        if (flagged)
            fill(0);
        else if( clicked && mines.contains(this) ) 
             fill(255,0,0);
        else if(clicked)
            fill( 200 );
        else 
            fill( 100 );

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
    public boolean isClicked()
    {
        return clicked;
    }
}