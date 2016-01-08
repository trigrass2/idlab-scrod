#ChipScope Core Inserter Project File Version 3.0
#Sat Dec 06 13:31:59 HST 2014
Project.device.designInputFile=C\:\\Users\\isar\\Documents\\code4\\TX9UMB-3\\ise-project\\scrod_top_A4.ngc
Project.device.designOutputFile=C\:\\Users\\isar\\Documents\\code4\\TX9UMB-3\\ise-project\\scrod_top_A4_csp.ngc
Project.device.deviceFamily=18
Project.device.enableRPMs=true
Project.device.outputDirectory=C\:\\Users\\isar\\Documents\\code4\\TX9UMB-3\\ise-project\\_ngo
Project.device.useSRL16=true
Project.filter.dimension=19
Project.filter<0>=internal_waveform*
Project.filter<10>=fifo
Project.filter<11>=dmx_*
Project.filter<12>=dmx_win*
Project.filter<13>=dmx2_win*
Project.filter<14>=dmx_win
Project.filter<15>=internal*
Project.filter<16>=readout*
Project.filter<17>=*
Project.filter<18>=jdx*
Project.filter<1>=waveform*
Project.filter<2>=
Project.filter<3>=psw*
Project.filter<4>=dmx_bit*
Project.filter<5>=fifo_din_i2*
Project.filter<6>=fifo_en*
Project.filter<7>=fifo_din*
Project.filter<8>=fifo_din_i*
Project.filter<9>=fifo*
Project.icon.boundaryScanChain=1
Project.icon.enableExtTriggerIn=false
Project.icon.enableExtTriggerOut=false
Project.icon.triggerInPinName=
Project.icon.triggerOutPinName=
Project.unit.dimension=1
Project.unit<0>.clockChannel=map_clock_gen CLOCK_FPGA_LOGIC
Project.unit<0>.clockEdge=Rising
Project.unit<0>.dataChannel<0>=u_SamplingLgc sstin
Project.unit<0>.dataChannel<100>=map_event_builder WAVEFORM_FIFO_READ_ENABLE
Project.unit<0>.dataChannel<101>=map_event_builder FIFO_DATA_OUT<31>
Project.unit<0>.dataChannel<102>=map_event_builder FIFO_DATA_OUT<30>
Project.unit<0>.dataChannel<103>=map_event_builder FIFO_DATA_OUT<29>
Project.unit<0>.dataChannel<104>=map_event_builder FIFO_DATA_OUT<28>
Project.unit<0>.dataChannel<105>=map_event_builder FIFO_DATA_OUT<27>
Project.unit<0>.dataChannel<106>=map_event_builder FIFO_DATA_OUT<26>
Project.unit<0>.dataChannel<107>=map_event_builder FIFO_DATA_OUT<25>
Project.unit<0>.dataChannel<108>=map_event_builder FIFO_DATA_OUT<24>
Project.unit<0>.dataChannel<109>=map_event_builder FIFO_DATA_OUT<23>
Project.unit<0>.dataChannel<10>=u_SamplingLgc wr_addrclr
Project.unit<0>.dataChannel<110>=map_event_builder FIFO_DATA_OUT<22>
Project.unit<0>.dataChannel<111>=map_event_builder FIFO_DATA_OUT<21>
Project.unit<0>.dataChannel<112>=map_event_builder FIFO_DATA_OUT<20>
Project.unit<0>.dataChannel<113>=map_event_builder FIFO_DATA_OUT<19>
Project.unit<0>.dataChannel<114>=map_event_builder FIFO_DATA_OUT<18>
Project.unit<0>.dataChannel<115>=map_event_builder FIFO_DATA_OUT<17>
Project.unit<0>.dataChannel<116>=map_event_builder FIFO_DATA_OUT<16>
Project.unit<0>.dataChannel<117>=map_event_builder FIFO_DATA_OUT<15>
Project.unit<0>.dataChannel<118>=map_event_builder FIFO_DATA_OUT<14>
Project.unit<0>.dataChannel<119>=map_event_builder FIFO_DATA_OUT<13>
Project.unit<0>.dataChannel<11>=u_wavedemux pswfifo_d<30>
Project.unit<0>.dataChannel<120>=map_event_builder FIFO_DATA_OUT<12>
Project.unit<0>.dataChannel<121>=map_event_builder FIFO_DATA_OUT<11>
Project.unit<0>.dataChannel<122>=map_event_builder FIFO_DATA_OUT<10>
Project.unit<0>.dataChannel<123>=map_event_builder FIFO_DATA_OUT<9>
Project.unit<0>.dataChannel<124>=map_event_builder FIFO_DATA_OUT<8>
Project.unit<0>.dataChannel<125>=map_event_builder FIFO_DATA_OUT<7>
Project.unit<0>.dataChannel<126>=map_event_builder FIFO_DATA_OUT<6>
Project.unit<0>.dataChannel<127>=map_event_builder FIFO_DATA_OUT<5>
Project.unit<0>.dataChannel<128>=map_event_builder FIFO_DATA_OUT<4>
Project.unit<0>.dataChannel<129>=map_event_builder FIFO_DATA_OUT<3>
Project.unit<0>.dataChannel<12>=u_wavedemux pswfifo_d<29>
Project.unit<0>.dataChannel<130>=map_event_builder FIFO_DATA_OUT<2>
Project.unit<0>.dataChannel<131>=map_event_builder FIFO_DATA_OUT<1>
Project.unit<0>.dataChannel<132>=map_event_builder FIFO_DATA_OUT<0>
Project.unit<0>.dataChannel<133>=map_event_builder internal_START_BUILDING_EVENT_REG<0>
Project.unit<0>.dataChannel<134>=map_event_builder internal_START_BUILDING_EVENT_REG<1>
Project.unit<0>.dataChannel<135>=map_event_builder internal_PACKET_COUNTER<3>
Project.unit<0>.dataChannel<136>=map_event_builder internal_PACKET_COUNTER<2>
Project.unit<0>.dataChannel<137>=map_event_builder internal_PACKET_COUNTER<1>
Project.unit<0>.dataChannel<138>=map_event_builder internal_PACKET_COUNTER<0>
Project.unit<0>.dataChannel<139>=map_event_builder internal_PACKET_COUNTER<7>
Project.unit<0>.dataChannel<13>=u_wavedemux pswfifo_d<28>
Project.unit<0>.dataChannel<140>=map_event_builder internal_PACKET_COUNTER<6>
Project.unit<0>.dataChannel<141>=map_event_builder internal_PACKET_COUNTER<5>
Project.unit<0>.dataChannel<142>=map_event_builder internal_PACKET_COUNTER<4>
Project.unit<0>.dataChannel<143>=map_event_builder FIFO_DATA_VALID
Project.unit<0>.dataChannel<144>=map_event_builder FIFO_EMPTY
Project.unit<0>.dataChannel<145>=u_OutputBufferControl REQUEST_PACKET
Project.unit<0>.dataChannel<146>=u_OutputBufferControl EVTBUILD_DONE
Project.unit<0>.dataChannel<147>=u_OutputBufferControl WAVEFORM_FIFO_EMPTY
Project.unit<0>.dataChannel<148>=u_OutputBufferControl internal_EVTBUILD_DONE
Project.unit<0>.dataChannel<149>=u_OutputBufferControl internal_REQUEST_PACKET_reg<0>
Project.unit<0>.dataChannel<14>=u_wavedemux pswfifo_d<26>
Project.unit<0>.dataChannel<150>=u_OutputBufferControl internal_REQUEST_PACKET_reg<1>
Project.unit<0>.dataChannel<151>=u_OutputBufferControl WAVEFORM_FIFO_READ_ENABLE
Project.unit<0>.dataChannel<152>=u_OutputBufferControl BUFFER_FIFO_WR_EN
Project.unit<0>.dataChannel<153>=u_OutputBufferControl EVTBUILD_START
Project.unit<0>.dataChannel<154>=u_OutputBufferControl EVTBUILD_MAKE_READY
Project.unit<0>.dataChannel<155>=u_OutputBufferControl BUFFER_FIFO_DIN<31>
Project.unit<0>.dataChannel<156>=u_OutputBufferControl BUFFER_FIFO_DIN<30>
Project.unit<0>.dataChannel<157>=u_OutputBufferControl BUFFER_FIFO_DIN<29>
Project.unit<0>.dataChannel<158>=u_OutputBufferControl BUFFER_FIFO_DIN<28>
Project.unit<0>.dataChannel<159>=u_OutputBufferControl BUFFER_FIFO_DIN<27>
Project.unit<0>.dataChannel<15>=u_wavedemux pswfifo_d<25>
Project.unit<0>.dataChannel<160>=u_OutputBufferControl BUFFER_FIFO_DIN<26>
Project.unit<0>.dataChannel<161>=u_OutputBufferControl BUFFER_FIFO_DIN<25>
Project.unit<0>.dataChannel<162>=u_OutputBufferControl BUFFER_FIFO_DIN<24>
Project.unit<0>.dataChannel<163>=u_OutputBufferControl BUFFER_FIFO_DIN<23>
Project.unit<0>.dataChannel<164>=u_OutputBufferControl BUFFER_FIFO_DIN<22>
Project.unit<0>.dataChannel<165>=u_OutputBufferControl BUFFER_FIFO_DIN<21>
Project.unit<0>.dataChannel<166>=u_OutputBufferControl BUFFER_FIFO_DIN<20>
Project.unit<0>.dataChannel<167>=u_OutputBufferControl BUFFER_FIFO_DIN<19>
Project.unit<0>.dataChannel<168>=u_OutputBufferControl BUFFER_FIFO_DIN<18>
Project.unit<0>.dataChannel<169>=u_OutputBufferControl BUFFER_FIFO_DIN<17>
Project.unit<0>.dataChannel<16>=u_wavedemux pswfifo_d<24>
Project.unit<0>.dataChannel<170>=u_OutputBufferControl BUFFER_FIFO_DIN<16>
Project.unit<0>.dataChannel<171>=u_OutputBufferControl BUFFER_FIFO_DIN<15>
Project.unit<0>.dataChannel<172>=u_OutputBufferControl BUFFER_FIFO_DIN<14>
Project.unit<0>.dataChannel<173>=u_OutputBufferControl BUFFER_FIFO_DIN<13>
Project.unit<0>.dataChannel<174>=u_OutputBufferControl BUFFER_FIFO_DIN<12>
Project.unit<0>.dataChannel<175>=u_OutputBufferControl BUFFER_FIFO_DIN<11>
Project.unit<0>.dataChannel<176>=u_OutputBufferControl BUFFER_FIFO_DIN<10>
Project.unit<0>.dataChannel<177>=u_OutputBufferControl BUFFER_FIFO_DIN<9>
Project.unit<0>.dataChannel<178>=u_OutputBufferControl BUFFER_FIFO_DIN<8>
Project.unit<0>.dataChannel<179>=u_OutputBufferControl BUFFER_FIFO_DIN<7>
Project.unit<0>.dataChannel<17>=u_wavedemux pswfifo_d<23>
Project.unit<0>.dataChannel<180>=u_OutputBufferControl BUFFER_FIFO_DIN<6>
Project.unit<0>.dataChannel<181>=u_OutputBufferControl BUFFER_FIFO_DIN<5>
Project.unit<0>.dataChannel<182>=u_OutputBufferControl BUFFER_FIFO_DIN<4>
Project.unit<0>.dataChannel<183>=u_OutputBufferControl BUFFER_FIFO_DIN<3>
Project.unit<0>.dataChannel<184>=u_OutputBufferControl BUFFER_FIFO_DIN<2>
Project.unit<0>.dataChannel<185>=u_OutputBufferControl BUFFER_FIFO_DIN<1>
Project.unit<0>.dataChannel<186>=u_OutputBufferControl BUFFER_FIFO_DIN<0>
Project.unit<0>.dataChannel<187>=u_OutputBufferControl INTERNAL_COUNTER<15>
Project.unit<0>.dataChannel<188>=u_OutputBufferControl INTERNAL_COUNTER<14>
Project.unit<0>.dataChannel<189>=u_OutputBufferControl INTERNAL_COUNTER<13>
Project.unit<0>.dataChannel<18>=u_wavedemux pswfifo_d<22>
Project.unit<0>.dataChannel<190>=u_OutputBufferControl INTERNAL_COUNTER<12>
Project.unit<0>.dataChannel<191>=u_OutputBufferControl INTERNAL_COUNTER<11>
Project.unit<0>.dataChannel<192>=u_OutputBufferControl INTERNAL_COUNTER<10>
Project.unit<0>.dataChannel<193>=u_OutputBufferControl INTERNAL_COUNTER<9>
Project.unit<0>.dataChannel<194>=u_OutputBufferControl INTERNAL_COUNTER<8>
Project.unit<0>.dataChannel<195>=u_OutputBufferControl INTERNAL_COUNTER<7>
Project.unit<0>.dataChannel<196>=u_OutputBufferControl INTERNAL_COUNTER<6>
Project.unit<0>.dataChannel<197>=u_OutputBufferControl INTERNAL_COUNTER<5>
Project.unit<0>.dataChannel<198>=u_OutputBufferControl INTERNAL_COUNTER<4>
Project.unit<0>.dataChannel<199>=u_OutputBufferControl INTERNAL_COUNTER<3>
Project.unit<0>.dataChannel<19>=u_wavedemux pswfifo_d<21>
Project.unit<0>.dataChannel<1>=u_SamplingLgc MAIN_CNT<8>
Project.unit<0>.dataChannel<200>=u_OutputBufferControl INTERNAL_COUNTER<2>
Project.unit<0>.dataChannel<201>=u_OutputBufferControl INTERNAL_COUNTER<1>
Project.unit<0>.dataChannel<202>=u_OutputBufferControl INTERNAL_COUNTER<0>
Project.unit<0>.dataChannel<203>=internal_WAVEFORM_FIFO_READ_ENABLE
Project.unit<0>.dataChannel<204>=internal_WAVEFORM_FIFO_DATA_OUT<15>
Project.unit<0>.dataChannel<205>=internal_WAVEFORM_FIFO_DATA_OUT<14>
Project.unit<0>.dataChannel<206>=internal_WAVEFORM_FIFO_DATA_OUT<13>
Project.unit<0>.dataChannel<207>=internal_WAVEFORM_FIFO_DATA_OUT<12>
Project.unit<0>.dataChannel<208>=internal_WAVEFORM_FIFO_DATA_OUT<11>
Project.unit<0>.dataChannel<209>=internal_WAVEFORM_FIFO_DATA_OUT<10>
Project.unit<0>.dataChannel<20>=u_wavedemux pswfifo_d<20>
Project.unit<0>.dataChannel<210>=internal_WAVEFORM_FIFO_DATA_OUT<9>
Project.unit<0>.dataChannel<211>=internal_WAVEFORM_FIFO_DATA_OUT<8>
Project.unit<0>.dataChannel<212>=internal_WAVEFORM_FIFO_DATA_OUT<7>
Project.unit<0>.dataChannel<213>=internal_WAVEFORM_FIFO_DATA_OUT<6>
Project.unit<0>.dataChannel<214>=internal_WAVEFORM_FIFO_DATA_OUT<5>
Project.unit<0>.dataChannel<215>=internal_WAVEFORM_FIFO_DATA_OUT<4>
Project.unit<0>.dataChannel<216>=internal_WAVEFORM_FIFO_DATA_OUT<3>
Project.unit<0>.dataChannel<217>=internal_WAVEFORM_FIFO_DATA_OUT<2>
Project.unit<0>.dataChannel<218>=internal_WAVEFORM_FIFO_DATA_OUT<1>
Project.unit<0>.dataChannel<219>=internal_WAVEFORM_FIFO_DATA_OUT<0>
Project.unit<0>.dataChannel<21>=u_wavedemux pswfifo_d<19>
Project.unit<0>.dataChannel<220>=internal_WAVEFORM_FIFO_DATA_OUT<31>
Project.unit<0>.dataChannel<221>=internal_WAVEFORM_FIFO_DATA_OUT<30>
Project.unit<0>.dataChannel<222>=internal_WAVEFORM_FIFO_DATA_OUT<29>
Project.unit<0>.dataChannel<223>=internal_WAVEFORM_FIFO_DATA_OUT<28>
Project.unit<0>.dataChannel<224>=internal_WAVEFORM_FIFO_DATA_OUT<27>
Project.unit<0>.dataChannel<225>=internal_WAVEFORM_FIFO_DATA_OUT<26>
Project.unit<0>.dataChannel<226>=internal_WAVEFORM_FIFO_DATA_OUT<25>
Project.unit<0>.dataChannel<227>=internal_WAVEFORM_FIFO_DATA_OUT<24>
Project.unit<0>.dataChannel<228>=internal_WAVEFORM_FIFO_DATA_OUT<23>
Project.unit<0>.dataChannel<229>=internal_WAVEFORM_FIFO_DATA_OUT<22>
Project.unit<0>.dataChannel<22>=u_wavedemux pswfifo_d<18>
Project.unit<0>.dataChannel<230>=internal_WAVEFORM_FIFO_DATA_OUT<21>
Project.unit<0>.dataChannel<231>=internal_WAVEFORM_FIFO_DATA_OUT<20>
Project.unit<0>.dataChannel<232>=internal_WAVEFORM_FIFO_DATA_OUT<19>
Project.unit<0>.dataChannel<233>=internal_WAVEFORM_FIFO_DATA_OUT<18>
Project.unit<0>.dataChannel<234>=internal_WAVEFORM_FIFO_DATA_OUT<17>
Project.unit<0>.dataChannel<235>=internal_WAVEFORM_FIFO_DATA_OUT<16>
Project.unit<0>.dataChannel<236>=internal_WAVEFORM_FIFO_EMPTY
Project.unit<0>.dataChannel<237>=internal_WAVEFORM_FIFO_DATA_VALID
Project.unit<0>.dataChannel<238>=u_wavedemux ped_dina<6>
Project.unit<0>.dataChannel<239>=u_wavedemux ped_dina<7>
Project.unit<0>.dataChannel<23>=u_wavedemux pswfifo_d<17>
Project.unit<0>.dataChannel<240>=u_wavedemux ped_dina<8>
Project.unit<0>.dataChannel<241>=u_wavedemux ped_dina<9>
Project.unit<0>.dataChannel<242>=u_wavedemux ped_dina<10>
Project.unit<0>.dataChannel<243>=u_wavedemux ped_dina<11>
Project.unit<0>.dataChannel<244>=u_wavedemux ped_doutb<0>
Project.unit<0>.dataChannel<245>=u_wavedemux ped_doutb<1>
Project.unit<0>.dataChannel<246>=u_wavedemux ped_doutb<2>
Project.unit<0>.dataChannel<247>=u_wavedemux ped_doutb<3>
Project.unit<0>.dataChannel<248>=u_wavedemux ped_doutb<4>
Project.unit<0>.dataChannel<249>=u_wavedemux ped_doutb<5>
Project.unit<0>.dataChannel<24>=u_wavedemux pswfifo_d<16>
Project.unit<0>.dataChannel<250>=u_wavedemux ped_doutb<6>
Project.unit<0>.dataChannel<251>=u_wavedemux ped_doutb<7>
Project.unit<0>.dataChannel<252>=u_wavedemux ped_doutb<8>
Project.unit<0>.dataChannel<253>=u_wavedemux ped_doutb<9>
Project.unit<0>.dataChannel<254>=u_wavedemux ped_doutb<10>
Project.unit<0>.dataChannel<255>=u_wavedemux ped_doutb<11>
Project.unit<0>.dataChannel<256>=u_wavedemux tmp2bram_ctr<4>
Project.unit<0>.dataChannel<257>=u_wavedemux tmp2bram_ctr<3>
Project.unit<0>.dataChannel<258>=u_wavedemux tmp2bram_ctr<2>
Project.unit<0>.dataChannel<259>=u_wavedemux tmp2bram_ctr<1>
Project.unit<0>.dataChannel<25>=u_wavedemux pswfifo_d<15>
Project.unit<0>.dataChannel<260>=u_wavedemux tmp2bram_ctr<0>
Project.unit<0>.dataChannel<261>=u_wavedemux start_tmp2bram_xfer
Project.unit<0>.dataChannel<262>=u_OutputBufferControl REQUEST_PACKET
Project.unit<0>.dataChannel<263>=u_OutputBufferControl EVTBUILD_DONE
Project.unit<0>.dataChannel<264>=u_wavedemux dmx2_win<0>
Project.unit<0>.dataChannel<265>=u_wavedemux dmx2_win<1>
Project.unit<0>.dataChannel<266>=u_OutputBufferControl WAVEFORM_FIFO_EMPTY
Project.unit<0>.dataChannel<267>=u_OutputBufferControl internal_EVTBUILD_DONE
Project.unit<0>.dataChannel<268>=u_OutputBufferControl EVTBUILD_START
Project.unit<0>.dataChannel<269>=u_OutputBufferControl EVTBUILD_MAKE_READY
Project.unit<0>.dataChannel<26>=u_wavedemux pswfifo_d<14>
Project.unit<0>.dataChannel<270>=u_OutputBufferControl WAVEFORM_FIFO_READ_ENABLE
Project.unit<0>.dataChannel<271>=u_ReadoutControl fifo_empty
Project.unit<0>.dataChannel<272>=u_ReadoutControl READOUT_RESET
Project.unit<0>.dataChannel<273>=u_ReadoutControl RESET_EVENT_NUM
Project.unit<0>.dataChannel<274>=u_wavedemux ct_sa<0>
Project.unit<0>.dataChannel<275>=u_wavedemux ct_sa<1>
Project.unit<0>.dataChannel<276>=u_wavedemux ct_sa<2>
Project.unit<0>.dataChannel<277>=u_wavedemux ct_sa<3>
Project.unit<0>.dataChannel<278>=u_wavedemux ct_sa<4>
Project.unit<0>.dataChannel<279>=u_wavedemux ct_sa<5>
Project.unit<0>.dataChannel<27>=u_wavedemux pswfifo_d<13>
Project.unit<0>.dataChannel<280>=u_wavedemux ct_sa<6>
Project.unit<0>.dataChannel<281>=u_wavedemux ped_wea_0
Project.unit<0>.dataChannel<282>=u_wavedemux pedsub_st_FSM_FFd1
Project.unit<0>.dataChannel<283>=u_wavedemux pedsub_st_FSM_FFd2
Project.unit<0>.dataChannel<284>=u_wavedemux pedsub_st_FSM_FFd3
Project.unit<0>.dataChannel<285>=u_wavedemux pedsub_st_FSM_FFd1-In
Project.unit<0>.dataChannel<286>=u_wavedemux pedsub_st_FSM_FFd2-In
Project.unit<0>.dataChannel<287>=u_wavedemux pedsub_st_FSM_FFd3-In
Project.unit<0>.dataChannel<288>=u_OutputBufferControl WAVEFORM_FIFO_READ_ENABLE
Project.unit<0>.dataChannel<289>=u_OutputBufferControl BUFFER_FIFO_WR_EN
Project.unit<0>.dataChannel<28>=u_wavedemux pswfifo_d<12>
Project.unit<0>.dataChannel<290>=u_OutputBufferControl EVTBUILD_START
Project.unit<0>.dataChannel<291>=u_OutputBufferControl EVTBUILD_MAKE_READY
Project.unit<0>.dataChannel<292>=internal_READCTRL_busy_status
Project.unit<0>.dataChannel<293>=u_wavedemux sapedsub<0>
Project.unit<0>.dataChannel<294>=u_wavedemux sapedsub<1>
Project.unit<0>.dataChannel<295>=u_wavedemux sapedsub<2>
Project.unit<0>.dataChannel<296>=u_wavedemux sapedsub<3>
Project.unit<0>.dataChannel<297>=u_wavedemux sapedsub<4>
Project.unit<0>.dataChannel<298>=u_wavedemux sapedsub<5>
Project.unit<0>.dataChannel<299>=u_wavedemux sapedsub<6>
Project.unit<0>.dataChannel<29>=u_wavedemux pswfifo_d<11>
Project.unit<0>.dataChannel<2>=u_SamplingLgc MAIN_CNT<7>
Project.unit<0>.dataChannel<300>=u_wavedemux sapedsub<7>
Project.unit<0>.dataChannel<301>=u_wavedemux sapedsub<8>
Project.unit<0>.dataChannel<302>=u_wavedemux sapedsub<9>
Project.unit<0>.dataChannel<303>=u_wavedemux sapedsub<10>
Project.unit<0>.dataChannel<304>=u_wavedemux sapedsub<11>
Project.unit<0>.dataChannel<305>=u_wavedemux fifo_din_i<0>
Project.unit<0>.dataChannel<306>=u_wavedemux fifo_din_i<1>
Project.unit<0>.dataChannel<307>=u_wavedemux fifo_din_i<2>
Project.unit<0>.dataChannel<308>=u_wavedemux fifo_din_i<3>
Project.unit<0>.dataChannel<309>=u_wavedemux fifo_din_i<4>
Project.unit<0>.dataChannel<30>=u_wavedemux pswfifo_d<10>
Project.unit<0>.dataChannel<310>=u_wavedemux fifo_din_i<5>
Project.unit<0>.dataChannel<311>=u_wavedemux fifo_din_i<6>
Project.unit<0>.dataChannel<312>=u_wavedemux fifo_din_i<7>
Project.unit<0>.dataChannel<313>=u_wavedemux fifo_din_i<8>
Project.unit<0>.dataChannel<314>=u_wavedemux fifo_din_i<9>
Project.unit<0>.dataChannel<315>=u_wavedemux fifo_din_i<10>
Project.unit<0>.dataChannel<316>=u_wavedemux fifo_din_i<11>
Project.unit<0>.dataChannel<317>=u_wavedemux fifo_din_i<12>
Project.unit<0>.dataChannel<318>=u_wavedemux fifo_din_i<13>
Project.unit<0>.dataChannel<319>=u_wavedemux fifo_din_i<14>
Project.unit<0>.dataChannel<31>=u_wavedemux pswfifo_d<9>
Project.unit<0>.dataChannel<320>=u_wavedemux fifo_din_i<15>
Project.unit<0>.dataChannel<321>=u_wavedemux fifo_din_i<16>
Project.unit<0>.dataChannel<322>=u_wavedemux fifo_din_i<17>
Project.unit<0>.dataChannel<323>=u_wavedemux fifo_din_i<18>
Project.unit<0>.dataChannel<324>=u_wavedemux fifo_din_i<19>
Project.unit<0>.dataChannel<325>=u_wavedemux fifo_din_i<20>
Project.unit<0>.dataChannel<326>=u_wavedemux fifo_din_i<21>
Project.unit<0>.dataChannel<327>=u_wavedemux fifo_din_i<22>
Project.unit<0>.dataChannel<328>=u_wavedemux fifo_din_i<23>
Project.unit<0>.dataChannel<329>=u_wavedemux fifo_din_i<24>
Project.unit<0>.dataChannel<32>=u_wavedemux pswfifo_d<8>
Project.unit<0>.dataChannel<330>=u_wavedemux fifo_din_i<25>
Project.unit<0>.dataChannel<331>=u_wavedemux fifo_din_i<26>
Project.unit<0>.dataChannel<332>=u_wavedemux fifo_din_i<27>
Project.unit<0>.dataChannel<333>=u_wavedemux fifo_din_i<28>
Project.unit<0>.dataChannel<334>=u_wavedemux fifo_din_i<29>
Project.unit<0>.dataChannel<335>=u_wavedemux fifo_din_i<30>
Project.unit<0>.dataChannel<336>=u_wavedemux fifo_din_i<31>
Project.unit<0>.dataChannel<337>=u_wavedemux fifo_en
Project.unit<0>.dataChannel<338>=u_wavedemux fifo_en_i
Project.unit<0>.dataChannel<339>=u_wavedemux fifo_din_i2<16>
Project.unit<0>.dataChannel<33>=u_wavedemux pswfifo_d<7>
Project.unit<0>.dataChannel<340>=u_wavedemux fifo_din_i2<17>
Project.unit<0>.dataChannel<341>=u_wavedemux pswfifo_d<27>
Project.unit<0>.dataChannel<342>=u_ReadoutControl internal_READOUT_DONE
Project.unit<0>.dataChannel<34>=u_wavedemux pswfifo_d<6>
Project.unit<0>.dataChannel<35>=u_wavedemux pswfifo_d<5>
Project.unit<0>.dataChannel<36>=u_wavedemux pswfifo_d<4>
Project.unit<0>.dataChannel<37>=u_wavedemux pswfifo_d<3>
Project.unit<0>.dataChannel<38>=u_wavedemux pswfifo_d<2>
Project.unit<0>.dataChannel<39>=u_wavedemux pswfifo_d<1>
Project.unit<0>.dataChannel<3>=u_SamplingLgc MAIN_CNT<6>
Project.unit<0>.dataChannel<40>=u_wavedemux pswfifo_d<0>
Project.unit<0>.dataChannel<41>=u_wavedemux pswfifo_en
Project.unit<0>.dataChannel<42>=u_wavedemux fifo_en
Project.unit<0>.dataChannel<43>=u_DigitizingLgc StartDig
Project.unit<0>.dataChannel<44>=u_DigitizingLgc clr_out
Project.unit<0>.dataChannel<45>=u_DigitizingLgc rd_ena_out
Project.unit<0>.dataChannel<46>=u_DigitizingLgc startramp_out
Project.unit<0>.dataChannel<47>=u_ReadoutControl internal_busy_status
Project.unit<0>.dataChannel<48>=u_ReadoutControl internal_dig_start
Project.unit<0>.dataChannel<49>=u_ReadoutControl internal_srout_start
Project.unit<0>.dataChannel<4>=u_SamplingLgc MAIN_CNT<5>
Project.unit<0>.dataChannel<50>=u_ReadoutControl internal_DIG_IDLE_status
Project.unit<0>.dataChannel<51>=u_ReadoutControl internal_SROUT_IDLE_status
Project.unit<0>.dataChannel<52>=map_event_builder EVENT_NUMBER_WORD<10>
Project.unit<0>.dataChannel<53>=map_event_builder EVENT_NUMBER_WORD<9>
Project.unit<0>.dataChannel<54>=map_event_builder EVENT_NUMBER_WORD<8>
Project.unit<0>.dataChannel<55>=map_event_builder EVENT_NUMBER_WORD<7>
Project.unit<0>.dataChannel<56>=map_event_builder EVENT_NUMBER_WORD<6>
Project.unit<0>.dataChannel<57>=map_event_builder EVENT_NUMBER_WORD<5>
Project.unit<0>.dataChannel<58>=map_event_builder EVENT_NUMBER_WORD<4>
Project.unit<0>.dataChannel<59>=map_event_builder EVENT_NUMBER_WORD<3>
Project.unit<0>.dataChannel<5>=u_SamplingLgc MAIN_CNT<4>
Project.unit<0>.dataChannel<60>=map_event_builder EVENT_NUMBER_WORD<2>
Project.unit<0>.dataChannel<61>=map_event_builder EVENT_NUMBER_WORD<1>
Project.unit<0>.dataChannel<62>=map_event_builder EVENT_NUMBER_WORD<0>
Project.unit<0>.dataChannel<63>=map_event_builder WAVEFORM_FIFO_DATA<31>
Project.unit<0>.dataChannel<64>=map_event_builder WAVEFORM_FIFO_DATA<30>
Project.unit<0>.dataChannel<65>=map_event_builder WAVEFORM_FIFO_DATA<29>
Project.unit<0>.dataChannel<66>=map_event_builder WAVEFORM_FIFO_DATA<28>
Project.unit<0>.dataChannel<67>=map_event_builder WAVEFORM_FIFO_DATA<27>
Project.unit<0>.dataChannel<68>=map_event_builder WAVEFORM_FIFO_DATA<26>
Project.unit<0>.dataChannel<69>=map_event_builder WAVEFORM_FIFO_DATA<25>
Project.unit<0>.dataChannel<6>=u_SamplingLgc MAIN_CNT<3>
Project.unit<0>.dataChannel<70>=map_event_builder WAVEFORM_FIFO_DATA<24>
Project.unit<0>.dataChannel<71>=map_event_builder WAVEFORM_FIFO_DATA<23>
Project.unit<0>.dataChannel<72>=map_event_builder WAVEFORM_FIFO_DATA<22>
Project.unit<0>.dataChannel<73>=map_event_builder WAVEFORM_FIFO_DATA<21>
Project.unit<0>.dataChannel<74>=map_event_builder WAVEFORM_FIFO_DATA<20>
Project.unit<0>.dataChannel<75>=map_event_builder WAVEFORM_FIFO_DATA<19>
Project.unit<0>.dataChannel<76>=map_event_builder WAVEFORM_FIFO_DATA<18>
Project.unit<0>.dataChannel<77>=map_event_builder WAVEFORM_FIFO_DATA<17>
Project.unit<0>.dataChannel<78>=map_event_builder WAVEFORM_FIFO_DATA<16>
Project.unit<0>.dataChannel<79>=map_event_builder WAVEFORM_FIFO_DATA<15>
Project.unit<0>.dataChannel<7>=u_SamplingLgc MAIN_CNT<2>
Project.unit<0>.dataChannel<80>=map_event_builder WAVEFORM_FIFO_DATA<14>
Project.unit<0>.dataChannel<81>=map_event_builder WAVEFORM_FIFO_DATA<13>
Project.unit<0>.dataChannel<82>=map_event_builder WAVEFORM_FIFO_DATA<12>
Project.unit<0>.dataChannel<83>=map_event_builder WAVEFORM_FIFO_DATA<11>
Project.unit<0>.dataChannel<84>=map_event_builder WAVEFORM_FIFO_DATA<10>
Project.unit<0>.dataChannel<85>=map_event_builder WAVEFORM_FIFO_DATA<9>
Project.unit<0>.dataChannel<86>=map_event_builder WAVEFORM_FIFO_DATA<8>
Project.unit<0>.dataChannel<87>=map_event_builder WAVEFORM_FIFO_DATA<7>
Project.unit<0>.dataChannel<88>=map_event_builder WAVEFORM_FIFO_DATA<6>
Project.unit<0>.dataChannel<89>=map_event_builder WAVEFORM_FIFO_DATA<5>
Project.unit<0>.dataChannel<8>=u_SamplingLgc MAIN_CNT<1>
Project.unit<0>.dataChannel<90>=map_event_builder WAVEFORM_FIFO_DATA<4>
Project.unit<0>.dataChannel<91>=map_event_builder WAVEFORM_FIFO_DATA<3>
Project.unit<0>.dataChannel<92>=map_event_builder WAVEFORM_FIFO_DATA<2>
Project.unit<0>.dataChannel<93>=map_event_builder WAVEFORM_FIFO_DATA<1>
Project.unit<0>.dataChannel<94>=map_event_builder WAVEFORM_FIFO_DATA<0>
Project.unit<0>.dataChannel<95>=map_event_builder START_BUILDING_EVENT
Project.unit<0>.dataChannel<96>=map_event_builder MAKE_READY
Project.unit<0>.dataChannel<97>=map_event_builder WAVEFORM_FIFO_DATA_VALID
Project.unit<0>.dataChannel<98>=map_event_builder WAVEFORM_FIFO_EMPTY
Project.unit<0>.dataChannel<99>=map_event_builder FIFO_READ_ENABLE
Project.unit<0>.dataChannel<9>=u_SamplingLgc MAIN_CNT<0>
Project.unit<0>.dataDepth=8192
Project.unit<0>.dataEqualsTrigger=false
Project.unit<0>.dataPortWidth=238
Project.unit<0>.enableGaps=false
Project.unit<0>.enableStorageQualification=true
Project.unit<0>.enableTimestamps=false
Project.unit<0>.timestampDepth=0
Project.unit<0>.timestampWidth=0
Project.unit<0>.triggerChannel<0><0>=u_ReadoutControl trigger
Project.unit<0>.triggerChannel<0><10>=u_SamplingLgc wr_addrclr
Project.unit<0>.triggerChannel<0><11>=u_DigitizingLgc StartDig
Project.unit<0>.triggerChannel<0><12>=u_DigitizingLgc rd_ena_out
Project.unit<0>.triggerChannel<0><13>=internal_WAVEFORM_FIFO_READ_ENABLE
Project.unit<0>.triggerChannel<0><14>=internal_WAVEFORM_FIFO_EMPTY
Project.unit<0>.triggerChannel<0><15>=internal_WAVEFORM_FIFO_DATA_VALID
Project.unit<0>.triggerChannel<0><1>=u_wavedemux fifo_en
Project.unit<0>.triggerChannel<0><2>=u_wavedemux pswfifo_en
Project.unit<0>.triggerChannel<0><3>=uut_pedram WEb
Project.unit<0>.triggerChannel<0><4>=uut_pedram OEb
Project.unit<0>.triggerChannel<0><5>=uut_pedram update_req<2>
Project.unit<0>.triggerChannel<0><6>=u_ReadoutControl internal_LATCH_DONE
Project.unit<0>.triggerChannel<0><7>=u_SerialDataRout fifo_wr_en
Project.unit<0>.triggerChannel<0><8>=uut_pedram update_req<2>
Project.unit<0>.triggerChannel<0><9>=u_SerialDataRout start
Project.unit<0>.triggerChannel<1><0>=u_wavedemux ped_sub_start<0>
Project.unit<0>.triggerChannel<1><10>=u_OutputBufferControl WAVEFORM_FIFO_EMPTY
Project.unit<0>.triggerChannel<1><11>=u_OutputBufferControl internal_EVTBUILD_DONE
Project.unit<0>.triggerChannel<1><12>=u_OutputBufferControl internal_REQUEST_PACKET_reg<0>
Project.unit<0>.triggerChannel<1><13>=u_OutputBufferControl internal_REQUEST_PACKET_reg<1>
Project.unit<0>.triggerChannel<1><14>=u_OutputBufferControl WAVEFORM_FIFO_READ_ENABLE
Project.unit<0>.triggerChannel<1><15>=u_OutputBufferControl BUFFER_FIFO_WR_EN
Project.unit<0>.triggerChannel<1><16>=u_OutputBufferControl BUFFER_FIFO_RESET
Project.unit<0>.triggerChannel<1><17>=u_OutputBufferControl EVTBUILD_MAKE_READY
Project.unit<0>.triggerChannel<1><18>=u_OutputBufferControl EVTBUILD_START
Project.unit<0>.triggerChannel<1><19>=internal_READCTRL_busy_status
Project.unit<0>.triggerChannel<1><1>=u_wavedemux ped_sub_start<1>
Project.unit<0>.triggerChannel<1><2>=u_wavedemux ped_wea_0
Project.unit<0>.triggerChannel<1><3>=u_wavedemux ped_sa_update
Project.unit<0>.triggerChannel<1><4>=u_wavedemux ped_sub_fetch_busy
Project.unit<0>.triggerChannel<1><5>=u_wavedemux dmx_allwin_busy
Project.unit<0>.triggerChannel<1><6>=u_wavedemux pswfifo_en
Project.unit<0>.triggerChannel<1><7>=u_wavedemux dmx2_win<0>
Project.unit<0>.triggerChannel<1><8>=u_OutputBufferControl REQUEST_PACKET
Project.unit<0>.triggerChannel<1><9>=u_OutputBufferControl EVTBUILD_DONE
Project.unit<0>.triggerChannel<2><0>=map_event_builder START_BUILDING_EVENT
Project.unit<0>.triggerChannel<2><1>=map_event_builder MAKE_READY
Project.unit<0>.triggerChannel<2><2>=map_event_builder WAVEFORM_FIFO_DATA_VALID
Project.unit<0>.triggerChannel<2><3>=map_event_builder WAVEFORM_FIFO_EMPTY
Project.unit<0>.triggerChannel<2><4>=map_event_builder FIFO_READ_ENABLE
Project.unit<0>.triggerChannel<2><5>=map_event_builder FIFO_DATA_VALID
Project.unit<0>.triggerChannel<2><6>=map_event_builder FIFO_EMPTY
Project.unit<0>.triggerChannel<2><7>=map_event_builder internal_START_BUILDING_EVENT_REG<0>
Project.unit<0>.triggerConditionCountWidth=0
Project.unit<0>.triggerMatchCount<0>=1
Project.unit<0>.triggerMatchCount<1>=1
Project.unit<0>.triggerMatchCount<2>=1
Project.unit<0>.triggerMatchCountWidth<0><0>=0
Project.unit<0>.triggerMatchCountWidth<1><0>=0
Project.unit<0>.triggerMatchCountWidth<2><0>=0
Project.unit<0>.triggerMatchType<0><0>=1
Project.unit<0>.triggerMatchType<1><0>=1
Project.unit<0>.triggerMatchType<2><0>=1
Project.unit<0>.triggerPortCount=3
Project.unit<0>.triggerPortIsData<0>=true
Project.unit<0>.triggerPortIsData<1>=true
Project.unit<0>.triggerPortIsData<2>=true
Project.unit<0>.triggerPortWidth<0>=16
Project.unit<0>.triggerPortWidth<1>=20
Project.unit<0>.triggerPortWidth<2>=8
Project.unit<0>.triggerSequencerLevels=16
Project.unit<0>.triggerSequencerType=1
Project.unit<0>.type=ilapro