function [params] = niftiGetParamsFromDescrip(niftiFile)
% 
% function [params] = niftiGetParamsFromDescrip(niftiFile)
% 
% This function will take a nifti file and parse the descrip field to build
% a structure containing the included values.
% 
% ** Note that only nifti files created by NIMS (cni.stanford.edu/nims) 
%    will have these values in the descrip field.
% 
% ** Note also that this function read the nifti file, so speed is
%    completely dependent on file size.
% 
% 
% EXAMPLE USAGE:
%   [params] = niftiGetParamsFromNifti(niftiFile)
%
% OUTPUT:
% 
%   params = 
% 
%     niftiFile: '4534_10_1.nii.gz'
%            tr: 33
%            te: 2
%            ti: 0
%            fa: 20
%            ec: 0
%           acq: [192 256]
%            mt: 0
%            rp: 2
%            rs: 1
% 
% (C) Stanford Vista Lab 2014 - LMP
% 


%% Check input

if ~isstruct(niftiFile)
    if ~exist('niftiFile','var') || ~exist(niftiFile,'file')
        niftiFile=uigetfile('*.nii.gz','Choose nifti file');
    end
    % Read in the nifti 
    ni = niftiRead(niftiFile);
else
    ni = niftiFile; 
    clear niftiFile;
end

if ~isfield(ni,'descrip')
    warning('vista:niftiError','Descrip field does not exist. Returning [].');
    params = [];
    return
end

% Get the values from the descrip field into the workspace
eval([ni.descrip,';']);

% Get the TR from the 4th dimension of the nifti
tr = ni.dim(4); 

% Remove the nifti struct, so we don't save it.
clear ni 

% Set a temporary name to save to
name = tempname;
save(name);

% Load the values into the output struct
params    = load(name);
params.tr = tr;

% Remove the temporary name and file fields
if isfield(params,'name')
    params = rmfield(params,'name');
end
if isfield(params,'niftiFile')
    params = rmfield(params,'niftiFile');
end

return

