function copy_standard_files(input)

copyfile([input.standard_dir,'b2ah.dat'],input.baserun_dir);
copyfile([input.standard_dir,'b2ai.dat'],input.baserun_dir);
copyfile([input.standard_dir,'b2ar.dat'],input.baserun_dir);
copyfile([input.standard_dir,'tria.elemente'],input.baserun_dir);
copyfile([input.standard_dir,'tria.neighbor'],input.baserun_dir);
copyfile([input.standard_dir,'tria.nodes'],input.baserun_dir);

copyfile([input.standard_dir,'b2mn.dat'],input.ref_dir);
copyfile([input.standard_dir,'b2.transport.parameters'],input.ref_dir);