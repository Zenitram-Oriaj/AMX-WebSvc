program_name = 'req'
(***********************************************************)
(*  FILE CREATED ON: 02/13/2015  AT: 18:01:23              *)
(***********************************************************)
(*  FILE_LAST_MODIFIED_ON: 02/17/2015  AT: 13:33:34        *)
(***********************************************************)

define_function parameters(char A[]){
	stack_var char str[32];
	stack_var char prm[16];
	stack_var char val[16];
	
	str = A;
	
	prm = lower_string(remove_string(str,'=',1));
	set_length_string(prm, length_string(prm) - 1);
	
	switch(prm){
		case 'cmd':{
			req.cmd = str;
		}
		case 'val':{
			req.val = str;
		}
		case 'chn':{
			req.chn = str;
		}
		default: {
			print(dbgWRN,"'UNKNOWN PARAMETER TYPE --> ', prm");
		}
	}
}

define_function char[S16K] api(char A[]){
	stack_var char str[32];
	stack_var char tmp[32];
	stack_var char res[S16K];
	stack_var char bool;
	
	str = A;
	
	while(find_string(str,'&',1)){
		tmp = remove_string(str,'&',1);
		set_length_string(tmp, length_string(tmp) - 1);
		parameters(tmp);
	}
	
	parameters(str);
	
	print(dbgALL,"'Execute --> cmd = ',req.cmd,' :: val = ', req.val, ' :: chn = ', req.chn");
	
	exec(req.cmd, req.val, req.chn);
	
	res = resSuccess();
	return res;
}

define_function char[S16K] sql(char A[]){
	stack_var char res[S16K];
	stack_var char str[S01k];
	str = A;
	
	res = resSuccess();
	return res;
}

define_function char[S16K] get(char A[]){
	stack_var char str[S08K];
	stack_var char res[S16K];
	
	str = A;
	
	print(dbgALL,"'Process --> ', str");
	
	if(find_string(str,'?',1)){
		stack_var char tmp[32];
		
		tmp = lower_string(remove_string(str,'?',1));
		set_length_string(tmp, length_string(tmp) - 1);
		get_buffer_string(tmp,1);
		
		switch(tmp){
			case 'api': res = api(str);
			case 'sql': res = sql(str);
			default:    res = resDefault();
		}
	} 
	else if(find_string(str,'.',1)){
		get_buffer_string(str,1);
		res = resFile(str);
	}
	else {
		res = resDefault();
	}
	
	return res;
}

define_function char[S16K] post(char A[], char B[]){
	stack_var char str[S08K];
	stack_var char bod[S08K];
	stack_var char res[S16K];
	
	str = A;
	bod = B;
	
	print(dbgALL,"'Process --> ', str");
	print(dbgALL,"'Body    --> ', bod");

	res = resDefault();
	return res;
}

define_function char[S16K] request(char A[], char B[]){
	stack_var char str[128];
	stack_var char typ[8];
	stack_var char val[64];
	
	stack_var char bod[S08K];
	stack_var char res[S16K];
	
	str = A;
	bod = B;
	
	typ = remove_string(str,"' '",1);
	set_length_string(typ, length_string(typ) - 1);
	
	req.type = typ;
	
	switch(typ){
		case 'GET':{
			val = remove_string(str,"' '",1);
			set_length_string(val, length_string(val) - 1);
			
			req.url = val;
			
			if(length_string(val) > 3){
				res = get(val);
			}
			else {
				res = resIndex();
			}
			break;
		}
		case 'POST': {
			res = post(val, bod);
			break;
		}
		default: {
			res = resDefault();
			break;
		}
	}
	
	return res;
}