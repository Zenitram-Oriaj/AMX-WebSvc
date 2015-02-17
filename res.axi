program_name = 'res'
(***********************************************************)
(*  FILE CREATED ON: 02/12/2015  AT: 14:31:51              *)
(***********************************************************)
(*  FILE_LAST_MODIFIED_ON: 02/17/2015  AT: 11:02:16        *)
(***********************************************************)

define_constant

char htmlCode[][16] = {
	'200 OK',
	'404 Not Found',
	'500 Error'
}

char mimeExt[][8] = {
	'html',		// 01 -
	'css',		// 02 -
	'js',			// 03 -
	'txt',		// 04 -
	'xml',		// 05 -
	'jpg',		// 06 -
	'jpeg',		// 07 -
	'gif',		// 08 -
	'png',		// 09 -
	'svg',		// 10 -
	'json',		// 11 -
	'ttf',		// 12 -
	'ico'			// 12 -
}

char mimeTyp[][32] = {
	'text/html',								// 01 - 
	'text/css',									// 02 - 
	'text/javascript',					// 03 - 
	'text/plain',								// 04 - 
	'text/xml',           			// 05 - 
	'image/jpeg',        				// 06 - 
	'image/jpeg',         			// 07 - 
	'image/gif',          			// 08 - 
	'image/png',         				// 09 - 
	'image/svg+xml',      			// 10 - 
	'application/json',   			// 11 - 
	'application/x-font-ttf',  	// 12 - 
	'image/ico'	      	   			// 13 - 
}                           

define_function char[S16K] read(char A[]){
	stack_var slong 	fhd;
	local_var slong 	rsl;
	stack_var integer inc;
	stack_var char 		fle[128];
	stack_var char 		res[S16K];

	fle = "svc.root,A";
	
	fhd = file_open(fle,FILE_READ_ONLY);
	if(fhd > 0) {
		rsl = 1;
		rsl = file_read(fhd, res, S16K);
		file_close(fhd);
		print(dbgDAT,"'FILE OPEN SUCCESS: Size = ',itoa(length_string(res))");
	}           
	else {
		print(dbgERR,"'FILE OPEN ERROR:',itoa(fhd)");
		res = "'<body><h1>ERROR OPENING FILE</h1></body>'";
	}
	
	return res;
}

define_function char[S01K] json(char A[]){
	stack_var char str[S02K];
	stack_var char msg[64];
	stack_var integer i;
	
	msg = A;
	
	str = "str,'{',$0A";
	
	/////////////////////////////////////////////////////////
	
	str = "str,'"datetime":"',date,'T',time,'.000",',$0A"
	
	str = "str,'"msg":"',msg,'",',$0A"
	
	/////////////////////////////////////////////////////////
	
	str = "str,'"chns":"'";
	for(i = 1; i <= 8; i++){
		str = "str,itoa(svc.chns[i])";
		if(i < 8) {
			str = "str,','";
		}
	}
	str = "str,'",',$0A";
	
	/////////////////////////////////////////////////////////
	
	str = "str,'"lvls":"'";
	for(i = 1; i <= 8; i++){
		str = "str,itoa(svc.lvls[i])";
		if(i < 8) {
			str = "str,','";
		}
	}
	str = "str,'"',$0A";
	
	/////////////////////////////////////////////////////////
	
	str = "str,'}',$0A";
	
	return str;
}

define_function char[S02K] headers(integer A, integer B, integer C){
	stack_var char header[S02K];
	stack_var char mime[64];
	stack_var integer CD;
	stack_var integer CT;
	stack_var integer CL;
	
	CD = A;
	CT = B;
	CL = C;
	
	header = "'HTTP/1.1 ',htmlCode[CD],$0D,$0A";
	header = "header,'Server: Netlinx Web Service',$0D,$0A";
	header = "header,'Cache-Control: no-cache',$0D,$0A";
	header = "header,'Connection: close',$0D,$0A";
	
	header = "header,'Content-Type: ',mimeTyp[CT],'; charset=UTF-8',$0D,$0A";
	header = "header,'Content-Length: ',itoa(CL),$0D,$0A";
	
	header = "header,$0D,$0A";
	
	return header;
}

define_function char[S16K] resIndex(){
	stack_var char header[S04K];
	stack_var char html[S16K];
	
	html = read('index.html');
	
	header = headers(1,1,length_string(html));
	return "header,html";
}

define_function char[S16K] resDefault() {
	stack_var char header[S04K];
	stack_var char str[S16K];

	str = json('OK');
	header = headers(1,11,length_string(str));
	
	return "header,str";
}

define_function char[S16K] resFile(char A[]) {
	stack_var char header[S02K];
	stack_var char str[S16K];
	stack_var char ext[8];
	stack_var char file[32];
	stack_var integer i;
	stack_var integer j;
	
	file = A;
	str = read(file);
	
	remove_string(file,'.',1);
	ext = file;
	
	for(i = 1; i <= length_array(mimeExt); i++){
		if(ext == mimeExt[i]){
			j = i;
			break;
		}
	}
	
	if(j == 0){
		j = 1;
	}
	
	header = headers(1,j,length_string(str));
	return "header,str";
}

define_function char[S08K] resSuccess() {
	
	stack_var char header[S02K];
	stack_var char str[S06K];

	str = json('OK');
	header = headers(1,11,length_string(str));
	
	return "header,str";
}

define_function char[S08K] resFailed(char A[]) {
	
	stack_var char header[S02K];
	stack_var char str[S06K];
	stack_var char rsl[64];

	rsl = A;

	str = json('ERROR');
	header = headers(3,11,length_string(str));
	
	return "header,str";
}
