% Parameters for the simulation
mapFileName = "office_example.stl";  
fc = 5.8e9;  
lambda = physconst("lightspeed") / fc;  % Wavelength
room_size = [5, 8, 2]';  

% Transmitter parameters
antenna_type = 'isotropic';
tx_params.antenna_type = antenna_type;
tx_params.fc = fc;  
tx_params.locs = [0.2, 0.2, 4.8, 4.8; ... % X locations
                  0.2, 7.8, 4.0, 1.0; ... % Y locations
                  1.9, 1.9, 1.9, 1.9];  % Z locations


% Receiver parameters
test_params.config = 1;  % Grid configuration
test_params.antenna_type = antenna_type;
test_params.numRx = 8;  % Exactly 8 receivers
test_params.rx_Height = 0.95;  
test_params.delta_x = 1.0;  
test_params.delta_y = 1.0;  
test_params.z_loc = 0.9;  
test_params.edge_spacing = [0.55, 0.25];  

tx_params.tx_power_dBm = 30;  % Transmit power in dBm (e.g., 30 dBm)

% Define receiver sites based on the input configuration
configuration = test_params.config;
switch configuration
    case 1  % Grid Deployment (count)
        grid_size = [2, 4];  
        edge = test_params.edge_spacing;
        delta_x = (room_size(1) - 2*edge(1)) / (grid_size(1) - 1);
        delta_y = (room_size(2) - 2*edge(2)) / (grid_size(2) - 1);
        x_locs = edge(1):delta_x:(room_size(1)-edge(1));
        y_locs = edge(2):delta_y:(room_size(2)-edge(2));
        
        % Adjust to ensure exactly 8 receivers (2x4 grid)
        if length(x_locs) > 2
            x_locs = x_locs(1:2);  % Select first 2 locations
        end
        if length(y_locs) > 4
            y_locs = y_locs(1:4);  % Select first 4 locations
        end
        
        rx_locs = [kron(x_locs, ones(1, length(y_locs))); ...
                   repmat(y_locs, 1, length(x_locs)); ...
                   test_params.z_loc * ones(1, length(x_locs) * length(y_locs))];
    case 2  % Grid Deployment (spacing)
        delta_x = test_params.delta_x;
        delta_y = test_params.delta_y;
        z_loc = test_params.z_loc;
        edge = test_params.edge_spacing;
        
        % Calculate receiver locations based on spacing for exactly 8 receivers
        x_locs = edge(1):delta_x:(room_size(1)-edge(1));
        y_locs = edge(2):delta_y:(room_size(2)-edge(2));
        
        % Ensure that we have exactly 8 receivers, adjust number of points
        if length(x_locs) > 2
            x_locs = x_locs(1:2);  % Select first 2 locations
        end
        if length(y_locs) > 4
            y_locs = y_locs(1:4);  % Select first 4 locations
        end
        
        rx_locs = [kron(x_locs, ones(1, length(y_locs))); ...
                   repmat(y_locs, 1, length(x_locs)); ...
                   z_loc * ones(1, length(x_locs) * length(y_locs))];
    case 3  % Random Deployment
        numRx = 8;  
        rx_Height = test_params.rx_Height;
        rx_locs = [room_size(1) * rand(numRx, 1)'; ...
                   room_size(2) * rand(numRx, 1)'; ...
                   rx_Height * ones(1, numRx)];
end

% Create the transmitter and receiver site objects
rxs = rxsite("cartesian", ...
             "Antenna", test_params.antenna_type, ...
             "AntennaPosition", rx_locs, ...
             "AntennaAngle", [0; 90]);
         
txs = txsite("cartesian", ...
             "Antenna", tx_params.antenna_type, ...
             "AntennaPosition", tx_params.locs, ...
             "TransmitterFrequency", tx_params.fc);

% Visualize the site layout in the Site Viewer
siteviewer("SceneModel", mapFileName);
show(txs, "ShowAntennaHeight", false);  
show(rxs, "ShowAntennaHeight", false);  

% Define the propagation model (Ray Tracing)
pm = propagationModel("raytracing", ...
    "CoordinateSystem", "cartesian", ...
    "Method", "sbr", ...
    "AngularSeparation", "low", ...
    "MaxNumReflections", 0, ...
    "SurfaceMaterial", "concrete");

% Perform ray tracing
rays = raytrace(txs, rxs, pm);


