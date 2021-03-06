#include <stdio.h>
#include <time.h>
#include <unistd.h>
#include <iostream>
#include <fstream>
#include <stdlib.h> 
#include <math.h>
#include "irs3BControlClass.h"
#include "irs3BDataClass.h"
#include "TApplication.h"

using namespace std;

//global TApplication object declared here for simplicity
TApplication *theApp;

int main(int argc, char* argv[]){
	if (argc != 4) {
		cout << "irs3BControl_measureTriggerThresholds <rowNum> <colNum> <chNum> " << endl;
		return 1;
	}

	int rowNum = atoi(argv[1]);
        if( rowNum < 0 || rowNum > 3 ){
                std::cout << "Invalid row number requested, exiting" << std::endl;
                return 0;
        }

	int colNum = atoi(argv[2]);
        if( colNum < 0 || colNum > 3 ){
                std::cout << "Invalid col number requested, exiting" << std::endl;
                return 0;
        }

	int chNum = atoi(argv[3]);
        if( chNum < 0 || chNum > 7 ){
                std::cout << "Invalid ch number requested, exiting" << std::endl;
                return 0;
        }

	//define application object
	theApp = new TApplication("App", &argc, argv);

	//create irs3b interface object
	irs3BControlClass *control = new irs3BControlClass();

	//initialize USB interface - Mandatory
	control->initializeUSBInterface();

	//define the SCROD ID for board stack, hardcoded for now
	unsigned int board_id = 0x0;
	int regValReadback;

	//write Trigger interfaces register to specify ASIC of interest
	int trigInterfacesRegVal = (0x8000 | ((colNum & 0x3) << 2) | (rowNum & 0x3) );
	if( !control->registerWriteReadback(board_id, 4, trigInterfacesRegVal, regValReadback) )
		std::cout << "Trigger Interfaces Register write failed" << std::endl;

	//vary trigger threshold of channel in question
	std::cout << "Testing Trigger Threshold for Row # " << rowNum << "\tCol # " << colNum << "\tCh # " << chNum << std::endl;
	int trigThreshReg = 13 + chNum + 8*rowNum +8*4*colNum;
	int trigScalerReg = 520 + chNum;
	int trigScaler = 0;
	int numSteps = 100;
	int trigThreshInit = 1800;
	int trigThreshDACStep = 3;
	int trigThreshVal = trigThreshInit;
	bool pedestalFound = 0;
	int threshold = 0;
	for(int i = 0 ; i < numSteps ; i++ ){
		trigThreshVal = trigThreshInit + i*trigThreshDACStep;
		//write trigger threshold DAC register
		if( !control->registerWriteReadback(board_id, trigThreshReg, trigThreshVal, regValReadback) )
			std::cout << "Trigger Threshold Register write failed" << std::endl;
			
		//pause after changing DAC
		sleep(1);

		//read trigger scaler register
		if( !control->registerRead(board_id, trigScalerReg, trigScaler) )
			std::cout << "Register read failed, exiting" << std::endl;

		std::cout << "Trigger DAC " << trigThreshVal << "\tScaler " << trigScaler << std::endl;
		if( trigScaler > 60000 )
			pedestalFound = 1;
		else if( trigScaler < 100 && pedestalFound ){
			std::cout << "Trigger threshold identified, exiting" << std::endl;
			threshold = trigThreshVal;
			break;
		}
	}

	char name[100];
	memset(name,0,sizeof(char)*100 );
	sprintf(name,"output_measureTriggerThresholds_%.1i_%.1i_%.1i.dat",rowNum,colNum,chNum);
	ofstream dataFile;
        dataFile.open (name, ios::out );
	dataFile << "triggerThreshold[" << rowNum << "][" << colNum << "][" << chNum << "] = " << threshold << ";" << std::endl;
	dataFile.close();

	//close USB interface
        control->closeUSBInterface();

	//delete irs3b interface object
	delete control;

	return 1;
}
