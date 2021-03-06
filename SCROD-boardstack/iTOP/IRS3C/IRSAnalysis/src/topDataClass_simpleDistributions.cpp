//compile with: g++ -o topDataClass_simpleDistributions src/topDataClass_simpleDistributions.cpp `root-config --cflags --glibs`
#include <stdio.h>
#include <time.h>
#include <unistd.h>
#include <iostream>
#include <stdlib.h> 
#include <fstream>
#include <TGraph.h>
#include <TH1.h>
#include "TApplication.h"
#include "TCanvas.h"
#include "TAxis.h"
#include "TF1.h"
#include "TMath.h"
#include "TFile.h"
#include "TGraphErrors.h"
#include "topDataClass.h"
#include "topDataClass.cpp"

using namespace std;

//global TApplication object declared here for simplicity
TApplication *theApp;

//helper functions
int initializeGlobalHistograms();
int writeOutputFile();
int getDistributions(topDataClass *data);
int printInfo();

//hardcoded constants relevant to laser data
double windowTime = 1115.;
double windowLow = windowTime - 10.;
double windowHigh = windowTime + 10.;

//hardcoded constants relevant to cosmic data
double windowLowCosmic = 800.;
double windowHighCosmic = windowLow ;

//output file pointer
TFile* outputFile;

//histograms
TH1F *hPulseHeightAll;
TH1F *hPulseHeightLaser;
TH1F *hPulseHeightCosmic;
TH1F *hPulseTimeAll;
TH1F *hPulseWidthAll;
TH1F *hPulseWidthSameWinAll;
TH1F *hPulseWidthDiffWinAll;
TH1F *hNHitCosmic;
TH1F *hNHitLaser;
TH1F *hNHitAll;
TH2F *hNumPulsesMod[4];
TH2F *hNumCosmicPulsesMod[4];
TH2F *hNumNonLaserPulsesMod[4];
TH2F *hNumLaserPulsesMod[4];
TH2F *hLaserRatePMTArray;
TH2F *hDarkNoiseRatePMTArray;
TH2F *hNumPulsePMTArray;
TH1F *hPulseHeightAsic[NMODS][NROWS][NCOLS];
TH1F *hPulseWidthSameWinAsic[NMODS][NROWS][NCOLS];
TH1F *hPulseWidthDiffWinAsic[NMODS][NROWS][NCOLS];
TH2F *hPulseHeightVsSmp256Asic[NMODS][NROWS][NCOLS];
TH2F *hPulseWidthSameVsSmp256Asic[NMODS][NROWS][NCOLS];
TH2F *hPulseWidthDiffVsSmp256Asic[NMODS][NROWS][NCOLS];
TH2F *hPulseWidthVsHeightAsic[NMODS][NROWS][NCOLS];
TH1F *hPulseHeightCh[NMODS][NROWS][NCOLS][NCHS];
TH1F *hPulseBaseCh[NMODS][NROWS][NCOLS][NCHS];
TH1F *hPulseTimeCh[NMODS][NROWS][NCOLS][NCHS];
TH1F *hPulseWidthSameWinCh[NMODS][NROWS][NCOLS][NCHS];
TH1F *hPulseWidthDiffWinCh[NMODS][NROWS][NCOLS][NCHS];

TGraphErrors *gTest;

//global variables
int numEvents = 0;
int numWins = 59;

int main(int argc, char* argv[]){
	if (argc != 3){
    		std::cout << "wrong number of arguments: usage ./topDataClass_simpleDistributions <file name> <# events>" << std::endl;
    		return 0;
  	}

	//define application object
	theApp = new TApplication("App", &argc, argv);
	TString inputFileName = theApp->Argv()[1];
	std::cout << "Input file name "  << inputFileName << std::endl;

	numEvents = atoi(theApp->Argv()[2]);
	if( numEvents <= 0 )
		numEvents  = 1000.;
	std::cout << "Number of Events " << numEvents << std::endl;

	//create target6 interface object
	topDataClass *data = new topDataClass();

	//open summary tree file
	data->openSummaryTree(inputFileName);

	//create output file
  	TObjArray* strings = inputFileName.Tokenize("/");
  	TObjString* objstring = (TObjString*) strings->At(strings->GetLast());
  	TString inputFileNameBase(objstring->GetString());
	TString outputFileName = "output_topDataClass_simpleDistributions_";
  	outputFileName += inputFileNameBase;
  	//outputFileName += ".root";
  	std::cout << " outputFileName " << outputFileName << std::endl;
  	outputFile = new TFile( outputFileName , "RECREATE");

	//initialize histograms
	initializeGlobalHistograms();

	//initialize tree branches
	data->setTreeBranches();

	//get overall distributions
	getDistributions(data);

	//print distribution info
	printInfo();

	//write output file
	writeOutputFile();

	//delete target6 data object
	delete data;

	return 1;
}

//define histograms
int initializeGlobalHistograms(){
	hPulseHeightAll = new TH1F("hPulseHeightAll","Pulse Height Distribution - All",1000,-50,1950.);
	hPulseHeightCosmic = new TH1F("hPulseHeightCosmic","Pulse Height Distribution - Cosmics",1000,-50,1950.);
	hPulseHeightLaser = new TH1F("hPulseHeightLaser","Pulse Height Distribution - Laser",1000,-50,1950.);
  	hPulseTimeAll = new TH1F("hPulseTimeAll","Pulse Time Distribution",10000,-64*64*1./2.7515,64*64*1./2.7515);
	hPulseWidthAll = new TH1F("hPulseWidthAll","Pulse Width Distribution",3000,-150,150.);
	hPulseWidthSameWinAll = new TH1F("hPulseWidthSameWinAll","Pulse Width Same Window Distribution",3000,-150,150.);
	hPulseWidthDiffWinAll = new TH1F("hPulseWidthDiffWinAll","Pulse Width Different Window Distribution",3000,-150,150.);
	//	hNHit = new TH1F("hNHit","Number of Hits per Event",200,0.,200.);
	hNHitAll = new TH1F("hNHitAll","Number of Hits (all) per Event",512,0.,512.);
	hNHitCosmic = new TH1F("hNHitCosmic","Number of Cosmic Hits per Event",512,0.,512.);
	hNHitLaser = new TH1F("hNHitLaser","Number of Laser Hits per Event",10,0.,10.);

	hNumPulsePMTArray = new TH2F("hNumPulsePMTArray","Number of Pulses - Looking Towards PMTs from Quartz",64,0,64,8,0,8);
	hDarkNoiseRatePMTArray = new TH2F("hDarkNoiseRatePMTArray","Dark Noise Rate (kHz) - Looking Towards PMTs from Quartz",64,0,64,8,0,8);
	hLaserRatePMTArray = new TH2F("hLaserRatePMTArray","Laser # Hits per Event - Looking Towards PMTs from Quartz",64,0,64,8,0,8);

	char name[100];
  	char title[200];
  	for(int m = 0 ; m < 4 ; m++ ){
  		memset(name,0,sizeof(char)*100 );
		memset(title,0,sizeof(char)*200 );
		sprintf(name,"hNumPulsesMod_%.2i",m);
		sprintf(title,"Number of Pulses Module %.2i ASIC ROW # vs 8 x COL # + CH #",m);
	  	hNumPulsesMod[m] = new TH2F(name,title,4*8,0,4*8,4,0,4);

		memset(name,0,sizeof(char)*100 );
		memset(title,0,sizeof(char)*200 );
		sprintf(name,"hNumNonLaserPulsesMod_%.2i",m);
		sprintf(title,"Number of Non-Laser Pulses Module %.2i ASIC ROW # vs 8 x COL # + CH #",m);
  		hNumNonLaserPulsesMod[m] = new TH2F(name,title,4*8,0,4*8,4,0,4);

		memset(name,0,sizeof(char)*100 );
		memset(title,0,sizeof(char)*200 );
		sprintf(name,"hNumCosmicPulsesMod_%.2i",m);
		sprintf(title,"Number of Cosmic Pulses Module %.2i ASIC ROW # vs 8 x COL # + CH #",m);
  		hNumCosmicPulsesMod[m] = new TH2F(name,title,4*8,0,4*8,4,0,4);

		memset(name,0,sizeof(char)*100 );
		memset(title,0,sizeof(char)*200 );
		sprintf(name,"hNumLaserPulsesMod_%.2i",m);
		sprintf(title,"Number of Laser Pulses Module %.2i ASIC ROW # vs 8 x COL # + CH #",m);
  		hNumLaserPulsesMod[m] = new TH2F(name,title,4*8,0,4*8,4,0,4);
  	}
	
	for(int m = 0 ; m < NMODS ; m++ )
	for(int r = 0 ; r < NROWS ; r++ )
    	for(int c = 0 ; c < NCOLS ; c++ ){
		memset(name,0,sizeof(char)*100 );
		memset(title,0,sizeof(char)*200 );
		sprintf(name,"hPulseHeightAsic_%.2i_%.2i_%.2i",m,r,c);
		sprintf(title,"Pulse Heights");
		hPulseHeightAsic[m][r][c] = new TH1F(name,title,200,-50,1950.);

		memset(name,0,sizeof(char)*100 );
		memset(title,0,sizeof(char)*200 );
		sprintf(name,"hPulseWidthSameWinAsic_%.2i_%.2i_%.2i",m,r,c);
		sprintf(title,"Pulse Widths");
		hPulseWidthSameWinAsic[m][r][c] = new TH1F(name,title,300,-150,150.);

		memset(name,0,sizeof(char)*100 );
		memset(title,0,sizeof(char)*200 );
		sprintf(name,"hPulseWidthDiffWinAsic_%.2i_%.2i_%.2i",m,r,c);
		sprintf(title,"Pulse Widths");
		hPulseWidthDiffWinAsic[m][r][c] = new TH1F(name,title,300,-150,150.);

		memset(name,0,sizeof(char)*100 );
		memset(title,0,sizeof(char)*200 );
		sprintf(name,"hPulseHeightVsSmp256Asic_%.2i_%.2i_%.2i",m,r,c);
		sprintf(title,"Pulse Heights Vs Sample Bin #");
		hPulseHeightVsSmp256Asic[m][r][c] = new TH2F(name,title,256,0,256,200,-50,1950.);

		memset(name,0,sizeof(char)*100 );
		memset(title,0,sizeof(char)*200 );
		sprintf(name,"hPulseWidthVsHeightAsic_%.2i_%.2i_%.2i",m,r,c);
		sprintf(title,"Pulse Width Vs Height");
		hPulseWidthVsHeightAsic[m][r][c] = new TH2F(name,title,200,-50,1950.,300,0,30.);

		memset(name,0,sizeof(char)*100 );
		memset(title,0,sizeof(char)*200 );
		sprintf(name,"hPulseWidthSameVsSmp256Asic_%.2i_%.2i_%.2i",m,r,c);
		sprintf(title,"Pulse Width Vs Sample Bin #");
		hPulseWidthSameVsSmp256Asic[m][r][c] = new TH2F(name,title,256,0,256,300,0,30.);
	
		memset(name,0,sizeof(char)*100 );
		memset(title,0,sizeof(char)*200 );
		sprintf(name,"hPulseWidthDiffVsSmp256Asic_%.2i_%.2i_%.2i",m,r,c);
		sprintf(title,"Pulse Width Vs Sample Bin #");
		hPulseWidthDiffVsSmp256Asic[m][r][c] = new TH2F(name,title,256,0,256,300,0,30.);
	}

	for(int m = 0 ; m < NMODS ; m++ )
  	for(int r = 0 ; r < NROWS ; r++ )
  	for(int c = 0 ; c < NCOLS ; c++ )
  	for(int ch = 0 ; ch < NCHS ; ch++ ){
		memset(name,0,sizeof(char)*100 );
		memset(title,0,sizeof(char)*200 );
		sprintf(name,"hPulseHeightCh_%.2i_%.2i_%.2i_%.2i",m,r,c,ch);
		sprintf(title,"Pulse Heights");
		hPulseHeightCh[m][r][c][ch] = new TH1F(name,title,200,-50,1950.);

		memset(name,0,sizeof(char)*100 );
		memset(title,0,sizeof(char)*200 );
		sprintf(name,"hPulseTimeCh_%.2i_%.2i_%.2i_%.2i",m,r,c,ch);
		sprintf(title,"Pulse Times");
		hPulseTimeCh[m][r][c][ch] = new TH1F(name,title,200,windowLow,windowHigh);

		memset(name,0,sizeof(char)*100 );
		memset(title,0,sizeof(char)*200 );
		sprintf(name,"hPulseBaseCh_%.2i_%.2i_%.2i_%.2i",m,r,c,ch);
		sprintf(title,"Baselines");
		hPulseBaseCh[m][r][c][ch] = new TH1F(name,title,200,-100.,100.);

		memset(name,0,sizeof(char)*100 );
		memset(title,0,sizeof(char)*200 );
		sprintf(name,"hPulseWidthSameWinCh_%.2i_%.2i_%.2i_%.2i",m,r,c,ch);
		sprintf(title,"Pulse Widths");
		hPulseWidthSameWinCh[m][r][c][ch] = new TH1F(name,title,300,-150,150.);

		memset(name,0,sizeof(char)*100 );
		memset(title,0,sizeof(char)*200 );
		sprintf(name,"hPulseWidthDiffWinCh_%.2i_%.2i_%.2i_%.2i",m,r,c,ch);
		sprintf(title,"Pulse Widths");
		hPulseWidthDiffWinCh[m][r][c][ch] = new TH1F(name,title,300,-150,150.);
	}
}

int writeOutputFile(){
	outputFile->cd();

	hPulseHeightAll->Write();
	hPulseHeightCosmic->Write();
	hPulseHeightLaser->Write();
	hPulseTimeAll->Write();
	hNHitAll->Write();
	hNHitCosmic->Write();
	hNHitLaser->Write();
	//	hNHit->Write();
	hPulseWidthAll->Write();
	hPulseWidthSameWinAll->Write();
	hPulseWidthDiffWinAll->Write();

	hNumPulsePMTArray->Write();
	hDarkNoiseRatePMTArray->Write();
	hLaserRatePMTArray->Write();

	for(int m = 0 ; m < 4 ; m++ )
  		hNumPulsesMod[m]->Write();
  	for(int m = 0 ; m < 4 ; m++ )
  		hNumLaserPulsesMod[m]->Write();
	for(int m = 0 ; m < 4 ; m++ )
  		hNumCosmicPulsesMod[m]->Write();
	for(int m = 0 ; m < 4 ; m++ )
  		hNumNonLaserPulsesMod[m]->Write();

	outputFile->mkdir("hPulseHeightAsic");
	outputFile->cd("hPulseHeightAsic");
	for(int m = 0 ; m < NMODS ; m++ )
	for(int r = 0 ; r < NROWS ; r++ )	
	for(int c = 0 ; c < NCOLS ; c++ ){
		if(  hPulseHeightAsic[m][r][c]->GetEntries() > 0 )
	    		hPulseHeightAsic[m][r][c]->Write();
    	}

    	outputFile->mkdir("hPulseWidthAsic");
    	outputFile->cd("hPulseWidthAsic");
    	for(int m = 0 ; m < NMODS ; m++ )
    	for(int r = 0 ; r < NROWS ; r++ )
    	for(int c = 0 ; c < NCOLS ; c++ )
	{
	    if(  hPulseWidthSameWinAsic[m][r][c]->GetEntries() > 0 )
	        hPulseWidthSameWinAsic[m][r][c]->Write();
	    if(  hPulseWidthDiffWinAsic[m][r][c]->GetEntries() > 0 )
		hPulseWidthDiffWinAsic[m][r][c]->Write();
	}

    	outputFile->mkdir("hPulseHeightVsSmp256Asic");
    	outputFile->cd("hPulseHeightVsSmp256Asic");
    	for(int m = 0 ; m < NMODS ; m++ )
    	for(int r = 0 ; r < NROWS ; r++ )
    	for(int c = 0 ; c < NCOLS ; c++ )
		if(  hPulseHeightVsSmp256Asic[m][r][c]->GetEntries() > 0 )
	    		hPulseHeightVsSmp256Asic[m][r][c]->Write();

	outputFile->mkdir("hPulseWidthVsSmp256Asic");
    	outputFile->cd("hPulseWidthVsSmp256Asic");
    	for(int m = 0 ; m < NMODS ; m++ )
    	for(int r = 0 ; r < NROWS ; r++ )
    	for(int c = 0 ; c < NCOLS ; c++ ){
		if(  hPulseWidthSameVsSmp256Asic[m][r][c]->GetEntries() > 0 )
	    		hPulseWidthSameVsSmp256Asic[m][r][c]->Write();
		if(  hPulseWidthDiffVsSmp256Asic[m][r][c]->GetEntries() > 0 )
	    		hPulseWidthDiffVsSmp256Asic[m][r][c]->Write();
	}

	outputFile->mkdir("hPulseWidthVsHeightAsic");
    	outputFile->cd("hPulseWidthVsHeightAsic");
    	for(int m = 0 ; m < NMODS ; m++ )
    	for(int r = 0 ; r < NROWS ; r++ )
    	for(int c = 0 ; c < NCOLS ; c++ )
		if(  hPulseWidthVsHeightAsic[m][r][c]->GetEntries() > 0 )
	    		hPulseWidthVsHeightAsic[m][r][c]->Write();

	outputFile->mkdir("hPulseHeightCh");
	outputFile->cd("hPulseHeightCh");
	for(int m = 0 ; m < NMODS ; m++ )
  	for(int r = 0 ; r < NROWS ; r++ )
  	for(int c = 0 ; c < NCOLS ; c++ )
  	for(int ch = 0 ; ch < NCHS ; ch++ ){
		if(  hPulseHeightCh[m][r][c][ch]->GetEntries() > 0 )
			hPulseHeightCh[m][r][c][ch]->Write();
	}

	outputFile->mkdir("hPulseTimeCh");
	outputFile->cd("hPulseTimeCh");
	for(int m = 0 ; m < NMODS ; m++ )
  	for(int r = 0 ; r < NROWS ; r++ )
  	for(int c = 0 ; c < NCOLS ; c++ )
  	for(int ch = 0 ; ch < NCHS ; ch++ ){
		if(  hPulseTimeCh[m][r][c][ch]->GetEntries() > 0 )
		hPulseTimeCh[m][r][c][ch]->Write();
	}

	outputFile->mkdir("hPulseBaseCh");
	outputFile->cd("hPulseBaseCh");
	for(int m = 0 ; m < NMODS ; m++ )
  	for(int r = 0 ; r < NROWS ; r++ )
  	for(int c = 0 ; c < NCOLS ; c++ )
  	for(int ch = 0 ; ch < NCHS ; ch++ ){
		if(  hPulseBaseCh[m][r][c][ch]->GetEntries() > 0 )
		hPulseBaseCh[m][r][c][ch]->Write();
	}

	outputFile->mkdir("hPulseWidthCh");
	outputFile->cd("hPulseWidthCh");
	for(int m = 0 ; m < NMODS ; m++ )
  	for(int r = 0 ; r < NROWS ; r++ )
  	for(int c = 0 ; c < NCOLS ; c++ )
  	for(int ch = 0 ; ch < NCHS ; ch++ ){
		if(  hPulseWidthSameWinCh[m][r][c][ch]->GetEntries() > 0 )
			hPulseWidthSameWinCh[m][r][c][ch]->Write();
		if(  hPulseWidthDiffWinCh[m][r][c][ch]->GetEntries() > 0 )
			hPulseWidthDiffWinCh[m][r][c][ch]->Write();
	}
	
	outputFile->Close();
	return 1;
}

int getDistributions(topDataClass *data){
	if( data->isTOPTree == 0 ){
		std::cout << "getDistributions: tree object not loaded, quitting" << std::endl;
		return 0;
	}

	gTest = new TGraphErrors();

	//loop over tr_rawdata entries
  	Long64_t nEntries(data->tr_top->GetEntries());
  	for(Long64_t entry(0); entry<nEntries; ++entry) {
    		data->tr_top->GetEntry(entry);

		//number of hits count
		int nWindowHits = 0;
		int nLaserHits = 0;
		int nCosmicHits = 0;
		int nAllHits = 0;

		//loop over all the hits in the event, store accepted pulses
    		for( int i = 0 ; i < data->nhit ; i++ ){
			int pmt_i =  data->pmtid_mcp[i] - 1;
			int pmtch_i =  data->ch_mcp[i] - 1;
			int asicMod = BII_2_Emod(data->pmtid_mcp[i], data->ch_mcp[i]);
			int asicRow = BII_2_ASICrow(data->pmtid_mcp[i], data->ch_mcp[i]);
			int asicCol = BII_2_ASICcol(data->pmtid_mcp[i], data->ch_mcp[i]);
			int asicCh  = BII_2_ASICch(data->pmtid_mcp[i], data->ch_mcp[i]);

			//require legitimate channel
			if( asicMod < 0 || asicMod >= NMODS || asicRow < 0 || asicRow >= NROWS || asicCol < 0 || asicCol >= NCOLS || asicCh < 0 || asicCh >= NCHS )
				continue;

			//represent pulse position on 8 x 64 grid representing PMT array front surface
			int boardStackPos = asicMod;
			if( asicMod == 0 )
				boardStackPos = 3;
			if( asicMod == 1 )
				boardStackPos = 2;
			if( asicMod == 2 )
				boardStackPos = 1;
			if( asicMod == 3 )
				boardStackPos = 0;
			
			int xIndex = 16*boardStackPos + 4*asicCol + 3 - asicCh/2;
			int yIndex = 2*(3 - asicRow) + 1 - asicCh % 2;
			hNumPulsePMTArray->Fill( xIndex, yIndex);

			//get pulse times
			double pulseTime = data->measurePulseTimeTreeEntry(i,1);
			double pulseHeight = data->adc0_mcp[i];
			//int getSmp128Bin(int firstWindow, int smpNum);
			//double getSmpPos(double smpNextY, double smpPrevY, double adc0);
			double smpPos = data->getSmp128Bin( data->firstWindow[i], data->smp0_mcp[i] ) 
				+ data->getSmpPos( data->tdc0_smpNextY_mcp[i] , data->tdc0_smpPrevY_mcp[i] , data->adc0_mcp[i] );
			double smpFallPos = data->getSmp128Bin( data->firstWindow[i], data->smp0Fall_mcp[i] ) 
				+ data->getSmpFallPos( data->tdc0Fall_smpNextY_mcp[i] , data->tdc0Fall_smpPrevY_mcp[i] , data->adc0_mcp[i] );
			double pulseWidth = smpFallPos - smpPos;
			if( smpFallPos < smpPos )
				pulseWidth = smpFallPos + 128 - smpPos;
			double baseline = data->base_mcp[i];
			int smp256Bin = data->getSmp256Bin( data->firstWindow[i], data->smp0_mcp[i] );

			hPulseHeightAll->Fill(pulseHeight);
			hPulseTimeAll->Fill(pulseTime);
			hPulseWidthAll->Fill(pulseWidth);

			hPulseHeightAsic[asicMod][asicRow][asicCol]->Fill(pulseHeight);
			hPulseHeightVsSmp256Asic[asicMod][asicRow][asicCol]->Fill( smp256Bin , pulseHeight);

			hPulseHeightCh[asicMod][asicRow][asicCol][asicCh]->Fill(pulseHeight);
			hPulseBaseCh[asicMod][asicRow][asicCol][asicCh]->Fill(baseline);
			hPulseTimeCh[asicMod][asicRow][asicCol][asicCh]->Fill(pulseTime);
			if( smpFallPos > smpPos )
				hPulseWidthVsHeightAsic[asicMod][asicRow][asicCol]->Fill(pulseHeight,pulseWidth);
			//looking at all hits with reasonable times
			hNumPulsesMod[asicMod]->Fill(8*asicCol + asicCh, asicRow );
				nAllHits++;
       			//not clear this is at all correct...seems to include laser interval in range
			if( pulseTime > windowLow -200 && pulseTime < windowHigh -200 ){
      				hNumNonLaserPulsesMod[asicMod]->Fill(8*asicCol + asicCh, asicRow );
			}
			//looking in cosmic ray time range
			if( pulseTime > windowLowCosmic && pulseTime < windowHighCosmic   ){
			        hNumCosmicPulsesMod[asicMod]->Fill(8*asicCol + asicCh, asicRow );
				nCosmicHits++;
				hPulseHeightCosmic->Fill(pulseHeight);
			}
			//looking just in laser time range
			if( pulseTime > windowLow && pulseTime < windowHigh  ){
				hNumLaserPulsesMod[asicMod]->Fill(8*asicCol + asicCh, asicRow );
				nWindowHits++;
				nLaserHits++;
				hPulseHeightLaser->Fill(pulseHeight);
			}

			//restrict pulse width measurements to larger pulses
			if(pulseHeight < 250. || pulseHeight > 850.)
				continue;

			if( smpFallPos > smpPos ){
				hPulseWidthSameWinAll->Fill(pulseWidth);
				hPulseWidthSameWinAsic[asicMod][asicRow][asicCol]->Fill(pulseWidth);
				hPulseWidthSameWinCh[asicMod][asicRow][asicCol][asicCh]->Fill(pulseWidth);
				hPulseWidthSameVsSmp256Asic[asicMod][asicRow][asicCol]->Fill(smp256Bin,pulseWidth);
			}
			else{
				hPulseWidthDiffWinAll->Fill(pulseWidth);
				hPulseWidthDiffWinAsic[asicMod][asicRow][asicCol]->Fill(pulseWidth);
				hPulseWidthDiffWinCh[asicMod][asicRow][asicCol][asicCh]->Fill(pulseWidth);
				hPulseWidthDiffVsSmp256Asic[asicMod][asicRow][asicCol]->Fill(smp256Bin,pulseWidth);
			}
		}//end loop over hits

		//fill overall event summary distributions
		hNHitAll->Fill(nAllHits);
		hNHitLaser->Fill(nLaserHits);
		hNHitCosmic->Fill(nCosmicHits);
		//		hNHit->Fill(nWindowHits);
	}

	return 1;
}

int printInfo(){
	std::cout << std::fixed;
	std::cout.precision(5);
	std::cout << "Pulse Heights" << std::endl;
  	for(int m = 0 ; m < 4 ; m++ ){
  	for(int r = 0 ; r < 4 ; r++ ){
  	for(int c = 0 ; c < 4 ; c++ ){
  	for(int ch = 0 ; ch < 8 ; ch++ ){
		if(  hPulseHeightCh[m][r][c][ch]->GetEntries() > 0 ){
			double mean = hPulseHeightCh[m][r][c][ch]->GetMean(1);
			double rms = hPulseHeightCh[m][r][c][ch]->GetRMS(1);
			std::cout << " Mod " << m << "\tRow " << r << "\tCol " << c << "\tCh " << ch;
			std::cout << "\tAvg " << mean << "\tRms " << rms;
			std::cout << std::endl;
		}
  	}}}}//end print out

	std::cout << "Pulse Widths" << std::endl;
  	for(int m = 0 ; m < 4 ; m++ ){
  	for(int r = 0 ; r < 4 ; r++ ){
  	for(int c = 0 ; c < 4 ; c++ ){
  	for(int ch = 0 ; ch < 8 ; ch++ ){
		if(  hPulseHeightCh[m][r][c][ch]->GetEntries() > 0 ){
			double meanSame = hPulseWidthSameWinCh[m][r][c][ch]->GetMean(1);
			double rmsSame = hPulseWidthSameWinCh[m][r][c][ch]->GetRMS(1);
			double meanDiff = hPulseWidthDiffWinCh[m][r][c][ch]->GetMean(1);
			double rmsDiff = hPulseWidthDiffWinCh[m][r][c][ch]->GetRMS(1);
			std::cout << " Mod " << m << "\tRow " << r << "\tCol " << c << "\tCh " << ch;
			std::cout << "\tAvg Same " << meanSame << "\tRms Same " << rmsSame;
			std::cout << "\tAvg Diff " << meanDiff << "\tRms Diff " << rmsDiff;
			std::cout << "\tDead Time " << meanSame - meanDiff;
			std::cout << std::endl;
		}
  	}}}}//end print out

	std::cout << "Number of Pulses" << std::endl;
  	for(int m = 0 ; m < 4 ; m++ ){
  	for(int r = 0 ; r < 4 ; r++ ){
  	for(int c = 0 ; c < 4 ; c++ ){
  	for(int ch = 0 ; ch < 8 ; ch++ ){
		//int PMTnum = ASIC_2_BIIpmt(m, r, c);
		//int PMTChNum = ASICch_2_BIIch(r, ch);
		double num = hNumPulsesMod[m]->GetBinContent( 1 + ch + 8*c , 1 + r );
		double numNonLaser = hNumNonLaserPulsesMod[m]->GetBinContent( 1 + ch + 8*c , 1 + r );
		double numLaser = hNumLaserPulsesMod[m]->GetBinContent( 1 + ch + 8*c , 1 + r );
		if( num <= 0. && numLaser <= 0.) continue;
		double darkRate = 0;
		double darkRatekHz = 0;
		double laserRate = 0;
		if( numEvents > 0 ){
			//rate = num/(double(numEvents)*double(numWins)*23.586E-9)/1000.;
			darkRate = num/double(numEvents);
			darkRatekHz = num/(double(numEvents)*double(numWins)*23.586E-9)/1000.;
			laserRate =(numLaser-numNonLaser)/double(numEvents);
			if(laserRate < 0)
				laserRate = 0;
		}

		int boardStackPos = m;
		if( m == 0 )
			boardStackPos = 3;
		if( m == 1 )
			boardStackPos = 2;
		if( m == 2 )
			boardStackPos = 1;
		if( m == 3 )
			boardStackPos = 0;
		int xIndex = 16*boardStackPos + 4*c + 3 - ch/2;
		int yIndex = 2*(3 - r) + 1 - ch % 2;
		hDarkNoiseRatePMTArray->SetBinContent( 1 + xIndex , 1 + yIndex , darkRatekHz );
		hLaserRatePMTArray->SetBinContent( 1 + xIndex , 1 + yIndex , laserRate );

		std::cout << " Mod " << m << "\tRow " << r << "\tCol " << c << "\tCh " << ch;
		std::cout << "\t# Hits " << num << "\t# Laser Hits " << numLaser;
		std::cout << "\tRate [kHz] " << darkRatekHz;
		std::cout << "\tLaser Rate [per event] " << laserRate;
		std::cout << std::endl;
  	}}}}//end print out

	return 0;
}
