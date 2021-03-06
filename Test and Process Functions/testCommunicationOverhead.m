% Test script for comparing the algorithms' performance in terms of communication
% overhead on the simulated track
% For each parameter value, the script generates the simulated track,
% measurements and runs the specified tracking algorithms for a number of
% MC trials
% Note that all algorithms can only track one single target
% Multiple targets with target birth/death, clutter measurements are not
% considered

% Jun Ye Yu
% McGill University
% jun.y.y.yu@mail.mcgill.ca
% Nov. 9th, 2017

warning('off','all');
clear;clc;
% Set path to helper functions
addpath('./DynamicModels/');
addpath('./HelperFunctions/');
addpath('./MeasurementModels/');
addpath('./TrackingAlgorithms/');

% Number of particles for the filter
N = 1000; 
gossip_vector = [1, 5, 10, 25, 50, 75, 100, 150, 200];

% Number of random trials
sim_parameters.no_trials = 200;

% Flag for parallel run
sim_parameters.parallel = true;

% Flag for visualizing at each time step
sim_parameters.visualizeParticles = false;

% Flag for using gossip or exact aggregate
sim_parameters.gossip = true;

% Select measurement model
sim_parameters.measModel = 'bearing';

% Select the track
sim_parameters.track = 2;

sim_parameters.graphMethod = 'Delaunay';

sim_parameters.weightedEdge = true;
sim_parameters.weightedEdgeStyle = 1;

% Tracking algorithms are
% 1. centralized bootstrap PF: BS
% 2. distributed CSS PF 
% 3. distributed LC PF
% 4. distributed Graph PF
% alg_lists = {@BSpf, @CSSpf_distributed, @LCpf_distributed, @LApf_distributed, @LADelaunaypf_distributed, @Clusterpf_distributed, @ClusterDelaunaypf_distributed};
alg_lists = {@BSpf, @CSSpf_distributed, @LCpf_distributed, @LCpf_GS_distributed, @LADelaunaypf_distributed, @ClusterDelaunaypf_distributed, @GApf_distributed};

sim_parameters.nbEig = 9;
sim_parameters.nbClusters = 25;
sim_parameters.max_degree = 2;

sim_parameters.N = N; 
% for j=[1,3,5,7,10]
%     sim_parameters.sigma = j;
for i=1:numel(gossip_vector)
    sim_parameters.algorithms = alg_lists(2:7);
    sim_parameters.max_gossip_iter = gossip_vector(i);

    % Run the simulated track with all selected tracking algorithms 
    % Each filter uses N particles   
    [results, parameters]= runSimulatedTrack(sim_parameters);

    % Store the tracking results
    filename{i} = ['Track2_Allpf_'];
%     filename{i} = [filename{i}, '_overhead',num2str(gossip_vector(i))];
    filename{i} = [filename{i}, '_gossip',num2str(parameters.max_gossip_iter)];
%     filename{i} = [filename{i}, '_R',num2str(sim_parameters.sigma)];
    filename{i} = [filename{i},'_N',num2str(parameters.F.N)];
    filename{i} = [filename{i},'_trials',num2str(parameters.no_trials)];
    filename{i} = [filename{i},'.mat'];
    save(filename{i}, 'results','parameters');
end
% end