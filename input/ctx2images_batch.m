% 4/20/06
% Save out a cortex image or movie as a series of png images
% 
% Set undouble to 1 if you want to unstretch a movie that was designed to
% run in stereo.

% Example arguements:
% input_filename = 'C:\Documents and Settings\common\My Documents\matlab\bpotetz\MonkeyStimulus (8_17_03)\2006_04_17 Gratings\movies\SWG_01.ctx';
% output_pathway = 'C:\Documents and Settings\common\My Documents\matlab\bpotetz\old\temp\';
% output_filename_base = 'test_images';
% undouble = 1;

% batch processing files in current directory, rpoplin, 04/27/2008

function ctx2images_batch(undouble)

files = dir('*.ctx');

for iii = 1:numel(files)

[imgmtx, dmns, ~] = loadcx([pwd '/' files(iii).name]);
w = dmns(2);
h = dmns(3);
n_frames = dmns(4);


for f = 1:n_frames
    output_filename = [pwd '/' files(iii).name(1:end-4), sprintf('_%03d.png',f)];
    im = imgmtx(1 + (f-1)*h : f*h,:);
    if (undouble == 1)
        im = im(:, 1:2:end);
    end
    imwrite((im-128)/127, output_filename);
end 

if n_frames == 0
    output_filename = [pwd '/' files(iii).name(1:end-4), sprintf('.png')];
    im = imgmtx(1:h,:);
    if (undouble == 1)
        im = im(:, 1:2:end);
    end
    imwrite((im-128)/127, output_filename);
end


end;