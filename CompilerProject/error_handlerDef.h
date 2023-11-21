/* CODENEX - Created by Sanaya Bhardwaj  */

#ifndef ERROR_HANDLER_
#define ERROR_HANDLER_

#include "lexerDef.h"

#define ERROR_MAX_LENGTH 100


// The struct stores the error and it's error message in a linked list
typedef struct Error {
    int LINE_NUMBER;
    int ITERATIVE_LINE_END; // Field to store the line in which the while loop ends
    char* ERROR_MESSAGE;
    struct Error* next;
} Error;

typedef struct ErrorList {
    Error* head;
    Error* tail;
    int MESSAGE_MAX_LENGTH;
} ErrorList;


#endif
