#include <stdio.h>
#include <string.h>

extern int  _sumAndPrintList(int *list, int length);

extern int _replaceChar(char *str, char oldChar, char newChar);

int main() {
    int list[1000];
    int num;
    int count = 0;

    printf("Please input up to 1000 numbers, enter 'done' when finished:\n");

    while (scanf("%d", &num) == 1 && count < 1000)
    {
        if(num == "done"){
            break;
        }
        list[count++] = num;
    }

    int sum = _sumAndPrintList(list, count);
    printf("The sum of the list is: %d\n", sum);
    printf("----------------------------------------------------\n");

    char line[1000];
    int totalReplaced = 0;
    while (1)
    {
        printf("Enter a line of text (or a blank line to quit): ");
        fgets(line, 1000, stdin);
        if (strlen(line) == 1)
        {
            break;
        }

        char oldChar, newChar;
        printf("Enter a character to replace: ");
        scanf("%c", &oldChar);
        getchar(); //consumes newline char

        printf("Enter a replacement character: ");
        scanf("%c", &newChar);
        getchar();

        int numReplaced = _replaceChar(line, oldChar, newChar);
        totalReplaced += numReplaced;
        printf("Modified line: %s", line);
    }

    printf("Total number of spaces replaced: %d\n", totalReplaced);
    printf("Goodbye! \n");
    return 0;
}
