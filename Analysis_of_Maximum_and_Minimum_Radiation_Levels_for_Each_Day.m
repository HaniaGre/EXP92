% | AUTHOR: Hanna Grechuta |
% | Analog Astronaut Training Center |
% | Expedition 92; 4-13.11.2024 |

% | DESCRIPTION BELOW |

% | This is one of MATLAB CODES, |
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

% Define measurement points for each room
rooms = struct(...
    'Bedroom', [1, 2, 3, 4, 5, 6, 7], ...
    'Kitchen_Laboratory', [8, 9, 10, 11, 12, 23], ...
    'GeoLab', [13, 14, 15, 16, 19], ...
    'WC', [20], ...
    'Bathroom', [17, 18], ...
    'Gym', [21, 22]);

% ===============================
% 1. Maximum and Minimum Radiation Levels for Each Day
% ===============================
unique_days = unique(all_data.DAY);
max_radiation_per_day = NaN(length(unique_days), 1);
min_radiation_per_day = NaN(length(unique_days), 1);

for d = 1:length(unique_days)
    day = unique_days{d};
    day_idx = strcmp(all_data.DAY, day);
    
    % Maximum and minimum radiation levels for the given day
    max_radiation_per_day(d) = max(all_data{day_idx, 'AVG [usv/h]'}, [], 'omitnan');
    min_radiation_per_day(d) = min(all_data{day_idx, 'AVG [usv/h]'}, [], 'omitnan');
end

% Display results for maximum and minimum radiation levels per day
disp('Maximum radiation levels for each day:');
disp(table(unique_days, max_radiation_per_day, 'VariableNames', {'Day', 'Max_Radiation'}));

disp('Minimum radiation levels for each day:');
disp(table(unique_days, min_radiation_per_day, 'VariableNames', {'Day', 'Min_Radiation'}));

% ===============================
% 2. Histogram of Radiation Level Distribution
% ===============================
figure;
histogram(all_data.('AVG [usv/h]'), 20); % 20 bins for the histogram
title('Radiation Level Distribution');
xlabel('Radiation Level (µSv/h)');
ylabel('Frequency');
grid on;

% ===============================
% 3. Variance Analysis of Radiation Over Time for Each Room
% ===============================
variance_per_room = struct();
fields = fieldnames(rooms);

for i = 1:numel(fields)
    room_name = fields{i};
    room_points = rooms.(room_name);

    % Filter data for selected measurement points in the given room
    room_idx = ismember(str2double(regexprep(all_data.('Measurement number'), 'No. ', '')), room_points);
    
    % Calculate the variance of radiation levels in the given room
    variance_per_room.(room_name) = var(all_data{room_idx, 'AVG [usv/h]'}, 'omitnan');
end

% Display variance results for each room
disp('Variance of radiation levels for each room:');
disp(variance_per_room);
