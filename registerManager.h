// Header file to manage the registers for IR/MIPS code

#include <stdio.h>

#define NUM_REGISTERS 10

struct RegisterManager{
  int registers[NUM_REGISTERS];
};

void initializeRegisterManager(RegisterManager *rm){
	for (int i = 0; i < NUM_REGISTERS; i++){
    rm->registers[i] = 0;
  }
}

int isRegisterInUse(RegisterManager *rm, int r){
	if (r < NUM_REGISTERS && r >= 0){
		if (rm->registers[r]){
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

int getNextAvailableRegister(RegisterManager *rm){
  for (int i = 0; i < NUM_REGISTERS; i++){
    if (!rm->registers[i]){
      rm->registers[r] = 1;
      return r;
    }
  }
  printf("ERROR: NO AVAILABLE REGISTERS\n");
  return -1;
}

void freeRegister(RegisterManager *rm, int r){
  if (r < NUM_REGISTERS && r >= 0){
    rm->registers[r] = 0;
    printf("REGISTER T%d IS NOW AVAILABLE\n", r);
  }
  else{
    printf("INVALID REGISTER: T%d\n", r);
  }
}

void printRegisterStatus(RegisterManager *rm){
  printf(">>>> REGISTER STATUS <<<<\n");

  for (int i = 0; i < NUM_REGISTERS; i++){
    printf("T%d: %s\n", i, rm->registers[i] ? "IN USE" : "AVAILABLE");
