#include <iostream>
#include <fstream>
#include <sstream>
#include <cstdlib>
#include <vector>
#include <TFile.h>
#include "TTree.h"
#include "TSystem.h"
#include "TROOT.h"
#include "TApplication.h"
#include <math.h>
#include <TH1F.h> 
#include <TH2S.h> 
#include <TH2F.h> 
#include <TF1.h>
#include <TMath.h> 
#include <TGraph.h>
#include "TCanvas.h"
#include "topDataClass.h"
#include "CRTChannelConversion.hh"

using namespace std;

topDataClass::topDataClass(){
	isInputFile = 0;
	inputFile = NULL;
	isTOPTree = 0;
	tr_top = NULL;

	tr_mod = -1;
	tr_row = -1;
	tr_col = -1;
	tr_ch = -1;
	tr_pmt = -1;
  	tr_pmtch = -1;

	marker_mod = -1;
	marker_row = -1;
	marker_col = -1;
	marker_ch = -1;
	isTimingMarker = 0;

	numUsed = 0;

	//initialize calibration variables to default values  	
	FTSW_SCALE = 0.045056; //ns per FTSW DAC
	avg128Period = 128./2.715; //ns
	defaultSmpWidth = 1./2.715;
	sampleWidthScaleFactor = 1.0;
	cfdFraction = 0.2;
	//initialize start times of 128 sample array bins (element 0 time = sample 0 within array)
	smp128StartTimes[0] = 0.;
  	for(int i = 1 ; i < 128 ; i++ )
		smp128StartTimes[i] = smp128StartTimes[i-1] + defaultSmpWidth*sampleWidthScaleFactor; //ns

	//initialize analysis constants
	windowTime = 1054.;
}

topDataClass::~topDataClass(){
	if( isInputFile ){
		inputFile->Close();
		delete inputFile;
	}
}

int topDataClass::setAnalysisChannel(int mod, int row, int col, int ch){
	if( mod < 0 || mod >= 4 || row < 0 || row >= 4 || col < 0 || col >= 4 || ch < 0 || ch >= 8 )
 	 	return 0;

	tr_mod = mod;
	tr_row = row;
	tr_col = col;
	tr_ch = ch;

	tr_pmt = ASIC_2_BIIpmt(tr_mod, tr_row, tr_col);
  	tr_pmtch = ASICch_2_BIIch(tr_row, tr_ch);

	std::cout << "Analyzing pulses on\tmodule " << tr_mod << "\trow " << tr_row << "\tcol " << tr_col << "\tch " << tr_ch << std::endl;

	return 1;
}

int topDataClass::setTimingMarkerChannel(int mod, int row, int col, int ch){
	if( mod < 0 || mod >= 4 || row < 0 || row >= 4 || col < 0 || col >= 4 || ch < 0 || ch >= 8 )
 	 	return 0;

	marker_mod = mod;
	marker_row = row;
	marker_col = col;
	marker_ch = ch;
	isTimingMarker = 1;

	std::cout << "Timing marker pulses on\tmodule " << marker_mod << "\trow " << marker_row << "\tcol " << marker_col << "\tch " << marker_ch << std::endl;

	return 1;
}

int topDataClass::openSummaryTree(TString inputFileName){
	//get file containing summary tree
  	inputFile = new TFile(inputFileName);
  	if (inputFile->IsZombie()) {
		std::cout << "openSummaryTree: Error opening input file" << std::endl;
		return 0;
  	}
  	if( !inputFile )
		return 0;

	isInputFile = 1;

  	// check if tree is in file
  	tr_top = (TTree*) inputFile->Get("top");
  	if( !tr_top )
		return 0;
	
	isTOPTree = 1;

	return 1;	
}

int topDataClass::setTreeBranches(){
	if( isTOPTree == 0 ){
		std::cout << "setTreeBranches: tree object not loaded, quitting" << std::endl;
		return 0;
	}

	//set tree branches
	std::cout << "Setting input tree branches" << std::endl;

	//event specific
	tr_top->SetBranchAddress("eventNum", &(eventNum));
	tr_top->SetBranchAddress("ftsw",&(ftsw));
	tr_top->SetBranchAddress("nhit", &(nhit));

	//ROI specific
	tr_top->SetBranchAddress("refWindow",&(refWindow));
	tr_top->SetBranchAddress("firstWindow",&(firstWindow));
	tr_top->SetBranchAddress("pmt",&(pmtid_mcp));
  	tr_top->SetBranchAddress("ch",&(ch_mcp));
	tr_top->SetBranchAddress("pmtflag",&(pmtflag_mcp));
	tr_top->SetBranchAddress("adc0",&(adc0_mcp));
  	tr_top->SetBranchAddress("base",&(base_mcp));

	//CFD - rising edge
	tr_top->SetBranchAddress("smp",&(smp0_mcp));
  	tr_top->SetBranchAddress("tdc0_smpPrevY",&(tdc0_smpPrevY_mcp));
  	tr_top->SetBranchAddress("tdc0_smpNextY",&(tdc0_smpNextY_mcp));

	//CFD - falling edge
	tr_top->SetBranchAddress("smpFall",&(smp0Fall_mcp));
  	tr_top->SetBranchAddress("tdc0Fall_smpPrevY",&(tdc0Fall_smpPrevY_mcp));
  	tr_top->SetBranchAddress("tdc0Fall_smpNextY",&(tdc0Fall_smpNextY_mcp));
  	
	//Fixed threshold - rising edge
  	tr_top->SetBranchAddress("smpFix100",&(smpFix100_mcp));
	tr_top->SetBranchAddress("tdcFix100_smpPrevY_mcp",&(tdcFix100_smpPrevY_mcp));
  	tr_top->SetBranchAddress("tdcFix100_smpNextY_mcp",&(tdcFix100_smpNextY_mcp));
	
	//Fixed threshold - falling edge
  	tr_top->SetBranchAddress("smpFix100Fall",&(smpFix100Fall_mcp)); 	
  	tr_top->SetBranchAddress("tdcFix100Fall_smpPrevY_mcp",&(tdcFix100Fall_smpPrevY_mcp));
  	tr_top->SetBranchAddress("tdcFix100Fall_smpNextY_mcp",&(tdcFix100Fall_smpNextY_mcp));

	return 1;
}

//load pulse info into arrays
int topDataClass::selectPulsesForArray(){
	if( isTOPTree == 0 ){
		std::cout << "selectPulsesForArray: tree object not loaded, quitting" << std::endl;
		return 0;
	}
	
	//load pulse info into arrays for quick access
	std::cout << "Loading pulse info arrays for channel of interest" << std::endl;

	//loop over tr_rawdata entries
  	Long64_t nEntries(tr_top->GetEntries());
  	for(Long64_t entry(0); entry<nEntries; ++entry) {
    		tr_top->GetEntry(entry);
	
		//try to get timing marker info for this event
		int markerHitNum = -1;
		getTimingMarkerNHitNum(entry, markerHitNum);
		double mark_adc = -1;
		int mark_first = -1;
		int mark_ref = -1;
		int mark_smp = -1;
		double mark_smpPrevY = -1;
		double mark_smpNextY = -1;
		int mark_smpFix100 = -1;
		double mark_smpFix100PrevY = -1;
		double mark_smpFix100NextY = -1;
		if( markerHitNum >= 0 && markerHitNum < nhit ){
			mark_adc = adc0_mcp[markerHitNum];
			mark_first = firstWindow[markerHitNum];
			mark_ref = refWindow[markerHitNum];
			mark_smp = smp0_mcp[markerHitNum];
			mark_smpPrevY = tdc0_smpPrevY_mcp[markerHitNum];
			mark_smpNextY = tdc0_smpNextY_mcp[markerHitNum];
			mark_smpFix100 = smpFix100_mcp[markerHitNum];
			mark_smpFix100PrevY = tdcFix100_smpPrevY_mcp[markerHitNum];
			mark_smpFix100NextY = tdcFix100_smpNextY_mcp[markerHitNum];
		}

		//count # of laser pulses in this event on PMT of interest
		int numLaserPulse = 0;
		for( int i = 0 ; i < nhit ; i++ ){

			//determine if pulses is on PMT of interest
			if( pmtid_mcp[i] != tr_pmt ) continue;

			//get pulse times
			double pulseTime = measurePulseTimeTreeEntry(i,1);
			if( pulseTime > windowTime - 100. && pulseTime < windowTime + 100. )
				numLaserPulse++;
		}

		//optional: skip event if multiple laser pulses
		//if( numLaserPulse > 1 )
		//	continue;

		//loop over all the hits in the event, store accepted pulses
    		for( int i = 0 ; i < nhit ; i++ ){

			//determine if pulses is on PMT of interest
			if( pmtid_mcp[i] != tr_pmt ) continue;

			//get the ASIC row, column and channel associated with the PMT channel
			int asicMod = BII_2_Emod(pmtid_mcp[i], ch_mcp[i]);
			int asicRow = BII_2_ASICrow(pmtid_mcp[i], ch_mcp[i]);
			int asicCol = BII_2_ASICcol(pmtid_mcp[i], ch_mcp[i]);
			int asicCh  = BII_2_ASICch(pmtid_mcp[i], ch_mcp[i]);

			//only consider pulses in channel of interest
			if( asicMod != tr_mod || asicRow != tr_row || asicCol != tr_col || asicCh != tr_ch )
				continue;

			//get pulse times
			double pulseTime = measurePulseTimeTreeEntry(i,1);

			//CUT : remove pulse flagged as bad due to pulse overflow
			//if( pmtflag_mcp[i] == 1 ) continue;

			//store accepted pulses in time window
			if( numUsed < maxNumEvt && pulseTime > windowTime - 100. && pulseTime < windowTime + 100. ){
				entryNum_A[numUsed] = entry;
				eventNum_A[numUsed] = eventNum;
				//numLaserPulse_A[numUsed] = numLaserPulse;
    				ftsw_A[numUsed] = ftsw;
    				adc_0_A[numUsed] = adc0_mcp[i];
    				first_0_A[numUsed] = firstWindow[i];
    				ref_0_A[numUsed] = refWindow[i];
    				smp_0_A[numUsed] = smp0_mcp[i];
				smpPrevY_0_A[numUsed] = tdc0_smpPrevY_mcp[i];
    				smpNextY_0_A[numUsed] = tdc0_smpNextY_mcp[i];
    				smpFall_0_A[numUsed] = smp0Fall_mcp[i];
				smpFallPrevY_0_A[numUsed] = tdc0Fall_smpPrevY_mcp[i];
    				smpFallNextY_0_A[numUsed] = tdc0Fall_smpNextY_mcp[i];
				smp_Fix100_A[numUsed] = smpFix100_mcp[i];
				smpPrevY_Fix100_A[numUsed] = tdcFix100_smpPrevY_mcp[i];
				smpNextY_Fix100_A[numUsed] = tdcFix100_smpNextY_mcp[i];
    				smpFall_Fix100_A[numUsed] = smpFix100Fall_mcp[i];
				smpFallPrevY_Fix100_A[numUsed] = tdcFix100Fall_smpPrevY_mcp[i];
				smpFallNextY_Fix100_A[numUsed] = tdcFix100Fall_smpNextY_mcp[i];
				mark_adc_0_A[numUsed] = mark_adc;
				mark_first_0_A[numUsed] = mark_first;
				mark_ref_0_A[numUsed] = mark_ref;
				mark_smp_0_A[numUsed] = mark_smp;
				mark_smpPrevY_0_A[numUsed] = mark_smpPrevY;
				mark_smpNextY_0_A[numUsed] = mark_smpNextY;
				mark_smp_Fix100_A[numUsed] = mark_smpFix100;
				mark_smpPrevY_Fix100_A[numUsed] = mark_smpFix100PrevY;
				mark_smpNextY_Fix100_A[numUsed] = mark_smpFix100NextY;
    				numUsed++;
			}
		}//end ROIs loop
  	}//end entries loop

	return 1;
}

double topDataClass::measurePulseTimeTreeEntry(int hitIndex , bool useFTSWTDCCorr){
	if( hitIndex < 0 || hitIndex >= nhit )
		return -1.E+6;

	int FTSWTDC = 0;
	if( useFTSWTDCCorr )
		FTSWTDC = ftsw;
	return measurePulseTimeStandalone(firstWindow[hitIndex], refWindow[hitIndex], smp0_mcp[hitIndex], FTSWTDC, FTSW_SCALE, avg128Period, smp128StartTimes, 
				tdc0_smpPrevY_mcp[hitIndex], tdc0_smpNextY_mcp[hitIndex], cfdFraction*adc0_mcp[hitIndex]);
}

double topDataClass::measurePulseTimeArrayEntry(int entry, bool useFTSWTDCCorr){
	//skip events not in arrays
  	if( entry >= maxNumEvt )
		return -1.E+6;

	int smpPosIn128Array = (int( first_0_A[entry] )*64 + int( smp_0_A[entry] )) % 128;
	int FTSWTDC = 0;
	if( useFTSWTDCCorr )
		FTSWTDC = ftsw_A[entry];
	return measurePulseTimeStandalone(first_0_A[entry], ref_0_A[entry], smp_0_A[entry], FTSWTDC, FTSW_SCALE, avg128Period, smp128StartTimes, 
		smpPrevY_0_A[entry], smpNextY_0_A[entry], cfdFraction*adc_0_A[entry]);
}

//standalone function calculates pulse time, taking into account variable sample periods and FTSW correction
double topDataClass::measurePulseTimeStandalone(int infirst, int inref, int insmp, int inftsw, double inFTSW_SCALE, double inavg128Period, double insmp128StartTimes[], 	double insmpPrevY, double insmpNextY, double intarget){

    //calculate number of windows elapsed since "reference window"/128 bin window pair in which trigger occurred
    int numWinAfterRef = (infirst - inref + 64 ) % 64 - 1; //subtract to account for reference window is always odd, start counting from next even window
    //count # of 128 bin windows elapsed since reference window
    int num128ArraysAfterRef = numWinAfterRef / 2 + ((infirst % 2)*64 + int(insmp))/128;
    //identify sample bin in 128 bin window
    int smpPosIn128Array = (int(infirst)*64 + int(insmp)) % 128;
    //calculate FTSW TDC correction, accounts for asynchronous trigger
    double phaseCorr = inFTSW_SCALE * inftsw;

    //define initial approximate pulse time to return if an error is detected in subsequent
    double timeEstimate = (num128ArraysAfterRef)*inavg128Period + phaseCorr;

    //make sure sample array bin # is valid
    if( smpPosIn128Array < 0 || smpPosIn128Array > 127 )
	return timeEstimate;

    //use sample time array to update timeEstimate
    timeEstimate  = (num128ArraysAfterRef)*inavg128Period + phaseCorr + insmp128StartTimes[int(smpPosIn128Array)];

    //calculate sample period using sample start times
    double smpPeriod = defaultSmpWidth; //default period
    if( smpPosIn128Array < 127 )
	smpPeriod = insmp128StartTimes[int(smpPosIn128Array)+1]-insmp128StartTimes[int(smpPosIn128Array)];
    else
	smpPeriod = inavg128Period - insmp128StartTimes[127]; //can be negative!

    //catch weird situation where sample 0 in next 128 bin array occurs BEFORE sample 127 (undersampling)
    if( smpPeriod < 0 )
	return timeEstimate;

    //calculate linear interpolated slope between two threshold samples
    double edgeSlope = (insmpNextY - insmpPrevY)/smpPeriod;
    if( edgeSlope == 0 )
	return timeEstimate;

    //add inter-sample information to time estimate
    double edgeTime = (intarget - insmpPrevY)/edgeSlope;
    timeEstimate = (num128ArraysAfterRef)*inavg128Period + phaseCorr + insmp128StartTimes[int(smpPosIn128Array)] + edgeTime;

    return timeEstimate;
}

//get pulse sample index out of 128 bin array
int topDataClass::getSmp128Bin(int firstWindow, int smpNum){
	return (int( firstWindow )*64 + int( smpNum )) % 128;
}

//get pulse sample index out of 128 bin array
int topDataClass::getSmp256Bin(int firstWindow, int smpNum){
	return (int( firstWindow )*64 + int( smpNum )) % 256;
}

//get pulse position within sample
double topDataClass::getSmpPos(double smpNextY, double smpPrevY, double adc0){
	double edgeSlope = (smpNextY - smpPrevY)/1.;
    	double edgeTime = -1.;
	if(edgeSlope > 0 )
		edgeTime = (cfdFraction*adc0 - smpPrevY)/edgeSlope;
	
	return edgeTime;
}

//get pulse position within sample
double topDataClass::getSmpFixThreshPos(double smpNextY, double smpPrevY, double thresh){
	double edgeSlope = (smpNextY - smpPrevY)/1.;
    	double edgeTime = -1.;
	if(edgeSlope > 0 )
		edgeTime = (thresh - smpPrevY)/edgeSlope;
	
	return edgeTime;
}

//get pulse falling edge position within sample
double topDataClass::getSmpFallPos(double smpNextY, double smpPrevY, double adc0){
	double edgeSlope = (smpNextY - smpPrevY)/1.;
    	double edgeTime = -1.;
	if(edgeSlope < 0 )
		edgeTime = (cfdFraction*adc0 - smpPrevY)/edgeSlope;
	
	return edgeTime;
}

//get index in hit array corresponding to timing marker
int topDataClass::getTimingMarkerNHitNum(int entry, int &markerHitNum){

	if( entry < 0 || entry >= tr_top->GetEntries() ){
		std::cout << "getTimingMarkerTime : Invalid entry number input, exiting" << std::endl;
		return 0;
	}

	tr_top->GetEntry(entry);

	//loop over all the hits in the event, store accepted pulses
	bool markerFound = 0;
	markerHitNum = -1;
    	for( int i = 0 ; i < nhit ; i++ ){
		//get the ASIC row, column and channel associated with the PMT channel
		int asicMod = BII_2_Emod(pmtid_mcp[i], ch_mcp[i]);
		int asicRow = BII_2_ASICrow(pmtid_mcp[i], ch_mcp[i]);
		int asicCol = BII_2_ASICcol(pmtid_mcp[i], ch_mcp[i]);
		int asicCh  = BII_2_ASICch(pmtid_mcp[i], ch_mcp[i]);

		//only consider pulses in timing marker channel
		if( asicMod != marker_mod || asicRow != marker_row || asicCol != marker_col || asicCh != marker_ch )
			continue;

		//apply some additional slection for timing marker pulses here
		if( adc0_mcp[i] < 200. )
			continue;

		markerFound = 1;
		markerHitNum = i;
		break;
	}//end ROIs loop

	return markerFound;
}

//get timing marker time, given index in hit array
double topDataClass::measureMarkerTimeArrayEntry(int entry, bool useFTSWTDCCorr){
	//skip events not in arrays
  	if( entry >= maxNumEvt )
		return -1.E+6;

	int smpPosIn128Array = (int( mark_first_0_A[entry] )*64 + int( mark_smp_0_A[entry] )) % 128;
	int FTSWTDC = 0;
	if( useFTSWTDCCorr )
		FTSWTDC = ftsw_A[entry];
	return measurePulseTimeStandalone(mark_first_0_A[entry], mark_ref_0_A[entry], mark_smp_0_A[entry], FTSWTDC, FTSW_SCALE, avg128Period, smp128StartTimes, 
		mark_smpPrevY_0_A[entry], mark_smpNextY_0_A[entry], cfdFraction*mark_adc_0_A[entry]);
}

//make a graph based on the input histogram
int topDataClass::makeCorrectionGraph(TH2F *h2dIn, TGraphErrors *gOut, bool meanOrRms, double minEntries, double range, double maxErr){
	if( !h2dIn || ! gOut )
		return 0;

	//get slices from 2D histogram
  	int numBins = h2dIn->GetNbinsX();
  	TH1D *hBins[numBins];
  	char name[100];
  	for( int b = 0 ; b < numBins ; b++ ){
		memset(name,0,sizeof(char)*100 );
		sprintf(name,"bin_%.2i",b);
		hBins[b] = h2dIn->ProjectionY(name,b+1,b+1);
	}

  	//find maximum point in each vertical slice above 100 ADC
	int errCount = 0;
  	for( int b = 0 ; b < numBins ; b++ ){
		if( hBins[b]->GetEntries() < minEntries ){
			if( errCount < 10 )
				std::cout << "Bin does not have enough entries, continue. Only flag first 10 instances of error." << std::endl;
			errCount++;
			continue;
		}
		double binVal = h2dIn->GetBinCenter(b+1);
		double posMax = hBins[b]->GetBinCenter( hBins[b]->GetMaximumBin() );

		hBins[b]->GetXaxis()->SetRangeUser( posMax - range, posMax + range);

		double fitRange = hBins[b]->GetRMS()*2.0;
		//std::cout << "bin # " << b << "\t" << posMax << std::endl;

		TF1 *gfit = new TF1("Gaussian","gaus",posMax - fitRange, posMax + fitRange);
		gfit->SetLineColor(kRed);
		hBins[b]->Fit("Gaussian","QR"); 
	
		if( meanOrRms == 0 ){
			if( gfit->GetParError(1) < maxErr ){
				gOut->SetPoint( gOut->GetN(), binVal, gfit->GetParameter(1) );		
				gOut->SetPointError( gOut->GetN()-1, 0, gfit->GetParError(1) );
			}
		}
		else{
			if( gfit->GetParError(2) < maxErr ){
				gOut->SetPoint( gOut->GetN(), binVal, gfit->GetParameter(2) );	
				gOut->SetPointError( gOut->GetN()-1, 0, gfit->GetParError(2) );
			}
		}

		delete gfit;
  	}

	if( gOut->GetN() < 3 )
		return 0;

	return 1;
}
