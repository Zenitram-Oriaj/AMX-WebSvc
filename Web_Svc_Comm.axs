module_name = 'Web_Svc_Comm' (
	dev vdvWEB,
	dev dvWEB
)

(***********************************************************)
(*  FILE CREATED ON: 02/12/2015  AT: 12:21:46              *)
(***********************************************************)
(*  FILE_LAST_MODIFIED_ON: 02/16/2015  AT: 23:24:10        *)
(***********************************************************)
#define devices 1

#if_not_defined devices

define_device

dvWEB		= 00000:04:000;
vdvWEB	= 33001:01:000;

#end_if

define_constant

char null[] = '';

long FILEBUFF = 131072;			//128K is the maximum file S
long FILECHNK = 1400;

long S01K = 1024;
long S02K = 2048;
long S04K = 4096;
long S06K = 6144;
long S08K = 8192;
long S14K = 14336;
long S16K = 16384;
long S32K = 32768;
long S64K = 65536;

define_constant

integer dbgOFF = 0;
integer dbgERR = 1;
integer dbgWRN = 2;
integer dbgDAT = 3;
integer dbgALL = 4;

define_type

struct _svc {
	char name[32];						// Web Service Name
	char title[32];						// Web Service (Page) Title
	char ip[16];							// Local IP Address Of AMX
	integer port;							// Web Service Port
	
	integer lvls[8];					// Stored Levels
	integer chns[8];					// Shored Channels (1 - 8);
}

struct _req {
	char type[8];
	char url[64];
	char file[32];
	
	char cmd[16];
	char val[16];
}

define_variable

volatile _svc svc;
volatile _req req;

volatile integer dbg = 0;

define_function init() {
	stack_var integer i;
	
	svc.title = 'Web Service';
	svc.ip = '172.16.76.31';
	svc.port = 8080;
	svc.name = 'WEB';
	
	for(i = 1; i <= 8; i++){
		svc.lvls[i] = 0;
		svc.chns[i] = 0;
	}
	
	run();
}

define_function run() {
	stack_var slong rc;
	rc = ip_server_open(dvWEB.Port, 8000, IP_TCP);
}

define_function clearReq(){
	req.type = null;
	req.url  = null;
	req.file = null;
	req.cmd  = null;
	req.val  = null;
}

define_function print(integer A, char B[]) {
	stack_var integer lvl;
	stack_var char str[S01K];
	
	lvl = A;
	str = B;

	if((dbg) && (lvl <= dbg))
	{
		switch(lvl)
		{
			case dbgERR: str = "'ERR :: ' ,str";
			case dbgWRN: str = "'WRN :: ' ,str";
			case dbgDAT: str = "'DAT :: ' ,str";
			case dbgALL: str = "'INF :: ' ,str";
		}      
		
		if(length_string(str) <= 128)
		{
			send_string 0,"'>> ',svc.name,' :: ',str";
		}
		else
		{
			stack_var tstr[128];
			
			tstr = str;
			
			while(length_string(str) > 128)
			{
				tstr = get_buffer_string(str,128);
				send_string 0,"'>> ',svc.name,' :: ',tstr";
			}
			
			send_string 0,"'>> ',svc.name,' :: ',str";
		}
	}
}

define_function parse(char A[]) {
	stack_var char str[96];
	stack_var char cmd[16];
	
	str = A;
	
	if(find_string(str,"'-'",1)){
		cmd = remove_string(str,'-',1);
		set_length_string(cmd,length_string(cmd) - 1);
	} else {
		cmd = str;
	}
	
	cmd = upper_string(cmd);
	
	switch(cmd) {
		case 'NAME': 		svc.name = str;
		case 'TITLE': 	svc.title = str;
		case 'IP': 			svc.ip = str;
		case 'PORT': 		svc.port = atoi(str);
		case 'REINIT': 	init();
		case 'DEBUG':{
			dbg = atoi(str);
			print(dbg,"'Setting Debug To ',itoa(dbg)");
		}
		default:{}
	}
}

define_function exec(char A[], char B[]){
	stack_var char cmd[16];
	stack_var char val[16];
	
	cmd = A;
	val = B;
	
	switch(cmd){
		case 'btn': do_push(vdvWEB,atoi(val));
		case 'lvl': send_level vdvWEB,1,atoi(val);
		case 'str': send_string vdvWEB,val;
		case 'chn': {
			[vdvWEB,atoi(val)] = ![vdvWEB,atoi(val)];
			svc.chns[type_cast(itoa(val))] = !svc.chns[type_cast(itoa(val))];
		}
	}
}

#include 'res.axi';
#include 'req.axi';

define_start
{

}

define_event

data_event[dvWEB]{
	online:  {
	}
	offline: {
		run();
	}
	onerror: {
		print(dbgERR,'Server Has An Error')
	}
	string:  {
		stack_var char str[S08K];
		stack_var char res[S16K];
		stack_var char hdr[S02k];
		stack_var char typ[128];
		
		/////////////////////////////////////////////////////
		// Handle Request From Client
		
		str = data.text;
		
		if(find_string(str,"$0D,$0A,$0D,$0A",1)){
			hdr = remove_string(str,"$0D,$0A,$0D,$0A",1);
			set_length_string(hdr, length_string(hdr) - 2);
			
			typ = remove_string(hdr,"$0D,$0A",1);
			set_length_string(typ, length_string(typ) - 2);
			
			while(find_string(hdr,"$0D,$0A",1)){
				stack_var tmp[128];
				tmp = remove_string(hdr,"$0D,$0A",1);
				set_length_string(tmp, length_string(tmp) - 2);
				print(dbgDAT,tmp);
			}
		}
		else {
			print(dbgERR,'ERROR - NO HEADERS FOUND. Not Valid Web Request');
		}
		
		res = request(typ,str);
		
		/////////////////////////////////////////////////////
		// Return A Response To The Request
		
		
		if(length_string(res) > FILECHNK){
			stack_var char tmp[FILECHNK];
			
			while(length_string(res) > FILECHNK){
				tmp = get_buffer_string(res,FILECHNK);
				send_string dvWEB,tmp;
			}
		}
		
		send_string dvWEB,res;
		
		ip_server_close(dvWEB.Port);
		clearReq();
		
		wait 1 're-run'{
			run();
		}
	}
}

data_event[vdvWEB]{
	online: {
		wait 10 send_string vdvWEB,'READY';
	}
	command:{
		stack_var char str[96];
		str = data.text;
		parse(str);
	}
}

define_program
