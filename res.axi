program_name = 'res'
(***********************************************************)
(*  FILE CREATED ON: 02/12/2015  AT: 14:31:51              *)
(***********************************************************)
(*  FILE_LAST_MODIFIED_ON: 02/16/2015  AT: 23:22:15        *)
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

define_function char[S04K] read(char A[]){
	stack_var slong 	fhd;   																			// stores the tag that represents the file (or and error code)
	local_var slong 	rsl;       																	// stores the number of bytes read (or an error code)
	stack_var char  	lne[512];    																// a buffer for reading one line.  Must be as big or bigger than the biggest line
	stack_var integer inc;
	stack_var char 		fle[128];
	stack_var char 		res[S04K];

	fle = "'www/',A";
	
	fhd = file_open(fle,FILE_READ_ONLY) 													// OPEN FILE FROM THE BEGINNING
	if(fhd > 0) {               																	// A POSITIVE NUMBER IS RETURNED IF SUCCESSFUL
		rsl = 1;              																			// seed with a good number so the loop runs at least once
		while(rsl > 0) {
			rsl = file_read_line(fhd, lne, max_length_string(lne)); 	// grab one line
			res = "res,lne";
		}
		file_close(fhd);
	}           
	else {
		print(dbgERR,"'FILE OPEN ERROR:',itoa(fhd)");  										// IF THE LOG FILE COULD NOT BE CREATED
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
	
	str = "str,'"chns":"',$0A";
	for(i = 1; i <= 8; i++){
		str = "str,itoa(svc.chns[i])";
		if(i < 8) {
			str = "str,','";
		}
	}
	str = "str,'",',$0A";
	
	/////////////////////////////////////////////////////////
	
	str = "str,'"lvls":"',$0A";
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

define_function char[S02K] headers(integer CD, integer CT, integer CL){
	stack_var char header[S02K];
	stack_var char mime[64];
	
	header = "'HTTP/1.1 ',htmlCode[CD],$0D,$0A";
	header = "header,'Server: Netlinx Web Service',$0D,$0A";
	header = "header,'Cache-Control: no-cache',$0D,$0A";
	header = "header,'Connection: close',$0D,$0A";
	
	header = "header,'Content-Type: ',mimeTyp[CT],'; charset=UTF-8',$0D,$0A";
	header = "header,'Content-Length: ',itoa(CL),$0D,$0A";
	
	header = "header,$0D,$0A";
	
	return header;
}

define_function char[S08K] homePage(){
	
	stack_var char header[S04K];
	stack_var char str[S04K];
	stack_var char file[S06K];
	
	str = "'<!DOCTYPE html>',$0A"
	str =	"str,'<html ng-app = "app">',$0A"
	str =	"str,'<head>',$0A";
	
	str =	"str,'<meta charset = "utf-8">',$0A";
	str =	"str,'<meta name = "viewport" content = "initial-scale=1, maximum-scale=1, user-scalable=no, width=device-width">',$0A";
	str =	"str,'<meta name = "apple-mobile-web-app-capable" content = "yes">',$0A";
	str =	"str,'<meta name = "apple-mobile-web-app-status-bar-style" content = "default">',$0A";
	
	str =	"str,'<title>',svc.title,'</title>',$0A";
	
	str =	"str,'<link rel = "stylesheet" href = "http://',svc.ip,'/www/css/bootstrap.min.css">',$0A";
	str =	"str,'<link rel = "stylesheet" href = "http://',svc.ip,'/www/css/app.css">',$0A";
	
	str =	"str,'<script src = "http://',svc.ip,'/www/js/jquery.min.js"></script>',$0A";
	str =	"str,'<script src = "http://',svc.ip,'/www/js/bootstrap.min.js"></script>',$0A";
	str =	"str,'<script src = "http://',svc.ip,'/www/js/angular.min.js"></script>',$0A";
	str =	"str,'<script src = "http://',svc.ip,'/www/js/app.js"></script>',$0A";
	str =	"str,'</head>',$0A";
	
	str =	"str,'<body ng-controller="AppCtrl">',$0A";
	str =	"str,'<div class="container">',$0A";
	
	str =	"str,'<ng-include src="',$27,'control.html',$27,'"></ng-include>'";
	
	str =	"str,'</div>',$0A";
	str =	"str,'</body>',$0A";
	str =	"str,'</html>',$0A";
	
	header = headers(1,1,length_string(str));
	return "header,str";
}

define_function char[S08K] resDefault() {
	stack_var char header[S04K];
	stack_var char str[S04K];

	str = "'{"cmd":"echo","val": 100}',$0D,$0A";
	header = headers(1,11,length_string(str));
	
	return "header,str";
}

define_function char[S16K] resFile(char A[]) {
	stack_var char header[S02K];
	stack_var char str[S14K];
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

	str = json('Test Message');
	header = headers(1,11,length_string(str));
	
	return "header,str";
}

define_function char[S08K] resFailed(char A[]) {
	
	stack_var char header[S02K];
	stack_var char str[S06K];
	stack_var char rsl[64];

	rsl = A;

	str = "'{"cmd":"',req.cmd,'","val": "',req.val,'", "result": "',rsl,'"}',$0D,$0A";
	header = headers(3,11,length_string(str));
	
	return "header,str";
}
