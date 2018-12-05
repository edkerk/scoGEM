function model = simulateCondition(model,strain,sample)% ,stdev)

if strcmp(strain,'M145')
    rates = dlmread('../../ComplementaryData/growth/M145_estimated_rates.csv',';',1,0);
elseif strcmp(strain,'M1152')
    rates = dlmread('../../ComplementaryData/growth/M1152_estimated_rates.csv',';',1,0);
else
    error('Only data for strains M145 and M1152 are available.');
end

if nargin < 3 | ~ismember(sample,rates(:,1))
    error('Please specify a sample from the list of available time-points:\n %s',...
        join(string(num2str(rates(:,1)))));
end

if nargin < 4
    stdev = false;
end

sampleIdx   = find(ismember(rates(:,1), sample));
UB          = rates(sampleIdx,3:end);
IDs         = {'BIOMASS_SCO','EX_glc__D_e_REV','EX_glu__L_e_REV',...
               'DM_RED_c','DM_germicidinA_c','DM_germicidinB_c'};
if strcmp(strain,'M1152')
    UB      = [UB(1:3) 0 UB(5:end)]; % No RED produced, set to zero.
end
           
model = setParam(model,'eq',IDs,abs(UB));
model = setParam(model,'obj','ATPM',1);
model = setParam(model,'ub','ATPM',0);
sol=solveLP(model)
end