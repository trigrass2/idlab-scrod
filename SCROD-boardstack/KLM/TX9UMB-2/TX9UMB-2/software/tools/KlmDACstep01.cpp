#include <iostream>
#include <cstdlib>
#include <unistd.h>
#include <stdio.h>

#include "base/KlmSystem.h"


using namespace std;

int main(int argc, char** argv)
{

	//const int Ncards=10;
	const int Nch=16;

	if(argc != 2)
	{
		cout << "USAGE: KlmTestTriggers <board_id>" << endl;
		return 1;
	}

	KlmModule* module;

	// init the system
	KlmSystem::KLM().initialize(std::cout);

	// get the module
	module = KlmSystem::KLM()[atoi(argv[1])];
	if(!module)
	{
		cout << "ERROR: Module " << atoi(argv[1]) << " not found!" << endl;
		// clear the system
		KlmSystem::Cleanup();
		return 0;
	}

	//initialize the DAC loading and latch period registers to something reasonable
	module->write_register(5, 128, true);
	module->write_register(6, 320, true);

	//reset and enable trigger scalers
	module->write_register(70, 0, true); //disable
	module->write_register(71, 0, true); //reset counters low
	module->write_register(71, 1, true); //reset counters high
	module->write_register(71, 0, true); //reset counters low
	module->write_register(70, 1, true); //enable

	//start a text file for output
	FILE*fout=fopen("outdir/output.txt","wt");
	fprintf(fout,"threshold,cardno,chno,hval,count\n");

	//iterate over channels, vary thresholds each iteration. Automatically test all DC on MB each iteration
	//const int NCards=10;int Cards[NCards]={0,1,2,3,4,5,6,7,8,9};
	const int NCards=1;int Cards[NCards]={4};
	//const int Nhval=6;int hval[Nhval]={0,50,100,150,200,255};
	const int Nhval=3;int hval[Nhval]={10,120,240};
	//const int Nhval=7;int hval[Nhval]={0,10,20,30,40,50,60};
	//const int Nhval=30;int hval[Nhval]; for (int i=0;i<Nhval;i++) hval[i]=i*6;


	for (int ihval=0;ihval<Nhval;ihval++)
	{
usleep(100000);
		for(int chno = 0 ; chno< Nch ; chno++)
		{
			int count[NCards];
			//loop over channel trigger threshold values
			//for(int i = 0 ; i < 1 ; i+=15)
			{
				int threshold = 1350;//1350+i;

				for(int cardidx = 0 ; cardidx < NCards ; cardidx++)
				{
					scrod_register HVval,HVvalout;
					HVval=(Cards[cardidx]<<12) | (chno <<8) | (hval[ihval]&255);
					HVvalout=HVval;//(HVval&0x00FF)<<8 | (HVval&0xFF00)>>8;
					module->write_register(60,HVvalout,true);
					//module->write_register(60,HVvalout,true);

					//printf("HVval=%x\n",HVvalout);
					usleep(100);
				}


				//reset scalers
				//module->write_register(71, 1, true); //reset counters high
				//module->write_register(71, 0, true); //reset counters low

				//write thresholds - set non-zero threshold for one channel on each daughter card
			/*	for(int cardidx = 0 ; cardidx < NCards ; cardidx++)
				{
					module->write_ASIC_register(Cards[cardidx], chno, threshold);
					usleep(100);
				}*/

				/*for(int cardidx = 0 ; cardidx < NCards ; cardidx++)
				{
					scrod_register HVval,HVvalout;
					HVval=(Cards[cardidx]<<12) | (chno <<8) | (hval[ihval]&255);
					HVvalout=HVval;//(HVval&0x00FF)<<8 | (HVval&0xFF00)>>8;
					module->write_register(60,HVvalout,true);
					//printf("HVval=%x\n",HVvalout);
					usleep(100);
				}*/

			//wait some time
				usleep(100);

				//read scalers - read trigger scaler for each daughter card
				/*for(int cardidx = 0 ; cardidx < NCards ; cardidx++)
					count[cardidx] = module->read_register(266 + Cards[cardidx]);
*/


			//do something with scalars
				//std::cout << "Threshold\t" << threshold << std::endl;
				/*for(int cardidx = 0 ; cardidx < NCards ; cardidx++){
					std::cout << "th: "<< threshold << "\tCard: # " << Cards[cardidx] << ",Channel # " << chno << ",Hval= "<<hval[ihval] << ",Counter=" << count[cardidx] << std::endl;
					fprintf(fout,"%d, %d, %d, %d, %d\n",threshold,Cards[cardidx],chno,hval[ihval],count[cardidx]);
				}*/

			}
		//reset thresholds to 0
/*		for(int cardidx = 0 ; cardidx < NCards ; cardidx++)
				module->write_ASIC_register(Cards[cardidx], chno, 0);
*/
/*		for(int cardidx = 0 ; cardidx < NCards ; cardidx++)
								{
									scrod_register HVval,HVvalout;
									HVval=(Cards[cardidx]<<12) | (chno <<8) | (hval[ihval]&255);
									HVvalout=HVval;//(HVval&0x00FF)<<8 | (HVval&0xFF00)>>8;
									module->write_register(60,HVvalout,true);
									//printf("HVval=%x\n",HVvalout);
									usleep(100);
								}
*/
		}
	}

	fclose(fout);
	// clear the system
	KlmSystem::Cleanup();
}
