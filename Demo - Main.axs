PROGRAM_NAME='Demo - Main'
(***********************************************************)
(*  FILE CREATED ON: 02/12/2015  AT: 12:21:06              *)
(***********************************************************)
(*  FILE_LAST_MODIFIED_ON: 02/16/2015  AT: 08:20:11        *)
(***********************************************************)

define_device

dvWEB		= 00000:04:001;
vdvWEB 	= 33001:01:001;

define_constant

integer nChns[] = {
	01,02,03,04,05,
	06,07,08,09,10,
	11,12,13,14,15,
	16,17,18,19,20,
	21,22,23,24,25,
	26,27,28,29,30
} 

define_module 'Web_Svc_Comm' mdmWEB01(vdvWEB,dvWEB);

define_event

data_event[vdvWEB] {
	online: {
		wait 10 'send_params' {
			send_command vdvWeb,'IP-172.16.76.31';
			send_command vdvWeb,'PORT-8000';
			send_command vdvWeb,'REINIT';
		}
	}
	string: {
		send_string 0,"'>> vdvWEB String Received -->', data.text";
	}
}

level_event[vdvWEB,1] {
	send_string 0,"'>> vdvWEB Level Received -->', itoa(level.value)";
}

channel_event[vdvWEB,nChns] {
	on: {
		send_string 0,"'>> vdvWEB Channel On  -->', itoa(channel.channel)";
	}
	off: {
		send_string 0,"'>> vdvWEB Channel Off -->', itoa(channel.channel)";
	}
}