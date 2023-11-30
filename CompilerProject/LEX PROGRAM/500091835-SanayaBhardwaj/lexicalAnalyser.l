/*Implemenatation of Lexical Analyser for C Language*/
/*Program identifies tokens to be returned by the scanner*/
/*Also stores the values in Symbol Table*/
/*Program also identifies errors in C file*/

%{
int lineno = 1;
#include<stdio.h>
#include<stdlib.h>
#include<string.h>

#define Automation 1
#define Breakpoint 2
#define Situation 3
#define Unicode 4
#define Immutable 5
#define Endless 6
#define Predesigned 7
#define Perform 8
#define Twice 9
#define Alternatively 10
#define Enumeration 11
#define External 12
#define Decimal 13
#define Loop 14
#define Jump 15
#define Conditional 16
#define Countable 17
#define Extended 18
#define Memory 19
#define Exit 20
#define Small  21
#define Signed 22
#define Capacity 23
#define Fixed 24
#define Structure 25
#define Select 26
#define Alias 27
#define Shared 28
#define NonNegative 29
#define Empty 30
#define Unpredictable 31
#define Repeat 32

#define Name 33
#define SingleNote 34
#define Multinote 35
#define Multinoteclose 36

#define LessEqual 37
#define GreaterEqual 38
#define Alike 39
#define Unlike 40
#define Otherwise 41
#define Likewise 42
#define Allocate 43
#define Total 44
#define Below 45
#define Many 46
#define Split 47
#define Remainder 48
#define Lower 49
#define Higher 50
#define Raise 51
#define Reduce 52

#define Separator 53
#define Partial 54

#define Label 55
#define Major 56

#define Printf 57
#define Scanf 58
#define Describe 59

#define IntConst 60
#define FloatConst 61

#define TypeSpec 62

#define DQ 63

#define OBO 64
#define OBC 65
#define CBO 66
#define CBC 67
#define HASH 68

#define ARR 69
#define FUNC 70

#define NumErr 71
#define UNKNOWN 72

#define CharConst 73
#define SignedConst 74
#define StringConst 75
%}

alpha [A-Za-z]
digit [0-9]
und [_]
space [ ]
tab [	]
line [\n]
char \'.\'
at [@]
string \"(.^([%d]|[%f]|[%s]|[%c]))\"

%%
{space}* {}
{tab}* {}
{string} return StringConst;
{char} return CharConst;
{line} {lineno++;}
auto return Automation;
break return Breakpoint;
case return Situation;
char return Unicode;
const return Immutable;
continue return Endless;
default return Predesigned;
do return Perform;
double return Twice;
else return Alternatively;
enum return Enumeration;
extern return External;
float return Decimal;
for return Loop;
goto return Jump;
if return Conditional;
int return Countable;
long return Extended;
register return Memory;
return return Exit;
short return Small;
signed return Signed;
sizeof return Capacity;
static return Fixed;
struct return Structure;
switch return Select;
typedef return Alias;
union return Shared;
unsigned return NonNegative;
void return Empty;
volatile return Unpredictable;
while return Repeat;

printf return Printf;
scanf return Scanf;

{alpha}({alpha}|{digit}|{und})* return Name;

[+-][0-9]{digit}*(\.{digit}+)? return SignedConst;

"//" return SingleNote;
"/*" return Multinote;
"*/" return Multinoteclose;

"<=" return LessEqual;
">=" return GreaterEqual;
"==" return Alike;
"!=" return Unlike;
"||" return Otherwise;
"&&" return Likewise;
"=" return Allocate;
"+" return Total;
"-" return Below;
"*" return Many;
"/" return Split;
"%" return Remainder;
"<" return Lower;
">" return Higher;
"++" return Raise;
"--" return Reduce;

"," return Separator;
";" return Partial;

"#include<stdio.h>" return Label;
"#include <stdio.h>" return Label;
"#include <math.h>" return Label;
"#include<math.h>" return Label;
"#include <stdlib.h>" return Label;
"#include<stdlib.h>" return Label;
"#include <string.h>" return Label;
"#include<strng.h>" return Label;

"main()" return Major;

{digit}+ return IntConst;
({digit}+)\.({digit}+) return FloatConst;

"%d"|"%f"|"%u"|"%s" return TypeSpec;
"\"" return DQ;
"(" return OBO;
")" return OBC;
"{" return CBO;
"}" return CBC;
"#" return HASH;

{alpha}({alpha}|{digit}|{und})*\[{digit}*\] return ARR;
{alpha}({alpha}|{digit}|{und})*\(({alpha}|{digit}|{und}|{space})*\) return FUNC;
({digit}+)\.({digit}+)\.({digit}|\.)* return NumErr;
({digit}|{at})+({alpha}|{digit}|{und}|{at})* return UNKNOWN;
%%

struct node
{
	char token[100];
    	char attr[100];
	struct node *next;
};

struct hash
{
	struct node *head;
	int count;
};

struct hash hashTable[1000];
int eleCount = 1000;

struct node * createNode(char *token, char *attr)
{
	struct node *newnode;
	newnode = (struct node *) malloc(sizeof(struct node));
	strcpy(newnode->token, token);
	strcpy(newnode->attr, attr);
	newnode->next = NULL;
	return newnode;
}

int hashIndex(char *token)
{
	int hi=0;
	int l,i;
	for(i=0;token[i]!='\0';i++)
	{
		hi = hi + (int)token[i];
	}
	hi = hi%eleCount;
	return hi;
}

void hashInsert(char *token, char *attr)
{
	int flag=0;
	int hi;
	hi = hashIndex(token);
	struct node *newnode = createNode(token, attr);
	/* head of list for the bucket with index "hashIndex" */
	if (hashTable[hi].head==NULL)
	{
		hashTable[hi].head = newnode;
	        hashTable[hi].count = 1;
	        return;
	}
	struct node *myNode;
    	myNode = hashTable[hi].head;
	while (myNode != NULL)
    	{
        	if (strcmp(myNode->token, token)==0)
        	{
            		flag = 1;
            		break;
        	}
        	myNode = myNode->next;
    	}
	if(!flag)
	{
		//adding new node to the list
		newnode->next = (hashTable[hi].head);
		//update the head of the list and no of nodes in the current bucket
		hashTable[hi].head = newnode;
		hashTable[hi].count++;
	}
	return;
}

void display()
{
    	struct node *myNode;
    	int i,j, k=1;
    	printf("-------------------------------------------------------------------");
    	printf("\nSNo \t|\tToken \t\t|\tToken Type \t\n");
        printf("-------------------------------------------------------------------\n");
    	for (i = 0; i < eleCount; i++)
    	{
        	if (hashTable[i].count == 0)
            		continue;
        	myNode = hashTable[i].head;
        	if (!myNode)
            		continue;
        	while (myNode != NULL)
        	{
            		printf("%d\t\t", k++);
            		printf("%s\t\t\t", myNode->token);
            		printf("%s\t\n", myNode->attr);
            		myNode = myNode->next;
        	}
	}
   	return;
}

int main()
{
	int scan, slcline=0, mlc=0, mlcline=0, dq=0, dqline=0;
	yyin = fopen("test6.c","r");
	printf("\n\n");
	scan = yylex();
	while(scan)
	{
		if(lineno == slcline)
		{
			scan = yylex();
			continue;
		}
		if(lineno!=dqline && dqline!=0)
		{
			if(dq%2!=0)
				printf("\n<<<<<<<<<< ERROR! >>>>>>>>>> \n<<<<<<<<<<INCOMPLETE STRING at Line %d >>>>>>>>>>\n\n", dqline);
			dq=0;
		}
		if((scan>=1 && scan<=32) && mlc==0)
		{
			printf("%s\t\t\tKEYWORD\t\t\t\tLine %d\n", yytext, lineno);
			hashInsert(yytext, "KEYWORD");
		}
		if(scan==33 && mlc==0)
		{
			printf("%s\t\t\tIDENTIFIER\t\t\tLine %d\n", yytext, lineno);
			hashInsert(yytext, "IDENTIFIER");
		}
		if(scan==34)
		{
			printf("%s\t\t\tSingleline Comment\t\tLine %d\n", yytext, lineno);
			slcline = lineno;
		}
		if(scan==35 && mlc==0)
		{
			printf("%s\t\t\tMultiline Comment Start\t\tLine %d\n", yytext, lineno);
			mlcline = lineno;
			mlc = 1;
		}
		if(scan==36 && mlc==0)
		{
			printf("\n<<<<<<<<<< ERROR! >>>>>>>>>> \n<<<<<<<<<<UNMATCHED MULTILINE COMMENT END %s at Line %d >>>>>>>>>>\n\n", yytext, lineno);
		}
		if(scan==36 && mlc==1)
		{
			mlc = 0;
			printf("%s\t\t\tMultiline Comment End\t\tLine %d\n", yytext, lineno);
		}
		if((scan>=37 && scan<=52) && mlc==0)
		{
			printf("%s\t\t\tOPERATOR\t\t\tLine %d\n", yytext, lineno);
			hashInsert(yytext, "OPERATOR");
		}
		if((scan==53||scan==54||scan==63||(scan>=64 && scan<=68)) && mlc==0)
		{
			printf("%s\t\t\tSPECIAL SYMBOL\t\t\tLine %d\n", yytext, lineno);
			if(scan==63)
			{
				dq++;
				dqline = lineno;
			}
			hashInsert(yytext, "SPECIAL SYMBOL");
		}
		if(scan==55 && mlc==0)
		{
			printf("%s\tHEADER\t\t\t\tLine %d\n",yytext, lineno);
		}
		if(scan==56 && mlc==0)
		{
			printf("%s\t\t\tMAIN FUNCTION\t\t\tLine %d\n", yytext, lineno);
			hashInsert(yytext, "IDENTIFIER");
		}
		if((scan==57 || scan==58) && mlc==0)
		{
			printf("%s\t\t\tPRE DEFINED FUNCTION\t\tLine %d\n", yytext, lineno);
			hashInsert(yytext, "PRE DEFINED FUNCTION");
		}
		if(scan==59 && mlc==0)
		{
			printf("%s\t\t\tPRE PROCESSOR DIRECTIVE\t\tLine %d\n", yytext, lineno);
		}
		if(scan==60 && mlc==0)
		{
			printf("%s\t\t\tINTEGER CONSTANT\t\tLine %d\n", yytext, lineno);
			hashInsert(yytext, "INTEGER CONSTANT");
		}
		if(scan==61 && mlc==0)
		{
			printf("%s\t\t\tFLOATING POINT CONSTANT\t\tLine %d\n", yytext, lineno);
			hashInsert(yytext, "FLOATING POINT CONSTANT");
		}
		if(scan==62 && mlc==0)
		{
			printf("%s\t\t\tTYPE SPECIFIER\t\t\tLine %d\n", yytext, lineno);
		}
		if(scan==69 && mlc==0)
		{
			printf("%s\t\t\tARRAY\t\t\t\tLine %d\n", yytext, lineno);
			hashInsert(yytext, "ARRAY");
		}
		if(scan==70 && mlc==0)
		{
			printf("%s\t\t\tUSER DEFINED FUNCTION\t\tLine %d\n", yytext, lineno);
			hashInsert(yytext, "USER DEFINED FUNCTION");
		}
		if(scan==71 && mlc==0)
		{
			printf("\n<<<<<<<<<< ERROR! >>>>>>>>>> \n<<<<<<<<<<CONSTANT ERROR %s at Line %d >>>>>>>>>>\n\n", yytext, lineno);
		}
		if(scan==72 && mlc==0)
		{
			printf("\n<<<<<<<<<< ERROR! >>>>>>>>>> \n<<<<<<<<<<UNKNOWN TOKEN %s at Line %d >>>>>>>>>>\n\n", yytext, lineno);
		}
		if(scan==73 && mlc==0)
		{
			printf("%s\t\t\tCHARACTER CONSTANT\t\t\tLine %d\n", yytext, lineno);
			hashInsert(yytext, "CHARACTER CONSTANT");
		}
		if(scan==74 && mlc==0)
		{
			printf("%s\t\t\tSIGNED CONSTANT\t\t\tLine %d\n", yytext, lineno);
			hashInsert(yytext, "SIGNED CONSTANT");
		}
		if(scan==75 && mlc==0)
		{
			printf("%s\t\t\tSTRING CONSTANT\t\t\tLine %d\n", yytext, lineno);
			hashInsert(yytext, "STRING CONSTANT");
		}
		scan = yylex();
	}
	if(mlc==1)
		printf("\n<<<<<<<<<< ERROR! >>>>>>>>>> \n<<<<<<<<<<UNMATCHED COMMENT STARTING at Line %d >>>>>>>>>>\n\n",mlcline);
	printf("\n");
	printf("\n\t############## SYMBOL TABLE ##############\t\t\n");
	display();
        printf("-------------------------------------------------------------------\n\n");
}
int yywrap()
{
	return 1;
}
