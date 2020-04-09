function modify_b2neutrals(input)

% Read the input.dat template
b2neut_text = fileread([input.template_dir,'b2.neutrals.parameters.template']);

% Replace all occurances of "NX" and "NY" with their actual values:
tmp = strfind(b2neut_text, '   NX');
b2neut_text(tmp:tmp+4)=sprintf('%5d',input.nx+input.makekink*input.kink_nx);
tmp = strfind(b2neut_text, ' NY-1');
b2neut_text(tmp:tmp+4)=sprintf('%5d',input.ny-1);

% Now write out the b2ag.dat file:
fid = fopen([input.ref_dir,'/b2.neutrals.parameters'],'w');
fprintf(fid,'%s\n',b2neut_text);
fclose(fid);