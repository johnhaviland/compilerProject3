// Header file to create IR code
#include <stdio.h>
FILE * IRcode;
int numbers[10];
int index = 0;

void initIRcodeFile(){
    IRcode = fopen("IRcode.ir", "w");
    fprintf(IRcode, "\n\n#### IR Code ####\n\n");
    fclose(IRcode);
}

void emitBinaryOperation(char op[1], const char* id1, const char* id2){
    fprintf(IRcode, "T1 = %s %s %s", id1, op, id2);
    fclose(IRcode);
}

void emitAssignment(char * id1, char * id2){

  fprintf(IRcode, "T0 = %s\n", id1);
  fprintf(IRcode, "T1 = %s\n", id2);
  fprintf(IRcode, "T1 = T0\n");
  fclose(IRcode);
}

void emitConstantIntAssignment (char id1[50], int id2[50]){
    IRcode = fopen("IRcode.ir", "a");
    fprintf(IRcode, "T%d = %s\n", id2, id1);
    fclose(IRcode);
}

void emitIR(char id1[50], char id2[50],int currentScope[50]){
    IRcode = fopen("IRcode.ir", "a");
    fprintf(IRcode, "T%d = %s\n", currentScope, id2);
    fclose(IRcode);
}

void emitWriteId(char * id){
    fprintf (IRcode, "output %s\n", "T2");
    fclose(IRcode);
}

void addNumbers(int num){
    numbers[index] = num;
    index++;
}

int sumOfNumbers(){
    int sum = 0;
    for (int i = 0; i < 50; i++){
        sum += numbers[i];
        numbers[i] = 0;
    }
    
    return sum;
}
