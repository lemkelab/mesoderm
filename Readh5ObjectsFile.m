function [coordinates] = Readh5ObjectsFile(ProjectFile,folder)
%%%Extracts xyz coordinates of object centroids from an Ilastik object
%%%classfication ilp file

%Relative h5 file Path of the Ilastik Project File
fpath = ProjectFile;
%Path of object coordinates path within h5 
oPathbeg = strcat('/ObjectExtraction/RegionFeatures/',folder,'/');
oPathend = '/Default features/RegionCenter';

%Number of time points to be read.
Timepoints = 1;
tnr = Timepoints;

h = h5info(fpath,oPathbeg);

%get info about the timepoints present on h5 file: important because of
%Ilastik only saves time points that are loaded during the
%project session 
for i = 1:length(h.Groups)
    if i == 1
        allnames = h.Groups(i).Name;
    end
    allnames = strcat(allnames,h.Groups(i).Name);
end

%Read all timepoints and save them in coordinates array
for k = 1:tnr
    j = k-1;
    ctp = num2str(j);
    ntp = num2str(j+1);
    tp = strcat('[[',ctp,'], [',ntp,']]');
    if ~isempty(findstr(tp, allnames))
        iPath = strcat(oPathbeg,tp,oPathend);
        coordinates{k} = h5read(fpath, iPath);
    end
end

for i = 1:Timepoints
    coordinates{1,i} = transpose(coordinates{1,i}(:,2:end));
end

coordinates = coordinates{1,1}; 

end