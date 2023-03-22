/*
Colton Willits
Dr. Graham
CSC314
This is a C program that resembles the desired output of multicase.asm. This program was build using
gcc and the output executeable from this program is a.out. This is not fully representational of 
how the assembly works other than the comparision. No pointers were used.
*/

#include <stdio.h>

void test(){
    printf("Guess a number between 1 and 10\n");
    int x;
    scanf("%d", &x);
    //check if exiting program
    if(x == 0){
        printf("Exiting \n");
        return;
    }
    int cmp = x - 7; //this simulates the cmp flag by checking if higher or lower than 0 for the desired number
    if(cmp == 0){
        printf("Correct the number is 7\n");
        return;
    }else if (cmp > 0)
    {
        printf("Try a number thats lower\n");
        test();
    }else{
        //Last case will be cmp < 0 no need for if statement
        printf("Try a number thats higher\n");
        test();
    }
    return;
}


int main(){
    printf("Guess a number between 1 and 10, enter 0 to exit the program respectfully\n If number is guessed correctly program with automatically exit \n");
    test();
    return 0;
}

