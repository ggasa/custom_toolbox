function choice = bigmenu(prompt, options, varargin)
% BIGMENU Display a resizable menu dialog with big buttons and font, with spacing and Cancel button.
% Usage:
%   idx = bigmenu('Choose an option:', {'A', 'B', 'C'});
% Optional Name-Value pairs:
%   'Title'        - Figure window title (default: 'Select an option')
%   'FontSize'     - Font size (default: 18)
%   'ButtonWidth'  - Width of buttons (default: 320)
%   'ButtonHeight' - Height of buttons (default: 48)
%   'Gap'          - Gap (pixels) between prompt and first button (default: 36)
%   'ButtonSpacing'- Gap (pixels) between buttons (default: 14)

p = inputParser;
addParameter(p, 'Title', 'Select an option');
addParameter(p, 'FontSize', 18);
addParameter(p, 'ButtonWidth', 320);
addParameter(p, 'ButtonHeight', 48);
addParameter(p, 'Gap', 36);
addParameter(p, 'ButtonSpacing', 14);
parse(p, varargin{:});

n = numel(options);
choice = 0; % default if closed/canceled

% Calculate window size (add extra height for Cancel button)
extraSpace = 60; % space for cancel button and margin
figW = p.Results.ButtonWidth + 80;
figH = 50 + p.Results.Gap + n*p.Results.ButtonHeight + (n-1)*p.Results.ButtonSpacing + extraSpace;

% Close callback: always resumes and deletes
function closefig(~, ~)
    uiresume(f);
    if isvalid(f), delete(f); end
end

f = uifigure('Name', p.Results.Title, ...
    'Position', [100 100 figW figH], ...
    'Resize', 'on', ...
    'CloseRequestFcn', @closefig);

% Prompt label
uilabel(f, ...
    'Text', prompt, ...
    'FontSize', p.Results.FontSize+2, ...
    'Position', [40 figH-50 p.Results.ButtonWidth 32], ...
    'HorizontalAlignment', 'center');

% Buttons for options
btns = gobjects(n,1);
for i = 1:n
    y = figH - 50 - p.Results.Gap - (i-1)*(p.Results.ButtonHeight + p.Results.ButtonSpacing);
    btns(i) = uibutton(f, ...
        'Text', options{i}, ...
        'FontSize', p.Results.FontSize, ...
        'Position', [40 y p.Results.ButtonWidth p.Results.ButtonHeight], ...
        'ButtonPushedFcn', @(src,evt) pick(i));
end

% Cancel/Quit button
yCancel = 20; % at the bottom
uibutton(f, ...
    'Text', 'Cancel', ...
    'FontSize', p.Results.FontSize, ...
    'Position', [figW/2-80 yCancel 160 38], ...
    'ButtonPushedFcn', @(src,evt) closefig());

    function pick(idx)
        choice = idx;
        uiresume(f);
        if isvalid(f), delete(f); end
    end

uiwait(f);
if isvalid(f)
    delete(f);
end
end
