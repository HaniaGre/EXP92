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

% Define safety thresholds in µSv/h
public_limit = 0.114; % General public limit (1 mSv/year)
occupational_limit = 2.28; % Occupational limit (20 mSv/year)

% Define measurement points and days
unique_measurement_points = unique(all_data.('Measurement number'));
unique_days = unique(all_data.DAY);

% Initialize matrix to store average radiation levels for each day and point
radiation_by_day = NaN(length(unique_measurement_points), length(unique_days));

% Loop through each day and measurement point to calculate average radiation levels
for d = 1:length(unique_days)
    for p = 1:length(unique_measurement_points)
        % Filter data for the specific day and measurement point
        day_idx = strcmp(all_data.DAY, unique_days{d});
        point_idx = strcmp(all_data.('Measurement number'), unique_measurement_points{p});
        idx = day_idx & point_idx;
        
        % Calculate the average radiation level for the current day and point
        radiation_by_day(p, d) = mean(all_data{idx, 'AVG [usv/h]'}, 'omitnan');
    end
end

% Compare radiation levels with safety thresholds
is_safe_public = radiation_by_day < public_limit;
is_safe_occupational = (radiation_by_day >= public_limit) & (radiation_by_day <= occupational_limit);
exceeds_occupational = radiation_by_day > occupational_limit;

% Plot radiation levels across all days for each measurement point with color-coded safety levels
figure;
hold on;
for p = 1:length(unique_measurement_points)
    for d = 1:length(unique_days)
        if is_safe_public(p, d)
            plot(d, radiation_by_day(p, d), 'go', 'MarkerSize', 8); % Green for public-safe levels
        elseif is_safe_occupational(p, d)
            plot(d, radiation_by_day(p, d), 'yo', 'MarkerSize', 8); % Yellow for occupational-safe levels
        elseif exceeds_occupational(p, d)
            plot(d, radiation_by_day(p, d), 'ro', 'MarkerSize', 8); % Red for levels exceeding occupational limits
        end
    end
end
hold off;
title('Radiation Levels Comparison with Safety Standards');
xlabel('Days');
ylabel('Average Radiation (µSv/h)');
xticks(1:length(unique_days));
xticklabels(unique_days);
legend({'Safe for Public', 'Safe for Occupational', 'Exceeds Occupational'}, 'Location', 'Best');
grid on;

% Summary Table of Points Exceeding Limits
exceeding_points = unique_measurement_points(any(exceeds_occupational, 2));
exceeding_days = unique_days(any(exceeds_occupational, 1));
disp('Measurement points and days exceeding occupational safety limits:');
disp(table(exceeding_points, 'VariableNames', {'Measurement Points'}));
disp(table(exceeding_days, 'VariableNames', {'Days'}));
