function [FinalImage] = ReadTifStack(stackname)
%Read multipage tiff stack into volumetric image
display('Reading stack...')

w = warning('query','last');
if ~isempty(w)
    id = w.identifier;
    warning('off',id); 
end

InfoImage=imfinfo(stackname);
mImage=InfoImage(1).Width;
nImage=InfoImage(1).Height;
NumberImages=length(InfoImage);
FinalImage=zeros(nImage,mImage,NumberImages);
TifLink = Tiff(stackname, 'r');
for j=1:NumberImages
    TifLink.setDirectory(j);
    FinalImage(:,:,j)=TifLink.read();
end
TifLink.close();

end

