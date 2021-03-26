function modify_paramdotdg(contour,grid,input)

% Read the param.dg template
paramdotdg_text = fileread([input.template_dir,'param.dg']);
% Input for p1
p1 = sprintf('');
nonconnect = 0;
for iseg = 1:size(contour.seg,1)
    p1 = [p1,sprintf('  %.1f,  %.1f, %.3f,\n',1000*contour.seg(iseg,1),1000*contour.seg(iseg,2),0.000)];
    if iseg>2
        if contour.seg(iseg,1)==contour.seg(iseg-1,3) && contour.seg(iseg,2)==contour.seg(iseg-1,4)
        nonconnect = nonconnect;
        else
        nonconnect = nonconnect + 1;
        addseg(nonconnect) = iseg;
        end
    end
end
for iseg = 1:size(contour.pump,1)
    p1 = [p1,sprintf('  %.1f,  %.1f, %.3f,\n',1000*contour.pump(iseg,1),1000*contour.pump(iseg,2),0.000)];
end
for iseg = 1:nonconnect
    p1 = [p1,sprintf('  %.1f,  %.1f, %.3f,\n',1000*contour.seg(addseg(iseg)-1,3),1000*contour.seg(addseg(iseg)-1,4),0.000)];
end
p1 = [p1,sprintf('  %.1f,  %.1f, %.3f,\n',1000*contour.seg(size(contour.seg,1),3),1000*contour.seg(size(contour.seg,1),4),0.000)];
tmp = strfind(paramdotdg_text, 'p2');
paramdotdg_text = [paramdotdg_text(1:tmp-1),p1,paramdotdg_text(tmp:end)];
%Input for p2
p2 = sprintf('');
nonconnect = 0;
for iseg = 1:size(contour.seg,1)
    p2 = [p2,sprintf('  %.1f,  %.1f, %.3f,\n',1000*contour.seg(iseg,3),1000*contour.seg(iseg,4),0.000)];
    if iseg>2
        if contour.seg(iseg,1)==contour.seg(iseg-1,3) && contour.seg(iseg,2)==contour.seg(iseg-1,4)
        nonconnect = nonconnect;
        else
        nonconnect = nonconnect + 1;
        addseg(nonconnect) = iseg;
        end
    end
end
for iseg = 1:size(contour.pump,1)
    p2 = [p2,sprintf('  %.1f,  %.1f, %.3f,\n',1000*contour.pump(iseg,3),1000*contour.pump(iseg,4),0.000)];
end
for iseg = 1:nonconnect
    p2 = [p2,sprintf('  %.1f,  %.1f, %.3f,\n',1000*contour.seg(addseg(iseg),1),1000*contour.seg(addseg(iseg),2),0.000)];
end
p2 = [p2,sprintf('  %.1f,  %.1f, %.3f,\n',1000*contour.seg(1,1),1000*contour.seg(1,2),0.000)];
tmp = strfind(paramdotdg_text, 'material');
paramdotdg_text = [paramdotdg_text(1:tmp-1),p2,paramdotdg_text(tmp:end)];
%Input for material
material = sprintf('');
for iseg = 1:size(contour.seg,1)+nonconnect+1
    material = [material,sprintf('  C\n')];
end
tmp = strfind(paramdotdg_text, 'plotzone');
paramdotdg_text = [paramdotdg_text(1:tmp-1),material,paramdotdg_text(tmp:end)];
%Plotzone
tmp = strfind(paramdotdg_text, 'plotzone');
pltzseg = sprintf('');
pltzsw = 0;
pltzsegst = 1;%dummy
%contour.seg(4,1)
for iseg = 1:size(contour.seg,1)
    if abs(contour.seg(iseg,1)-input.pltzst(1))<0.001
%if 10*contour.seg(iseg,1)==input.pltzst
        pltzsegst = iseg;      
        pltzsw = 1;
    end
end
for iseg = pltzsegst:size(contour.seg,1)
    if pltzsw == 1
        pltzseg = [pltzseg, sprintf('  %d\n',iseg)];
        %       if 10*contour.seg(iseg,4)==input.pltzfn(1)
        if abs(contour.seg(iseg,3)-input.pltzfn(1))<0.001
            pltzsw = 0;
            %         iseg
        end
    end
end
tmp = strfind(paramdotdg_text, 'starting');
paramdotdg_text = [paramdotdg_text(1:tmp-1),pltzseg,paramdotdg_text(tmp:end)];
%Plotzone - starting element -
tmp = strfind(paramdotdg_text, 'PS');
paramdotdg_text(tmp:tmp+1)=sprintf('%2d',pltzsegst);
%Replace "IS" and "IP"
tmp = strfind(paramdotdg_text, 'IS');
paramdotdg_text(tmp:tmp+1)=sprintf('%2d', 1);
tmp = strfind(paramdotdg_text, 'IP');
paramdotdg_text(tmp:tmp+1)=sprintf('%2d',size(contour.seg,1));
%Add segment list
segmlist = sprintf('');
il = 0;
for iseg = 1:size(contour.seg,1)
    il = il + 1;
    segmlist = [segmlist,sprintf('  %d\n', il)];
end
for iseg = 1:size(contour.pump,1)
    il = il + 1;
end
for iseg = 1:nonconnect+1
    il = il + 1;
    segmlist = [segmlist,sprintf('  %d\n', il)];
end
tmp = strfind(paramdotdg_text, 'finish');
paramdotdg_text = [paramdotdg_text(1:tmp-1),segmlist,paramdotdg_text(tmp:end)];
% Now write out the param.dg file:
fid = fopen([input.ref_dir,'/param.dg'],'w');
fprintf(fid,'%s\n',paramdotdg_text);
fclose(fid);
