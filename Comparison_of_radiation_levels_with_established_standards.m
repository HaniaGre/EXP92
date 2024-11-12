% | AUTHOR: Hanna Grechuta |
% | Analog Astronaut Training Center |
% | Expedition 92; 4-13.11.2024 |

% | DESCRIPTION BELOW |

% |This is one of MATLAB CODES, |
% | used in "Analysis of gamma and beta radiation levels in the Habitat" |
% | research paper.|

% | Research paper can be read at this link: |
% | https://linktr.ee/hannagrechuta |

% | This research paper presents the results of beta and gamma radiation |
% | analysis at the Habitat site located in Rzepiennik Strzyżewski |
% | during the analogue mission - expedition no. 92. |

% | Last modified on 10.11.2024 |


% Load the radiation data
all_data = readtable('Radiation map - ALL DATA.csv', 'VariableNamingRule', 'preserve');

% Define safety thresholds in µSv/h
public_limit = 0.114; % General public limit (1 mSv/year)
occupational_limit = 2.28; % Occupational limit (20 mSv/year)

% Define measurement points for each room
rooms = struct(...
    'Bedroom', [1, 2, 3, 4, 5, 6, 7], ...
    'Kitchen_Laboratory', [8, 9, 10, 11, 12, 23], ...
    'GeoLab', [13, 14, 15, 16, 19], ...
    'WC', [20], ...
    'Bathroom', [17, 18], ...
    'Gym', [21, 22]);

% Initialize structure to store results
exceeds_public_limit = struct();
exceeds_occupational_limit = struct();

% Check radiation levels for each room
fields = fieldnames(rooms);
for i = 1:numel(fields)
    room_name = fields{i};
    room_points = rooms.(room_name);

    % Filter data for the current room
    room_idx = ismember(str2double(regexprep(all_data.('Measurement number'), 'No. ', '')), room_points);
    avg_radiation = all_data{room_idx, 'AVG [usv/h]'};

    % Check how many values exceed public and occupational limits
    exceeds_public_limit.(room_name) = sum(avg_radiation > public_limit);
    exceeds_occupational_limit.(room_name) = sum(avg_radiation > occupational_limit);
end

% Display results
disp('Number of measurements exceeding the general public limit in each room:');
disp(exceeds_public_limit);

disp('Number of measurements exceeding the occupational limit in each room:');
disp(exceeds_occupational_limit);

% Summary report
fprintf('\nSummary of rooms exceeding safety thresholds:\n');
for i = 1:numel(fields)
    room_name = fields{i};
    fprintf('%s: Public limit exceeded %d times, Occupational limit exceeded %d times\n', ...
        room_name, exceeds_public_limit.(room_name), exceeds_occupational_limit.(room_name));
end
