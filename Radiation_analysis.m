% Load the radiation data
all_data = readtable('Radiation map - ALL DATA.csv', 'VariableNamingRule', 'preserve');

% Define coordinates for each measurement point (approximate positions based on layout)
measurement_coords = [
    1, 10; 2, 10; 3, 10; 1, 8; 1, 6; 2, 6; 3, 6; 4, 10; 4, 8; 2.5, 8;
    3, 7; 4, 6; 5, 10; 5, 8; 5, 6; 5, 4; 6, 6; 6, 4; 5, 2; 4, 2; 3, 2; 2, 2; 1, 2
];

% Calculate average radiation levels for each measurement point across all days
unique_points = unique(all_data.('Measurement number'));
average_radiation = NaN(length(unique_points), 1);

for i = 1:length(unique_points)
    idx = strcmp(all_data.('Measurement number'), unique_points{i});
    average_radiation(i) = mean(all_data{idx, 'AVG [usv/h]'}, 'omitnan'); % Average radiation for each point
end

% Create a grid for interpolation
x_range = linspace(min(measurement_coords(:,1))-1, max(measurement_coords(:,1))+1, 100);
y_range = linspace(min(measurement_coords(:,2))-1, max(measurement_coords(:,2))+1, 100);
[x_grid, y_grid] = meshgrid(x_range, y_range);

% Interpolate radiation data over the grid for a smooth map
radiation_grid = griddata(measurement_coords(:,1), measurement_coords(:,2), average_radiation, x_grid, y_grid, 'linear');

% Plot the radiation intensity heatmap
figure;
imagesc(x_range, y_range, radiation_grid);
set(gca, 'YDir', 'normal'); % Correct Y-axis direction
colormap hot; % Use a "hot" colormap to represent intensity
colorbar;
title('Radiation Intensity Map of Measurement Points');
xlabel('X Coordinate');
ylabel('Y Coordinate');
hold on;

% Overlay measurement points for reference
scatter(measurement_coords(:,1), measurement_coords(:,2), 100, 'k', 'filled');
text(measurement_coords(:,1), measurement_coords(:,2), unique_points, ...
    'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'center', 'Color', 'white');

hold off;
