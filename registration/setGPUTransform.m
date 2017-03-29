function datacell = setGPUTransform(datacell)
for i=1:numel(datacell)
   str = datacell{i} ;
   if ~isempty(regexp(str,'(Resampler *'))
        datacell{i}=['(Resampler "OpenCLResampler")'];
        break;
   end
end
end