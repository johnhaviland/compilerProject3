// Header file that creates symbol table
#include <string.h>
#include <stdio.h>

struct funcEntry{
	int itemID;
	char itemName[50];
	char itemKind[8];
	char itemType[8];
	int arrayLength;
	int itemVal;
	char scope[];
};

struct funcEntry funcSymTabItems[100];

int funcSymTabIndex = 0;
int FUNC_SYMTAB_SIZE = 10;

void funcSymTabAccess(void){
	printf(">>>> FUNCTION SYMBOL TABLE ACCESSED <<<<\n");
}

void funcAddItem(char itemName[50], char itemKind[8], char itemType[8], int arrayLength, char scope[]){
		funcSymTabItems[funcSymTabIndex].itemID = funcSymTabIndex;
		strcpy(funcSymTabItems[funcSymTabIndex].itemName, itemName);
		strcpy(funcSymTabItems[funcSymTabIndex].itemKind, itemKind);
		strcpy(funcSymTabItems[funcSymTabIndex].itemType, itemType);
		funcSymTabItems[funcSymTabIndex].itemVal = 0;
		funcSymTabItems[funcSymTabIndex].arrayLength = arrayLength;
		strcpy(funcSymTabItems[funcSymTabIndex].scope, scope);
		funcSymTabIndex++;
}

int setFuncValue(char itemName[50], int itemVal, char scope[50]){
	for (int i = 0; i < FUNC_SYMTAB_SIZE; i++){
		int str1 = strcmp(funcSymTabItems[i].itemName, itemName); 
		int str2 = strcmp(funcSymTabItems[i].scope,scope); 
		
		if (str1 == 0 && str2 == 0){
			funcSymTabItems[i].itemVal = itemVal;
			return 1;
		}
	}
		
	return 0;
}

void showFuncSymTable(){
	printf("funcID    funcName    funcKind    funcType     ArrayLength    funcScope\n");
	printf("=====================================================================\n");
	
	for (int i = 0; i < funcSymTabIndex; i++){
		printf("%5d %15s  %7d  %7s %7s %6d %15s \n", funcSymTabItems[i].itemID, funcSymTabItems[i].itemName, funcSymTabItems[i].itemVal, funcSymTabItems[i].itemKind, funcSymTabItems[i].itemType, funcSymTabItems[i].arrayLength, funcSymTabItems[i].scope);
	}
	
	printf("=====================================================================\n");
}

int funcFound(char itemName[50], char scope[]){
	for(int i = 0; i < FUNC_SYMTAB_SIZE; i++){
		int str1 = strcmp(funcSymTabItems[i].itemName, itemName); 
		int str2 = strcmp(funcSymTabItems[i].scope,scope); 
		
		if (str1 == 0 && str2 == 0){
			return 1;
		} 
	}
	
	return 0;
}


int getFuncValue(char itemName[50],char scope[]){
	int returnNum;
	
	for(int i = 0; i < FUNC_SYMTAB_SIZE; i++){
		int str1 = strcmp(funcSymTabItems[i].itemName, itemName); 
		int str2 = strcmp(funcSymTabItems[i].scope,scope); 

		if(str1 == 0 && str2 == 0){
			returnNum = funcSymTabItems[i].itemVal;
			return funcSymTabItems[i].itemVal;
		}
	}

	return 0;
}

void printFuncVal(){
	for(int i = 0; i < 4; i++) {
		printf("%7d\n", funcSymTabItems[i].itemVal);
	}
}

int getFuncID(char itemName[50],char scope[]){
	int returnID;

	for(int i = 0; i < FUNC_SYMTAB_SIZE; i++){
		int str1 = strcmp(funcSymTabItems[i].itemName, itemName); 
		int str2 = strcmp(funcSymTabItems[i].scope,scope); 
		
		if( str1 == 0 && str2 == 0){
			returnID = (int)(funcSymTabItems[i].itemID) + 0;
			return returnID;
		}
	}
	
	return 0;
}

const char* getFuncVariableType(char itemName[50], char scope[]){
	for(int i = 0; i < FUNC_SYMTAB_SIZE; i++){
		int str1 = strcmp(funcSymTabItems[i].itemName, itemName); 
		int str2 = strcmp(funcSymTabItems[i].scope,scope); 

		if( str1 == 0 && str2 == 0){
			return funcSymTabItems[i].itemType;
		}
	}
	
	return NULL;
}

int compareFuncTypes(char itemName1[50], char itemName2[50],char scope[]){
	const char* idType1 = getFuncVariableType(itemName1, scope);
	const char* idType2 = getFuncVariableType(itemName2, scope);
	
	printf("%s = %s\n", idType1, idType2);
	
	int typeMatch = strcmp(idType1, idType2);
	
	if(typeMatch == 0){
		return 1; 
	}
		
	else return 0;
}
