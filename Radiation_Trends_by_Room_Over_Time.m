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

% Extract unique days to analyze time trends
unique_days = unique(all_data.DAY);

% Initialize a structure to store daily radiation averages for each room
room_trends = struct();

% Loop through each room and calculate average radiation per day
fields = fieldnames(rooms);
for i = 1:numel(fields)
    room_name = fields{i};
    room_points = rooms.(room_name);

    % Initialize array to hold daily averages
    daily_avg_radiation = NaN(length(unique_days), 1);
    
    for d = 1:length(unique_days)
        day = unique_days{d};

        % Filter data for the current room and day
        day_idx = strcmp(all_data.DAY, day);
        room_idx = ismember(str2double(regexprep(all_data.('Measurement number'), 'No. ', '')), room_points);
        idx = day_idx & room_idx;

        % Calculate the average radiation level for the room on the current day
        daily_avg_radiation(d) = mean(all_data{idx, 'AVG [usv/h]'}, 'omitnan');
    end
    
    % Store daily averages in the structure
    room_trends.(room_name) = daily_avg_radiation;
end

% Plot trends for each room
figure;
hold on;
colors = lines(numel(fields)); % Use different colors for each room

for i = 1:numel(fields)
    room_name = fields{i};
    plot(1:length(unique_days), room_trends.(room_name), '-o', 'DisplayName', room_name, 'Color', colors(i, :));
end

hold off;
title('Radiation Trends Over Time by Room');
xlabel('Days');
ylabel('Average Radiation (µSv/h)');
xticks(1:length(unique_days));
xticklabels(unique_days);
legend('show', 'Location', 'Best');
grid on;
