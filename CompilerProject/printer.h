/* CODENEX - Created by Sanaya Bhardwaj  */

#include "printerDef.h"

Queue* createQueue();
node* createNodee(ASTNode* n, int depth,char* parent);
void enqueue(Queue* q,ASTNode* v,int depth,char* parent);
node* dequeue(Queue* q);
int isEmptyQ(Queue* q);
void levelPrint(ASTNode* root);
void printSymbolEntryList(SymbolEntry* ls, int isGlobalTable);
void printSymbolTableHelper(SymbolTable* scopedTable);
void printSymbolTable(SymbolTable* st,int isGlobalTable);
void printGlobals(SymbolTable* st);
void printFunctions(SymbolTable* st);
void printRecords(SymbolTable* st);
