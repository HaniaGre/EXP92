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

% Extract unique days
unique_days = unique(all_data.DAY);

% Initialize arrays to store max and min radiation for each day
max_radiation_per_day = NaN(length(unique_days), 1);
min_radiation_per_day = NaN(length(unique_days), 1);

% Calculate max and min radiation for each day
for d = 1:length(unique_days)
    day = unique_days{d};
    day_idx = strcmp(all_data.DAY, day);
    
    % Find the maximum and minimum radiation levels for the current day
    max_radiation_per_day(d) = max(all_data{day_idx, 'AVG [usv/h]'}, [], 'omitnan');
    min_radiation_per_day(d) = min(all_data{day_idx, 'AVG [usv/h]'}, [], 'omitnan');
end

% Plot daily maximum vs. minimum radiation levels
figure;
plot(1:length(unique_days), max_radiation_per_day, '-o', 'LineWidth', 1.5, 'DisplayName', 'Max Radiation');
hold on;
plot(1:length(unique_days), min_radiation_per_day, '-o', 'LineWidth', 1.5, 'DisplayName', 'Min Radiation');
hold off;

% Add labels and title
title('Daily Maximum vs. Minimum Radiation Levels');
xlabel('Days');
ylabel('Radiation Level (µSv/h)');
xticks(1:length(unique_days));
xticklabels(unique_days);
legend('show', 'Location', 'Best');
grid on;
