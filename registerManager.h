// Header file to manage the registers for IR/MIPS code
#include <stdio.h>

#define NUM_REGISTERS 10

int registers[NUM_REGISTERS];

void initializeRegisterManager(){
	for (int i = 0; i < NUM_REGISTERS; i++){
    registers[i] = 0;
  }
}

int isRegisterInUse(int r){
	if (r < NUM_REGISTERS && r >= 0){
		if (registers[r]){
			printf("REGISTER T%d IS IN USE\n", r);
      return 1;
    } 
    else{
      printf("REGISTER T%d IS NOT IN USE\n", r);
      return 0;
    }
  }
  else{
    printf("INVALID REGISTER: T%d\n", r);
    return -1;
  }
}

int getNextAvailableRegister(){
  for (int i = 0; i < NUM_REGISTERS; i++){
    if (!registers[i]){
      registers[i] = 1;
      return i;
    }
  }
  printf("ERROR: NO AVAILABLE REGISTERS\n");
  return -1;
}

void freeRegister(int r){
  if (r < NUM_REGISTERS && r >= 0){
    registers[r] = 0;
    printf("REGISTER T%d IS NOW AVAILABLE\n", r);
  }
  else{
    printf("INVALID REGISTER: T%d\n", r);
  }
}

void printRegisterStatus(){
  printf(">>>> REGISTER STATUS <<<<\n");

  for (int i = 0; i < NUM_REGISTERS; i++){
    printf("T%d: %s\n", i, registers[i] ? "IN USE" : "AVAILABLE");
  }
}
