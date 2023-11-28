// Compiler Theory and Design
// Dr. Duane J. Jarc

// This file contains the bodies of the functions that produce the compilation listing

#include <cstdio>
#include <string>

using namespace std;

#include "listing.h"

int lineNumber;
static string error = "";
static int totalErrors = 0;
static int lexicalErrors = 0;
static int syntaxErrors = 0;
static int semanticErrors = 0;

// Function to print the first line number
void firstLine()
{
    lineNumber = 1;
    printf("\n%4d ", lineNumber);
}

// Function to advance to the next line and display errors if any
void nextLine()
{
    // Only print the line number with the error if there's an error for that line
    if (!error.empty()) 
    {
        printf("\r%4d", lineNumber);
        displayErrors();
    }
    lineNumber++;
    printf("%4d ", lineNumber);
    error = ""; // Reset the error string
}

// Function to handle the last line and report compilation status
int lastLine()
{
    // Print the line number and errors if any
    if (!error.empty()) 
    {
        printf("\r%4d", lineNumber);
        displayErrors();
    }

    // Print compilation status
    printf(" \n");
    if (totalErrors == 0) 
    {
        printf("%s\n", "Compiled Successfully!");
    }
    else
    {
        printf("Lexical Errors: %d\n", lexicalErrors);
        printf("Syntax Errors: %d\n", syntaxErrors);
        printf("Semantic Errors: %d\n", semanticErrors);
    }
    return totalErrors;
}

// Function to add an error message to the list of errors
void appendError(ErrorCategories errorCategory, string message)
{
    string messages[] = { "Lexical Error, Invalid Character ", "",
                          "Semantic Error, ", "Semantic Error, Duplicate Identifier: ",
                          "Semantic Error, Undeclared " };

    // Append error message to the error string
    error += "\n" + messages[errorCategory] + message;

    // Update the error counts based on the type of error
    if (errorCategory == LEXICAL)
    {
        lexicalErrors++;
    }
    else if (errorCategory == SYNTAX)
    {
        syntaxErrors++;
    }
    else if (errorCategory >= GENERAL_SEMANTIC && errorCategory <= UNDECLARED)
    {
        semanticErrors++;
    }
    totalErrors++;
}

// Function to display the current list of errors
void displayErrors()
{
    if (!error.empty())
    {
        printf("%s\n", error.c_str());
    }
}
